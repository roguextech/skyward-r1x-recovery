#line 1 "C:/Users/Davide/Dropbox/Skyward/Recovery/Firmware/EasyPIC demo/Recovery_PWM - PIC18F45K22.c"
#line 15 "C:/Users/Davide/Dropbox/Skyward/Recovery/Firmware/EasyPIC demo/Recovery_PWM - PIC18F45K22.c"
unsigned int digit = 0, i = 0, dato = 0, media = 0, numero = 0;


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

void init()
 {


 TRISA = 0b00100000;
 ANSELA = 0b00100000;
 LATA = 0x00;
 TRISB = 0xFF;
 ANSELB = 0x00;
 LATB = 0x00;
 TRISC = 0x00;
 ANSELC = 0x00;
 LATC = 0x00;
 TRISD = 0b00000000;
 ANSELD = 0X00;
 LATD = 0X00;

 RCON.IPEN = 0;
 INTCON.PEIE = 1;
 INTCON.GIE = 1;
 INTCON.RBIE = 1;
 PIE1.ADIE = 1;
 IOCB.IOCB6 = 1;
 IOCB.IOCB7 = 1;
 IOCB.IOCB5 = 1;
 INTCON.RBIF = 0;
 PIR1.ADIF = 0;

 CCPTMRS0 = 0X00;
 T2CON = 0b11111101;
 PR2 = 0XFF;
 CCP1CON = 0X0C;
 CCPR1L = 20;
 PIR1.TMR2IF = 0;

 PR2 = 0X65;
 CCP2CON = 0X0C;
 CCPR2L = 8;
 PIR1.TMR2IF = 0;

 ADCON0 = 0x11;
 ADCON1 = 0x00;
 ADCON2 = 0xF6;
 ADCON2.ADFM = 1;
 }

void cont1()
 {
 int a = 0;
 RA0_bit = 0;
 while(a<100&&RA0_bit==0)
 {
 a++;
 Delay_ms(400);
 }
 CCPR1L = 40;
 }

void cont2()
 {
 int b = 0;
 RA1_bit = 0;
 while(b<100&&RA1_bit==0)
 {
 b++;
 Delay_ms(400);
 }
 CCPR2L = 50;
 }
void interrupt()
 {
 if(INTCON.RBIF)
 {
 if(RB5_bit)
 {
 RC6_bit = 0;
 RC7_bit = 0;
 CCPR1L = 9;
 CCPR2L = 8;
 }
 if(RB6_bit)
 {
 RC6_bit = 1;
 CCPR1L = 40;
 }
 if(RB7_bit)
 {
 RC7_bit = 1;
 CCPR2L = 50;
 }
 INTCON.RBIF = 0;
 }
 if(PIR1.ADIE)
 {
 PIR1.ADIE = 0;

 digit = numero / 1000u;
 LATD = mask(digit);
 RA3_bit = 1;
 digit = (numero / 100u) % 10u;
 Delay_ms(3);
 LATD = mask(digit);
 RA3_bit = 0;
 RA2_bit = 1;
 digit = (numero / 10u) % 10u;
 Delay_ms(4);
 LATD = mask(digit);
 RA2_bit = 0;
 RA1_bit = 1;
 Delay_ms(5);
 digit = numero % 10u;
 LATD = mask(digit);
 RA1_bit = 0;
 RA0_bit = 1;
 Delay_ms(6);
 RA0_bit = 0;
 }

 }

void main()
 {
 init();
 while(1)
 {
 ADCON0.GO = 1;
 numero = (ADRESL+(ADRESH*256))*1.2;
 if(RB0_bit == 1)
 {
 if(RB1_bit == 1)
 {
 cont1();
 cont2();
 }
 }
 }
 }
