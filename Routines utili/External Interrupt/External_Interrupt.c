/*
 * Project name:
     Etxernal Interrupt (INT0 - RB0)
 * Copyright:
     (c) Mikroelektronika, 2012.
 * Revision History:
     20120505:
       - initial release (DO);
 * Description:
     This is a simple interrupt demostration project.
     All LEDs on PORTD will flash utill interrupt occurs (RB0 is pressed).
     Interrupt will set local flag, which will cause Flashing routine to be executed.
 * Test configuration:
     MCU:             PIC18F45K22
                      http://ww1.microchip.com/downloads/en/DeviceDoc/41412D.pdf
     dev.board:       EasyPIC v7
                      http://www.mikroe.com/eng/products/view/757/easypic-v7-development-system/
     Oscillator:      HS-PLL 32.0000 MHz, 8.0000 MHz Crystal
     Ext. Modules:    None.
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * NOTES:
     - Put J17 in VCC position.
     - Turn ON the PORT D LEDs at SW3.4.
     - Put PORTB dip switch RB0 in PullDown position
*/

bit flag;

void Delay250() {
  Delay_ms(250);
}

void Delay150() {
  Delay_ms(150);
}

void FlashD1() {            // Flashing rutine
  LATD.F1 = 1;
  Delay150();
  LATD.F1 = 0;
  Delay250(); Delay250();
  LATD.F1 = 1;
  Delay150();
  LATD.F1 = 0;
  Delay250(); Delay250();
}

void interrupt(){           // Interrupt rutine
  if(INT0F_bit == 1 ) {     // Checks Receive Interrupt Flag bit
    flag      = 1;          // Set local interrupt flag
    INT0F_bit = 0;          // Clear Interrupt Flag
  }
}

void main() {
  flag   = 0;               // Varialbe initialisation
  ANSELB = 0;               // Configure PORT B pins as digital
  ANSELD = 0;               // Configure PORT D pins as digital
  TRISB  = 1;               // Set PORT B (only RB0) as input
  TRISD  = 0;               // Set PORT D as output
  LATD   = 0x00;            // Set all pin on PORT D Low
  
  INTEDG0_bit = 1;          // Set interrupt on rising edge
  INT0IF_bit  = 0;          // Clear INT0 flag
  INT0IE_bit  = 1;          // Enable INT0 interrupts
  GIE_bit     = 1;          // Enable GLOBAL interrupts

  while(1) {
    LATD = 0xFF;            // Set all pin on PORT D High
    Delay250();             // Wait for some time
    LATD = 0x00;            // Set all pin on PORT D Low
    Delay150();             // Wait for some time
    if(flag) {              // Checks local interrupt flag
      FlashD1();            // Do something
      flag = 0;             // Resert local interrupt flag
    }
  }
}