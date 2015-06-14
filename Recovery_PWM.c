/****************************************************************************************************************************************************************************
 * FILE NAME: Recovery_PWM.c
 * Version: 1.1
 * Description: Control circuit of the servo that detaches the parachute.
 * Programmers: Davide Rossi, Matteo Franceschini
 * Target: PIC 18F1330
 * Compiler: MikroC PIC18
 * IDE: MikroC PRO v6.0.0
 * Prog. PIC: mikroProg
 * Date created: November 2013
 * Copyright: SKYWARD EXPERIMENTAL ROCKETRY
 *
 * DESCRIPTION
 * The program receives on the the pins YODA_ATTIVA_VALVOLE and YODA_SGANCIA_ANELLO the signal to activate, respectively, the servo motors (that unlatch the drogue) and the H-bridge 
 * for the DC motor which unlatches the ring (and, therefore, the chute).
 * We also have two other pins for additional control: these are signals from the main MCU that indicate engine ignition and retraction from the ramp, respectively, 
 * on SEGNALE_DISTACCO and SEGNALE_ACCENSIONE. In the first version these were the trigger for the timers calculating the automatic release, but in the final version they will not be used, 
 * because the unlaches are calculated in the main MCU.
 * When the PIC receives active high signals on YODA_ATTIVA_VALVOLE and YODA_SGANCIA_ANELLO it sets the pins ACK_VALVOLE and ACK_ANELLO, indicating that the signal was received and 
 * the unlatch has successfully been made.
 *
 * To control the servo motors, the PIC generates a PWM at 100Hz, with a variable duty cycle: the angular position of the servo motors is proportional to the duty cycle.
 * To generate the PWM two 16-bit timers are used and the set of defines SERVO_SX_***** and SERVO_DX_***** are used to set the correct duty cycle using dedicated functions.
 * HARDWARE CONNECTIONS
 * PDC0H, RA6 ---> PWM_RB0: Valves for drogue release
 * PDC1H, RA7 ---> PWM_RB4: Release Ring
 
 * Il programma riceve sulle porte YODA_ATTIVA_VALVOLE e YODA_SGANCIA_ANELLO il segnale per attivare, rispettivamente, i servo motori per lo sgancio del drogue e il ponteh per il motore DC che sgancia l'anello del paracadute principale.
 * Supporta i segnali di accensione del motore e di distacco dalla rampa sui pin SEGNALE_DISTACCO e SEGNALE_ACCENSIONE (che nella prima versione attivano i timer di sgancio automatico), ma nella versione finale non verranno usati.
 * Quando il PIC riceve i segnali su YODA_ATTIVA_VALVOLE e YODA_SGANCIA_ANELLO attiva le porte ACK_VALVOLE e ACK_ANELLO, per segnalare che il segnale è stato ricevuto.
 *
 * Per controllare i servomotori, viene generato un PWM a 100Hz, con duty cycle variabile: a seconda del duty cycle il motore si mette in una posizione differente.
 * Vengono usati dei timer a 16 bit e i define SERVO_SX_* e SERVO_DX_* impostano tramite funzioni dedicate il duty cycle corretto.
 * PDC0H, RA6 ---> PWM_RB0: Valvole
 * PDC1H, RA7 ---> PWM_RB4: Sgancio Anello
 *
 * RELEASE HISTORY:
 * //--> 23.11.2013  VERSION 1.0  ==> Software completed, working timers and added an aux manual trigger in case of emergency
 * //--> 25.05.2014  VERSION 1.1  ==> Timers have been disabeled and we implemented a debouncer on the unlatching singnals YODA_ATTIVA_VALVOLE e YODA_SGANCIA_ANELLO
                                      to ensure unlatch only when a real signal is there (thereby ignoring the spurious signals)
 */
 

 /***************************************************************************************************************
 *                                                   DEFINE                                                    *
 ***************************************************************************************************************/
 
