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
     All LEDs on PORTD will flash utill interrupt occurs.
     Interrupt will set local flag, which will cause Flashing routine to be executed.
     Depending on pressed button (RB4:RB7) different Flashing routine will be executed.
 * Test configuration:
     MCU:             PIC18F45K22
                      http://ww1.microchip.com/downloads/en/DeviceDoc/41412D.pdf
     dev.board:       EasyPIC v7
                      http://www.mikroe.com/eng/products/view/757/easypic-v7-development-system/
     Oscillator:      8.0000 MHz Crystal
     Ext. Modules:    None.
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * NOTES:
     - Put J17 in VCC position.
     - Turn ON the PORT D LEDs at SW3.4.
     - Put PORTB dip switch RB<7:4> in PullDown position
*/

#include "Flash_functions.h"

char pressedButton;
bit flag;

void interrupt(){              // Interrupt rutine
  if(RBIF_bit == 1 ) {         // Checks for Receive Interrupt Flag bit
    flag  = 1;                 // Set local interrupt flag
    RBIF_bit = 0;              // Clear Interrupt Flag
    if (PORTB.F7 == 1){        // Checks if the RB7 is pressed
       pressedButton = 7;
    }
    if (PORTB.F6 == 1){        // Checks if the RB6 is pressed
       pressedButton = 6;
    }
    if (PORTB.F5 == 1){        // Checks if the RB5 is pressed
       pressedButton = 5;
    }
    if (PORTB.F4 == 1){        // Checks if the RB4 is pressed
       pressedButton = 4;
    }
  }
}

void main() {                  // Varialbe initialisation
  flag          = 0;           // Varialbe initialisation
  pressedButton = 0;
  
  ANSELB = 0;                  // Configure PORT B pins as digital
  ANSELD = 0;                  // Configure PORT D pins as digital
  TRISB  = 0xFF;               // Set PORT B as input
  TRISD  = 0;                  // Set PORT D as output
  LATD   = 0x00;               // Set all pin on PORT D Low
  
  RBIE_bit  = 1;               // Enable Port B Interrupt-On-Change
  IOCB4_bit = 1;               // Enable RB4 interrupt pin
  IOCB5_bit = 1;               // Enable RB5 interrupt pin
  IOCB6_bit = 1;               // Enable RB6 interrupt pin
  IOCB7_bit = 1;               // Enable RB7 interrupt pin
  RBIF_bit  = 0;               // Clear IOC flag
  GIE_bit   = 1;               // Enable GLOBAL interrupts


  while(1) {
    LATD = 0xFF;               // Set all pin on PORT D High
    Delay250();                // Wait for some time
    LATD = 0x00;               // Set all pin on PORT D Low
    Delay150();                // Wait for some time
    if(flag) {
      switch(pressedButton) {  // Depending on value(button pressed), calls FleshIt function with different argument
      case 4:
           FlashIt(0x03);
           pressedButton = 0;
      break;
      case 5:
           FlashIt(0x0C);
           pressedButton = 0;
      break;
      case 6:
           FlashIt(0x30);
           pressedButton = 0;
      break;
      case 7:
           FlashIt(0xC0);
           pressedButton = 0;
      break;
      default:
           FlashIt(0xAA);       // Just in case
      break;
      }
      flag = 0;                 // Reset flag variable
    }
  }
}