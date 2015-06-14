
//--------------------- Skyward Experimetal Rocketry ---------------------------
//-------------------------- DemoBoard firmware --------------------------------

// Lista uscite PWM, PIC18F45K22:
// P1A = RC2
// P1B = RB2
// P1C = RB1
// P1D = RB4
// P2A = RB3, RC1
// P2B = RB5
// P3A = RB5, RC6
// P3B = RC7

unsigned int digit = 0, i = 0, dato = 0, media = 0, numero = 0;
//float numero = 0;

unsigned short mask(unsigned short num) {
  switch (num) {
    case 0 : return 0x3F;
    case 1 : return 0x06;
    case 2 : return 0x5B;
    case 3 : return 0x4F;
    case 4 : return 0x66;
    case 5 : return 0x6D;
    case 6 : return 0x7D;
    case 7 : return 0x07;
    case 8 : return 0x7F;
    case 9 : return 0x6F;
  }
}

void init()                          // Device intialization
     {
            //OSCCON = 0b11100111;
//---------------------- Inizializzazione porte I/O ----------------------------
            TRISA = 0b00100000;      // Set direction to be OUTPUT
            ANSELA = 0b00100000;     // Configure RA0 as analog
            LATA = 0x00;             // Clear PORT A
            TRISB = 0xFF;            // Set direction to be INPUT
            ANSELB = 0x00;           // Configure PORT B pins as digital
            LATB = 0x00;             // Clear PORT B
            TRISC = 0x00;            // Set direction to be output
            ANSELC = 0x00;           // Configure PORT C pins as digital
            LATC = 0x00;             // Clear PORT C
            TRISD = 0b00000000;      // Set direction to be OUTPUT
            ANSELD = 0X00;           // Configure PORT D pins as digital
            LATD = 0X00;             // Clear PORT D
//----------------------- Inizializzazione interrupt ---------------------------
            RCON.IPEN = 0;           // No priority
            INTCON.PEIE = 1;         // Abilito interrupt sulle periferiche
            INTCON.GIE = 1;          // Enable GLOBAL interrupts
            INTCON.RBIE = 1;         // Enable Port B Interrupt-On-Change
            PIE1.ADIE = 1;
            IOCB.IOCB6 = 1;          // Enable RB6 interrupt pin
            IOCB.IOCB7 = 1;          // Enable RB7 interrupt pin
            IOCB.IOCB5 = 1;          // Enable RB5 interrupt pin
            INTCON.RBIF = 0;         // Clear PORT B interrupt flag
            PIR1.ADIF = 0;
// ------------------ Inizializzazione uscita PWM su RC2 = P1A -----------------
            CCPTMRS0 = 0X00;         //
            T2CON = 0b11111101;       // Abilito TIMER2
            PR2 =  0XFF;             //
            CCP1CON = 0X0C;          // Abilito PWM
            CCPR1L = 20;              // Posizione centrale (DC = 8.6%)
            PIR1.TMR2IF = 0;         // Azzero il flag di interrupt di TIMER2
// ------------------ Inizializzazione uscita PWM su RC1 = P2A -----------------
            PR2 =  0X65;             //
            CCP2CON = 0X0C;          // Abilito PWM
            CCPR2L = 8;              // Posizione tutto a destra (DC = 8.6%)
            PIR1.TMR2IF = 0;         // Azzero il flag di interrupt di TIMER2
// ----------------------------Inizializzazione ADC ----------------------------
            ADCON0 = 0x11;           //
            ADCON1 = 0x00;           // Vedi pag 304 datasheet
            ADCON2 = 0xF6;           //
            ADCON2.ADFM = 1;         // Giustificato a DESTRA
     }

void cont1()                           // Counter routine
     {
            int a = 0;
            RA0_bit = 0;
            while(a<100&&RA0_bit==0)
                {
                   a++;
                   Delay_ms(400);
                }
            CCPR1L = 40;            // per impostare DC modifica qui.
     }
     
void cont2()                           // Counter routine
     {
            int b = 0;
            RA1_bit = 0;
            while(b<100&&RA1_bit==0)
                {
                   b++;
                   Delay_ms(400);    // delay 100ms @ fck = 250kHz
                }
            CCPR2L = 50;            // per impostare DC modifica qui.
     }
void interrupt()                     // Interrupt service routine
     {
            if(INTCON.RBIF)
                {
                    if(RB5_bit)                     // Tasto RESET
                        {
                            RC6_bit = 0;
                            RC7_bit = 0;
                            CCPR1L = 9;
                            CCPR2L = 8;
                        }
                    if(RB6_bit)                     // STM1
                        {
                            RC6_bit = 1;
                            CCPR1L = 40;
                        }
                    if(RB7_bit)                     // STM2
                        {
                            RC7_bit = 1;
                            CCPR2L = 50;
                        }
                    INTCON.RBIF = 0;
                }
            if(PIR1.ADIE)
                {
                    PIR1.ADIE = 0;
//---------------------- Visualizzazione 7 segmenti -----------------------------------
                    digit = numero / 1000u;              // extract thousands digit
                    LATD = mask(digit);                  // and store it to PORTD array
                    RA3_bit = 1;
                    digit = (numero / 100u) % 10u;       // extract hundreds digit
                    Delay_ms(3);
                    LATD = mask(digit);                  // and store it to PORTD array
                    RA3_bit = 0;
                    RA2_bit = 1;
                    digit = (numero / 10u) % 10u;        // extract tens digit
                    Delay_ms(4);
                    LATD = mask(digit);                  // and store it to PORTD array
                    RA2_bit = 0;
                    RA1_bit = 1;
                    Delay_ms(5);
                    digit = numero % 10u;
                    LATD = mask(digit);
                    RA1_bit = 0;
                    RA0_bit = 1;                         // extract ones digit
                    Delay_ms(6);
                    RA0_bit = 0;
                }
                    
     }

void main()                         // Main routine
     {
            init();
            while(1)                // Infinite loop
                 {
                     ADCON0.GO = 1;
                     numero = (ADRESL+(ADRESH*256))*1.2;
                     if(RB0_bit == 1)  // Accensione
                       {
                            if(RB1_bit == 1)  // Distacco
                               {
                                   cont1();
                                   cont2();
                               }
                        }
                 }
     }