//Conditional programming
//#define TIMERS  //Timers are disabled IF COMMENTED
#define DEBOUNCERS //Debouncers are disabled IF COMMENTED

//PORTE
#define YODA_ATTIVA_VALVOLE        RB2_bit ///> Port that receives the active high signal for drogue unlatching
#define YODA_SGANCIA_ANELLO        RB3_bit ///> Port that receives the active high signal for main chute unlaching

#define RESET                      RA0_bit ///> Port that receives the reset signal to set all the motors in the original position
#define SEGNALE_DISTACCO           RA2_bit ///> Port that receives the active high signal to make us know that the rocket has left the launch base
#define SEGNALE_ACCENSIONE         RA3_bit ///> Port taht receives the active high signal to make us know that the motor has been ignited

#define SGANCIO_ANELLO             RA4_bit ///> Output port that activates the H-bridge to unlatch the main chute

#define ACK_VALVOLE                RA6_bit ///> Flag to the main MCU that signals successful drogue unlatch
#define ACK_ANELLO                 RA7_bit ///> Flag to the main MCU that signals successful main chute unlatch

#define SERVO_SX_INIT              725     ///> Starting angle (default position) of the servo motor on RB0 (Left motor): bigger the value, stronger the force.
#define SERVO_SX_END               930     ///> Ending angle position for the left motor
#define SERVO_SX_AUTO_SET          (SERVO_SX_INIT+SERVO_SX_END)/2     //After RESTORE_TIMER seconds, the left motor goes in a rest position for power and mechanical savings.

#define SERVO_DX_INIT              960     ///> Starting angle (default position) of the servo motor on RB0 (right motor): lower the value, stronger the force.
#define SERVO_DX_END               790     ///> Ending angle position for the right motor
#define SERVO_DX_AUTO_SET          (SERVO_DX_INIT+SERVO_DX_END)/2     //After RESTORE_TIMER seconds, the right motor goes in a rest position for power and mechanical savings.

#define RESTORE_TIMER              40000   ///> Time, in milliseconds, that the servos stay in the "unlatching drogue position".  After this time, they go in the rest position (half way the opened and closed valve position)

#define FREQ_PWM                   2499    ///> Defines the PWM frequency

//COSTANTI
#define DEBOUNCER_TIME             100     ///> Time, in milliseconds, that the signal after the "interrupt on change" on YODA_ATTIVA_VALVOLE and YODA_SGANCIA_ANELLO must remain active before acknowledging a correct unlatch signal.

//GENERAL UTILITY
#define ON         1
#define OFF        0
#define TRUE       1
#define FALSE      0
#define SET        1
#define CLEAR      0
#define INPUT      1
#define OUTPUT     0

//FLAGS MACROS (may be useful
#define TEST_BIT( array, index ) ( array[index>>3] & ( 1<<(index & 0x07) ) ) //given an ARRAY of char and the bit position, it tests if it's set or clear and returns true or false

#define SET_BIT( array, index ) ( array[index>>3] |= ( 1<<(index & 0x07) ) ) //given an ARRAY of char and the bit position, it sets the bit.

#define CLEAR_BIT( array, index ) ( array[index>>3] &= ~( 1<<(index & 0x07) ) ) //given an ARRAY of char and the bit position, it clears the bit

//TYPEDEFS
typedef unsigned char U_CHAR;               ///< For faster use
typedef unsigned int  U_INT;                ///< For faster use
typedef unsigned char BOOL;                 ///< For faster use
typedef volatile unsigned char VU_CHAR;     ///< For faster use
typedef volatile unsigned int VU_INT;       ///< For faster use
typedef volatile unsigned long VU_LONG;     ///< For faster use


/***************************************************************************************************************
 *                                             GLOBAL VARIABLES                                                *
 ***************************************************************************************************************/


