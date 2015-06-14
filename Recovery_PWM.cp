#line 1 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
#line 85 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
typedef unsigned char U_CHAR;
typedef unsigned int U_INT;
typedef unsigned char BOOL;
typedef volatile unsigned char VU_CHAR;
typedef volatile unsigned int VU_INT;
typedef volatile unsigned long VU_LONG;
#line 102 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
VU_CHAR flag = 0;
VU_CHAR flag_attiva_valvole = 0;
VU_CHAR flag_sgancia_anello = 0;
VU_CHAR flag_reset = 0;
VU_CHAR disable_reinit = 0;
VU_INT debouncer_valvole = 0;
VU_INT debouncer_anello = 0;
#line 117 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
void setServo(U_INT servo_sx, U_INT servo_dx)
{
 PDC0L = servo_sx&255;
 PDC0H = servo_sx>>8;
 PDC2L = servo_dx&255;
 PDC2H = servo_dx>>8;
}


void initServo()
{
 setServo( 725 , 960 );
}



void init()
 {
 OSCCON = 0XFF;

 TRISA = 0b00101101;
 LATA = 0X00;
 TRISB = 0b00001100;
 LATB = 0X00;

 RCON.IPEN = 0;
 INTCON.PEIE = 1;
 INTCON.GIE = 1;
 INTCON.RBIE = 1;
 INTCON.RBIF = 0;
 INTCON.INT0IE = 1;
 INTCON.INT0IF = 0;
 INTCON2.INTEDG0 = 1;
 ADCON1 = 0XFF;

 PTCON0 = 0b00001000;
 PTCON1 = 0b10000000;
 PWMCON0 = 0b01000111;
 PWMCON1 = 0X00;
 PTPERH =  2499 >>8;
 PTPERL =  2499 &255;
 PTMRL = 0XFF;
 PTMRH = 0X00;
 initServo();








 }
#line 214 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
void interrupt()
 {
 if(INTCON.RBIF && INTCON.RBIE)
 {
 if( RB2_bit )
 {

 while( RB2_bit  && debouncer_valvole <=  100 )
 {
 debouncer_valvole++;
 Delay_ms(1);
 }
 if(debouncer_valvole >=  100 )
 {
 flag_attiva_valvole= 1 ;










 }
 else
 debouncer_valvole = 0;
 }
 if( RB3_bit )
 {
 while( RB3_bit  && debouncer_anello <=  100 )
 {
 debouncer_anello++;
 Delay_ms(1);
 }
 if(debouncer_anello >=  100 )
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
 if( RA0_bit )
 {
 flag_reset = 1;
 }
 INTCON.INT0IF = 0;
 }
 }
#line 273 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
void main()
 {
 init();
 while(1)
 {
#line 293 "D:/Google Drive/Skyward Experimental Rocketry/Rocksanne I-X/ELS - Electronic Systems/Team/Phase B/Embedded System/Elettronica per Recovery/VERSIONE 1.1/Firmware/Recovery_PWM.c"
 if(flag_attiva_valvole && ! RA6_bit )
 {
  RA6_bit  = 1;
 setServo( 930 , 790 );
 }
 if(flag_sgancia_anello && ! RA7_bit )
 {
  RA7_bit  = 1;
  RA4_bit  = 1;
 Delay_ms(2000);
  RA4_bit  = 0;
 flag = 0;
 }
 if(flag_reset)
 {
 debouncer_valvole = 0;
 debouncer_anello = 0;
  RA4_bit  = 0;
 initServo();
  RA7_bit  = 0;
  RA6_bit  = 0;
 flag = 0;
 flag_attiva_valvole = 0;
 flag_sgancia_anello = 0;
 flag_reset = 0;
 disable_reinit =  0 ;
 }

 if( RA6_bit  &&  RA7_bit  && !disable_reinit)
 {
 delay_ms( 40000 );

 setServo( ( 725 + 930 )/2 , ( 960 + 790 )/2 );
  RA4_bit  =  0 ;
 disable_reinit =  1 ;


 }

 }
 }
