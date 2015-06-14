/*
 * Project name:
     Peripheral Interrupt (Interrupt while reciving data over UART)
 * Copyright:
     (c) Mikroelektronika, 2012.
 * Revision History:
     20120505:
       - initial release (DO);
 * Description:
     This is a simple interrupt demostration project.
     uC will send some data for connectivty test.
     Received data will be saved in buffer using interrut.
     Last recived character will be diplayed on portD.
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
     - Turn on the PORT D LEDs at SW3.4.
     - Put RX and TX UART jumpers (J3 and J4) in RS-232 or USB position,
     - Turn on RX and TX UART switches (SW1.1 and SW2.1).
*/

char rxbuff[20];                    // Buffer variable for storing data sent from master
char rxidx;                         // Counter for data writen in buffer

void interrupt() {                  // Interrupt rutine
   if(RC1IF_bit == 1) {             // Checks for Receive Interrupt Flag bit
     rxbuff[rxidx] = UART_Read();   // Storing read data
     rxidx++;                       // Incresing counter of read data
     if(rxidx >= 20)                // Checks if data is larger than buffer
       rxidx = 0;                   // Reset counter
   }
}

void main() {
  rxidx  = 0;                       // Initialisation of variable
  ANSELC = 0;                       // Configure PORTC pins as digital
  ANSELD = 0;                       // Configure PORTD pins as digital
  TRISD  = 0;                       // Configure PORTD as output

  UART1_Init(19200);                // Initialize UART module at 19200 bps
  Delay_ms(100);                    // Wait for UART module to stabilize

  UART1_Write_Text("Start");        // Send text
  UART1_Write(13);                  // ASCII carriage return
  UART1_Write(10);                  // ASCII line feed (new line)

  LATD = 0xFF;                      // Set all pin on PORT D High
  Delay_ms(100);                    // Wait for some time
  LATD = 0x00;                      // Set all pin on PORT D Low

  RC1IE_bit = 1;                    // turn ON interrupt on UART1 receive
  RC1IF_bit = 0;                    // Clear interrupt flag
  PEIE_bit  = 1;                    // Enable peripheral interrupts
  GIE_bit   = 1;                    // Enable GLOBAL interrupts

  while(1) {
    if (rxidx == 0) {               // Nothing is read, or buffer overflows
       LATD = rxbuff[rxidx];        // Do something(Show first char that will be overwriten)
    }
    else {
       LATD = rxbuff[rxidx-1];      // Show binary value of the read character on PORT D
    }
  }
}