VU_CHAR flag = 0;                ///>Flag that keeps the ON/OFF status of the rocket's motor
VU_CHAR flag_attiva_valvole = 0; ///>Flag that indicate that has been received the signal to activate the valves and unlatching the drogue
VU_CHAR flag_sgancia_anello = 0; ///>Flag that indicate that has been received the signal to activate the dc motor to unlatch the main chute
VU_CHAR flag_reset = 0;          ///>Flag that indicate that has been received the signal to activate
VU_CHAR disable_reinit = 0;      ///>Flag that waits for a reset signal to set the servos in the reset position
VU_INT debouncer_valvole = 0;    ///>Counter for debouncing YODA_ATTIVA_VALVOLE
VU_INT debouncer_anello = 0;     ///>Counter for debouncing YODA_SGANCIA_ANELLO



/***************************************************************************************************************
 *                                                 FUNCTIONS                                                   *
 ***************************************************************************************************************/

//\brief Function to set both the servos to a position
void setServo(U_INT servo_sx, U_INT servo_dx)
{
  PDC0L = servo_sx&255;            //imposto i primi 8bit (bassi) del registro del servo di sinistra
  PDC0H = servo_sx>>8;             //imposto i bit alti del registro del servo di sinistra
  PDC2L = servo_dx&255;            //imposto i bit bassi del servo di destra
  PDC2H = servo_dx>>8;             //imposto i bit alti del servo di destra
}

//\brief Function to set the servos to the initial position
void initServo()
{
   setServo(SERVO_SX_INIT,SERVO_DX_INIT);    //imposto i valori iniziali
}


//\brief Device initialization function
void init()
     {
            OSCCON = 0XFF;
//------------------ Port Initialization ----------------
            TRISA = 0b00101101;      // RA6, RA7 output
            LATA = 0x00;             // Clear PORT A
            TRISB = 0b00001100;      // RB2, RB3 input
            LATB = 0x00;             // Clear PORT B
//------------------ Interrupt Initialization----------------
            RCON.IPEN = 0;           // No priority
            INTCON.PEIE = 1;         // Abilito interrupt sulle periferiche
            INTCON.GIE = 1;          // Enable GLOBAL interrupts
            INTCON.RBIE = 1;         // Enable Port B Interrupt-On-Change
            INTCON.RBIF = 0;         // Clear PORT B interrupt flag
            INTCON.INT0IE = 1;       // Enable PORTA interrupt
            INTCON.INT0IF = 0;       // Clear PORTA interrupt flag
            INTCON2.INTEDG0 = 1;     // PORTA interrupt on rising edge
            ADCON1 = 0xFF;           // PORTA Digital I/O
// ----------------- PWM Initialization --------------
            PTCON0 = 0b00001000;
            PTCON1 = 0b10000000;
            PWMCON0 = 0b01000111;
            PWMCON1 = 0X00;
            PTPERH = FREQ_PWM>>8;
            PTPERL = FREQ_PWM&255;
            PTMRL = 0XFF;
            PTMRH = 0X00;
            initServo();
     }



// ------------ Timers ----------------
#ifdef TIMERS
void cont1()                         // Counter routine
     {
            int a = 0;
            RA6_bit = 0;
            while(a<100&&ACK_VALVOLE==0)
                {
                   a++;
                   Delay_ms(180);
                }
            PDC0H = 2;  //era 2
            PDC2H = 4;
            RA6_bit = 1;
     }

void cont2()                         // Counter routine
     {
            int b = 0;
            RA7_bit = 0;
            while(b<100&&RA7_bit==0)
                {
                   b++;
                   Delay_ms(20);     // delay 100ms @ fck = 250kHz
                }
            RA7_bit = 1;
            RA4_bit = 1;
            Delay_ms(2000);
            RA4_bit = 0;
            flag = 0;

     }
#endif


/***************************************************************************************************************
 *                                               INTERRUPTS                                                    *
 ***************************************************************************************************************/
 
 
 
void interrupt()                     // Interrupt service routine
     {
            if(INTCON.RBIF && INTCON.RBIE)    //If we have an interrupt on change
                {
                    if(YODA_ATTIVA_VALVOLE)      // If it's the YODA_ATTIVA_VALVOLE pin
                        {

                          while(YODA_ATTIVA_VALVOLE && debouncer_valvole <= DEBOUNCER_TIME) //while the pin is high we wait here
                          {
                            debouncer_valvole++;
                            Delay_ms(1);
                          }
                          if(debouncer_valvole >= DEBOUNCER_TIME) //if the necessary time has passed
                          {
                            flag_attiva_valvole=ON; //we set the flag
                          }
                          else
                            debouncer_valvole = 0;   //we reset the flag
                        }
                    if(YODA_SGANCIA_ANELLO)      // if it's the YODA_SGANCIA_ANELLO pin
                        {
                         while(YODA_SGANCIA_ANELLO && debouncer_anello <= DEBOUNCER_TIME) //while the pin is high we wait here
                          {
                            debouncer_anello++;
                            Delay_ms(1);
                          }
                          if(debouncer_anello >= DEBOUNCER_TIME)  //if the necessary time has passed
                          {
                            flag_sgancia_anello = 1;
                          }
                          else
                           debouncer_anello = 0;
                        }
                    INTCON.RBIF = 0;
                }
            if(INTCON.INT0IF)
                {
                    if(RESET)      // Reset
                        {
                          flag_reset = 1;
                        }
                    INTCON.INT0IF = 0;
                }
     }


/***************************************************************************************************************
 *                                                     MAIN                                                    *
 ***************************************************************************************************************/
void main()                          // Main routine
     {
            init();  //initializing
            while(1)                 // Infinite loop
                 {   
                 //timers from versione 1
                 #ifdef TIMERS
                     if(RA3_bit == 1) // waiting for ignition
                        {
                            flag = 1;
                        }
                     if(RA2_bit == 1 && flag == 1)  // waiting for detach from ramp
                        {

                            cont1();
                            cont2();

                        }
                 #endif
                     
                     if(flag_attiva_valvole && !ACK_VALVOLE)
                     {
                       ACK_VALVOLE = 1;                        // Turn the ack on
                       setServo(SERVO_SX_END,SERVO_DX_END); // set the position for drogue unlatch
                     }
                     if(flag_sgancia_anello && !ACK_ANELLO)
                     {
                       ACK_ANELLO = 1;  // Turn the ack on
                       SGANCIO_ANELLO = 1; //h-bridge activation
                       Delay_ms(2000);    //wait for two seconds
                       SGANCIO_ANELLO = 0; //h-bridge turned off
                       flag = 0;
                     }
                     if(flag_reset)  //resetting all the used variables to default values.
                     {
                       debouncer_valvole = 0;
                       debouncer_anello = 0;
                       SGANCIO_ANELLO = 0;
                       initServo();
                       ACK_ANELLO = 0;
                       ACK_VALVOLE = 0;
                       flag = 0;
                       flag_attiva_valvole = 0;
                       flag_sgancia_anello = 0;
                       flag_reset = 0;
                       disable_reinit = OFF;
                     }
                     
                     if(ACK_VALVOLE && ACK_ANELLO && !disable_reinit)
                        {
                            delay_ms(RESTORE_TIMER);     //waiting RESTORE_TIMER seconds (blocking wait)
                            //initServo();  //debug only
                            setServo(SERVO_SX_AUTO_SET,SERVO_DX_AUTO_SET);  //the servos go to the half way rest position
                            SGANCIO_ANELLO = OFF;
                            disable_reinit = ON;
                           // ACK_VALVOLE = OFF;         //debug only: we keep them up to let the main MCU know if we are in rest state or reset state.
                            //ACK_ANELLO = OFF;
                        }

                 }
     }