
_mask:

;Recovery_PWM - PIC18F45K22.c,18 :: 		unsigned short mask(unsigned short num) {
;Recovery_PWM - PIC18F45K22.c,19 :: 		switch (num) {
	GOTO        L_mask0
;Recovery_PWM - PIC18F45K22.c,20 :: 		case 0 : return 0x3F;
L_mask2:
	MOVLW       63
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,21 :: 		case 1 : return 0x06;
L_mask3:
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,22 :: 		case 2 : return 0x5B;
L_mask4:
	MOVLW       91
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,23 :: 		case 3 : return 0x4F;
L_mask5:
	MOVLW       79
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,24 :: 		case 4 : return 0x66;
L_mask6:
	MOVLW       102
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,25 :: 		case 5 : return 0x6D;
L_mask7:
	MOVLW       109
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,26 :: 		case 6 : return 0x7D;
L_mask8:
	MOVLW       125
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,27 :: 		case 7 : return 0x07;
L_mask9:
	MOVLW       7
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,28 :: 		case 8 : return 0x7F;
L_mask10:
	MOVLW       127
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,29 :: 		case 9 : return 0x6F;
L_mask11:
	MOVLW       111
	MOVWF       R0 
	GOTO        L_end_mask
;Recovery_PWM - PIC18F45K22.c,30 :: 		}
L_mask0:
	MOVF        FARG_mask_num+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mask2
	MOVF        FARG_mask_num+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_mask3
	MOVF        FARG_mask_num+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_mask4
	MOVF        FARG_mask_num+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_mask5
	MOVF        FARG_mask_num+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_mask6
	MOVF        FARG_mask_num+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_mask7
	MOVF        FARG_mask_num+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_mask8
	MOVF        FARG_mask_num+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_mask9
	MOVF        FARG_mask_num+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_mask10
	MOVF        FARG_mask_num+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_mask11
;Recovery_PWM - PIC18F45K22.c,31 :: 		}
L_end_mask:
	RETURN      0
; end of _mask

_init:

;Recovery_PWM - PIC18F45K22.c,33 :: 		void init()                          // Device intialization
;Recovery_PWM - PIC18F45K22.c,37 :: 		TRISA = 0b00100000;      // Set direction to be OUTPUT
	MOVLW       32
	MOVWF       TRISA+0 
;Recovery_PWM - PIC18F45K22.c,38 :: 		ANSELA = 0b00100000;     // Configure RA0 as analog
	MOVLW       32
	MOVWF       ANSELA+0 
;Recovery_PWM - PIC18F45K22.c,39 :: 		LATA = 0x00;             // Clear PORT A
	CLRF        LATA+0 
;Recovery_PWM - PIC18F45K22.c,40 :: 		TRISB = 0xFF;            // Set direction to be INPUT
	MOVLW       255
	MOVWF       TRISB+0 
;Recovery_PWM - PIC18F45K22.c,41 :: 		ANSELB = 0x00;           // Configure PORT B pins as digital
	CLRF        ANSELB+0 
;Recovery_PWM - PIC18F45K22.c,42 :: 		LATB = 0x00;             // Clear PORT B
	CLRF        LATB+0 
;Recovery_PWM - PIC18F45K22.c,43 :: 		TRISC = 0x00;            // Set direction to be output
	CLRF        TRISC+0 
;Recovery_PWM - PIC18F45K22.c,44 :: 		ANSELC = 0x00;           // Configure PORT C pins as digital
	CLRF        ANSELC+0 
;Recovery_PWM - PIC18F45K22.c,45 :: 		LATC = 0x00;             // Clear PORT C
	CLRF        LATC+0 
;Recovery_PWM - PIC18F45K22.c,46 :: 		TRISD = 0b00000000;      // Set direction to be OUTPUT
	CLRF        TRISD+0 
;Recovery_PWM - PIC18F45K22.c,47 :: 		ANSELD = 0X00;           // Configure PORT D pins as digital
	CLRF        ANSELD+0 
;Recovery_PWM - PIC18F45K22.c,48 :: 		LATD = 0X00;             // Clear PORT D
	CLRF        LATD+0 
;Recovery_PWM - PIC18F45K22.c,50 :: 		RCON.IPEN = 0;           // No priority
	BCF         RCON+0, 7 
;Recovery_PWM - PIC18F45K22.c,51 :: 		INTCON.PEIE = 1;         // Abilito interrupt sulle periferiche
	BSF         INTCON+0, 6 
;Recovery_PWM - PIC18F45K22.c,52 :: 		INTCON.GIE = 1;          // Enable GLOBAL interrupts
	BSF         INTCON+0, 7 
;Recovery_PWM - PIC18F45K22.c,53 :: 		INTCON.RBIE = 1;         // Enable Port B Interrupt-On-Change
	BSF         INTCON+0, 3 
;Recovery_PWM - PIC18F45K22.c,54 :: 		PIE1.ADIE = 1;
	BSF         PIE1+0, 6 
;Recovery_PWM - PIC18F45K22.c,55 :: 		IOCB.IOCB6 = 1;          // Enable RB6 interrupt pin
	BSF         IOCB+0, 6 
;Recovery_PWM - PIC18F45K22.c,56 :: 		IOCB.IOCB7 = 1;          // Enable RB7 interrupt pin
	BSF         IOCB+0, 7 
;Recovery_PWM - PIC18F45K22.c,57 :: 		IOCB.IOCB5 = 1;          // Enable RB5 interrupt pin
	BSF         IOCB+0, 5 
;Recovery_PWM - PIC18F45K22.c,58 :: 		INTCON.RBIF = 0;         // Clear PORT B interrupt flag
	BCF         INTCON+0, 0 
;Recovery_PWM - PIC18F45K22.c,59 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;Recovery_PWM - PIC18F45K22.c,61 :: 		CCPTMRS0 = 0X00;         //
	CLRF        CCPTMRS0+0 
;Recovery_PWM - PIC18F45K22.c,62 :: 		T2CON = 0b11111101;       // Abilito TIMER2
	MOVLW       253
	MOVWF       T2CON+0 
;Recovery_PWM - PIC18F45K22.c,63 :: 		PR2 =  0XFF;             //
	MOVLW       255
	MOVWF       PR2+0 
;Recovery_PWM - PIC18F45K22.c,64 :: 		CCP1CON = 0X0C;          // Abilito PWM
	MOVLW       12
	MOVWF       CCP1CON+0 
;Recovery_PWM - PIC18F45K22.c,65 :: 		CCPR1L = 20;              // Posizione centrale (DC = 8.6%)
	MOVLW       20
	MOVWF       CCPR1L+0 
;Recovery_PWM - PIC18F45K22.c,66 :: 		PIR1.TMR2IF = 0;         // Azzero il flag di interrupt di TIMER2
	BCF         PIR1+0, 1 
;Recovery_PWM - PIC18F45K22.c,68 :: 		PR2 =  0X65;             //
	MOVLW       101
	MOVWF       PR2+0 
;Recovery_PWM - PIC18F45K22.c,69 :: 		CCP2CON = 0X0C;          // Abilito PWM
	MOVLW       12
	MOVWF       CCP2CON+0 
;Recovery_PWM - PIC18F45K22.c,70 :: 		CCPR2L = 8;              // Posizione tutto a destra (DC = 8.6%)
	MOVLW       8
	MOVWF       CCPR2L+0 
;Recovery_PWM - PIC18F45K22.c,71 :: 		PIR1.TMR2IF = 0;         // Azzero il flag di interrupt di TIMER2
	BCF         PIR1+0, 1 
;Recovery_PWM - PIC18F45K22.c,73 :: 		ADCON0 = 0x11;           //
	MOVLW       17
	MOVWF       ADCON0+0 
;Recovery_PWM - PIC18F45K22.c,74 :: 		ADCON1 = 0x00;           // Vedi pag 304 datasheet
	CLRF        ADCON1+0 
;Recovery_PWM - PIC18F45K22.c,75 :: 		ADCON2 = 0xF6;           //
	MOVLW       246
	MOVWF       ADCON2+0 
;Recovery_PWM - PIC18F45K22.c,76 :: 		ADCON2.ADFM = 1;         // Giustificato a DESTRA
	BSF         ADCON2+0, 7 
;Recovery_PWM - PIC18F45K22.c,77 :: 		}
L_end_init:
	RETURN      0
; end of _init

_cont1:

;Recovery_PWM - PIC18F45K22.c,79 :: 		void cont1()                           // Counter routine
;Recovery_PWM - PIC18F45K22.c,81 :: 		int a = 0;
	CLRF        cont1_a_L0+0 
	CLRF        cont1_a_L0+1 
;Recovery_PWM - PIC18F45K22.c,82 :: 		RA0_bit = 0;
	BCF         RA0_bit+0, 0 
;Recovery_PWM - PIC18F45K22.c,83 :: 		while(a<100&&RA0_bit==0)
L_cont112:
	MOVLW       128
	XORWF       cont1_a_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__cont140
	MOVLW       100
	SUBWF       cont1_a_L0+0, 0 
L__cont140:
	BTFSC       STATUS+0, 0 
	GOTO        L_cont113
	BTFSC       RA0_bit+0, 0 
	GOTO        L_cont113
L__cont135:
;Recovery_PWM - PIC18F45K22.c,85 :: 		a++;
	INFSNZ      cont1_a_L0+0, 1 
	INCF        cont1_a_L0+1, 1 
;Recovery_PWM - PIC18F45K22.c,86 :: 		Delay_ms(400);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_cont116:
	DECFSZ      R13, 1, 1
	BRA         L_cont116
	DECFSZ      R12, 1, 1
	BRA         L_cont116
	DECFSZ      R11, 1, 1
	BRA         L_cont116
;Recovery_PWM - PIC18F45K22.c,87 :: 		}
	GOTO        L_cont112
L_cont113:
;Recovery_PWM - PIC18F45K22.c,88 :: 		CCPR1L = 40;            // per impostare DC modifica qui.
	MOVLW       40
	MOVWF       CCPR1L+0 
;Recovery_PWM - PIC18F45K22.c,89 :: 		}
L_end_cont1:
	RETURN      0
; end of _cont1

_cont2:

;Recovery_PWM - PIC18F45K22.c,91 :: 		void cont2()                           // Counter routine
;Recovery_PWM - PIC18F45K22.c,93 :: 		int b = 0;
	CLRF        cont2_b_L0+0 
	CLRF        cont2_b_L0+1 
;Recovery_PWM - PIC18F45K22.c,94 :: 		RA1_bit = 0;
	BCF         RA1_bit+0, 1 
;Recovery_PWM - PIC18F45K22.c,95 :: 		while(b<100&&RA1_bit==0)
L_cont217:
	MOVLW       128
	XORWF       cont2_b_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__cont242
	MOVLW       100
	SUBWF       cont2_b_L0+0, 0 
L__cont242:
	BTFSC       STATUS+0, 0 
	GOTO        L_cont218
	BTFSC       RA1_bit+0, 1 
	GOTO        L_cont218
L__cont236:
;Recovery_PWM - PIC18F45K22.c,97 :: 		b++;
	INFSNZ      cont2_b_L0+0, 1 
	INCF        cont2_b_L0+1, 1 
;Recovery_PWM - PIC18F45K22.c,98 :: 		Delay_ms(400);    // delay 100ms @ fck = 250kHz
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_cont221:
	DECFSZ      R13, 1, 1
	BRA         L_cont221
	DECFSZ      R12, 1, 1
	BRA         L_cont221
	DECFSZ      R11, 1, 1
	BRA         L_cont221
;Recovery_PWM - PIC18F45K22.c,99 :: 		}
	GOTO        L_cont217
L_cont218:
;Recovery_PWM - PIC18F45K22.c,100 :: 		CCPR2L = 50;            // per impostare DC modifica qui.
	MOVLW       50
	MOVWF       CCPR2L+0 
;Recovery_PWM - PIC18F45K22.c,101 :: 		}
L_end_cont2:
	RETURN      0
; end of _cont2

_interrupt:

;Recovery_PWM - PIC18F45K22.c,102 :: 		void interrupt()                     // Interrupt service routine
;Recovery_PWM - PIC18F45K22.c,104 :: 		if(INTCON.RBIF)
	BTFSS       INTCON+0, 0 
	GOTO        L_interrupt22
;Recovery_PWM - PIC18F45K22.c,106 :: 		if(RB5_bit)                     // Tasto RESET
	BTFSS       RB5_bit+0, 5 
	GOTO        L_interrupt23
;Recovery_PWM - PIC18F45K22.c,108 :: 		RC6_bit = 0;
	BCF         RC6_bit+0, 6 
;Recovery_PWM - PIC18F45K22.c,109 :: 		RC7_bit = 0;
	BCF         RC7_bit+0, 7 
;Recovery_PWM - PIC18F45K22.c,110 :: 		CCPR1L = 9;
	MOVLW       9
	MOVWF       CCPR1L+0 
;Recovery_PWM - PIC18F45K22.c,111 :: 		CCPR2L = 8;
	MOVLW       8
	MOVWF       CCPR2L+0 
;Recovery_PWM - PIC18F45K22.c,112 :: 		}
L_interrupt23:
;Recovery_PWM - PIC18F45K22.c,113 :: 		if(RB6_bit)                     // STM1
	BTFSS       RB6_bit+0, 6 
	GOTO        L_interrupt24
;Recovery_PWM - PIC18F45K22.c,115 :: 		RC6_bit = 1;
	BSF         RC6_bit+0, 6 
;Recovery_PWM - PIC18F45K22.c,116 :: 		CCPR1L = 40;
	MOVLW       40
	MOVWF       CCPR1L+0 
;Recovery_PWM - PIC18F45K22.c,117 :: 		}
L_interrupt24:
;Recovery_PWM - PIC18F45K22.c,118 :: 		if(RB7_bit)                     // STM2
	BTFSS       RB7_bit+0, 7 
	GOTO        L_interrupt25
;Recovery_PWM - PIC18F45K22.c,120 :: 		RC7_bit = 1;
	BSF         RC7_bit+0, 7 
;Recovery_PWM - PIC18F45K22.c,121 :: 		CCPR2L = 50;
	MOVLW       50
	MOVWF       CCPR2L+0 
;Recovery_PWM - PIC18F45K22.c,122 :: 		}
L_interrupt25:
;Recovery_PWM - PIC18F45K22.c,123 :: 		INTCON.RBIF = 0;
	BCF         INTCON+0, 0 
;Recovery_PWM - PIC18F45K22.c,124 :: 		}
L_interrupt22:
;Recovery_PWM - PIC18F45K22.c,125 :: 		if(PIR1.ADIE)
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt26
;Recovery_PWM - PIC18F45K22.c,127 :: 		PIR1.ADIE = 0;
	BCF         PIR1+0, 6 
;Recovery_PWM - PIC18F45K22.c,129 :: 		digit = numero / 1000u;              // extract thousands digit
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        _numero+0, 0 
	MOVWF       R0 
	MOVF        _numero+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _digit+0 
	MOVF        R1, 0 
	MOVWF       _digit+1 
;Recovery_PWM - PIC18F45K22.c,130 :: 		LATD = mask(digit);                  // and store it to PORTD array
	MOVF        R0, 0 
	MOVWF       FARG_mask_num+0 
	CALL        _mask+0, 0
	MOVF        R0, 0 
	MOVWF       LATD+0 
;Recovery_PWM - PIC18F45K22.c,131 :: 		RA3_bit = 1;
	BSF         RA3_bit+0, 3 
;Recovery_PWM - PIC18F45K22.c,132 :: 		digit = (numero / 100u) % 10u;       // extract hundreds digit
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _numero+0, 0 
	MOVWF       R0 
	MOVF        _numero+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit+0 
	MOVF        R1, 0 
	MOVWF       _digit+1 
;Recovery_PWM - PIC18F45K22.c,133 :: 		Delay_ms(3);
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_interrupt27:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt27
	DECFSZ      R12, 1, 1
	BRA         L_interrupt27
	NOP
	NOP
;Recovery_PWM - PIC18F45K22.c,134 :: 		LATD = mask(digit);                  // and store it to PORTD array
	MOVF        _digit+0, 0 
	MOVWF       FARG_mask_num+0 
	CALL        _mask+0, 0
	MOVF        R0, 0 
	MOVWF       LATD+0 
;Recovery_PWM - PIC18F45K22.c,135 :: 		RA3_bit = 0;
	BCF         RA3_bit+0, 3 
;Recovery_PWM - PIC18F45K22.c,136 :: 		RA2_bit = 1;
	BSF         RA2_bit+0, 2 
;Recovery_PWM - PIC18F45K22.c,137 :: 		digit = (numero / 10u) % 10u;        // extract tens digit
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _numero+0, 0 
	MOVWF       R0 
	MOVF        _numero+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit+0 
	MOVF        R1, 0 
	MOVWF       _digit+1 
;Recovery_PWM - PIC18F45K22.c,138 :: 		Delay_ms(4);
	MOVLW       11
	MOVWF       R12, 0
	MOVLW       98
	MOVWF       R13, 0
L_interrupt28:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt28
	DECFSZ      R12, 1, 1
	BRA         L_interrupt28
	NOP
;Recovery_PWM - PIC18F45K22.c,139 :: 		LATD = mask(digit);                  // and store it to PORTD array
	MOVF        _digit+0, 0 
	MOVWF       FARG_mask_num+0 
	CALL        _mask+0, 0
	MOVF        R0, 0 
	MOVWF       LATD+0 
;Recovery_PWM - PIC18F45K22.c,140 :: 		RA2_bit = 0;
	BCF         RA2_bit+0, 2 
;Recovery_PWM - PIC18F45K22.c,141 :: 		RA1_bit = 1;
	BSF         RA1_bit+0, 1 
;Recovery_PWM - PIC18F45K22.c,142 :: 		Delay_ms(5);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_interrupt29:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt29
	DECFSZ      R12, 1, 1
	BRA         L_interrupt29
	NOP
	NOP
;Recovery_PWM - PIC18F45K22.c,143 :: 		digit = numero % 10u;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _numero+0, 0 
	MOVWF       R0 
	MOVF        _numero+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit+0 
	MOVF        R1, 0 
	MOVWF       _digit+1 
;Recovery_PWM - PIC18F45K22.c,144 :: 		LATD = mask(digit);
	MOVF        R0, 0 
	MOVWF       FARG_mask_num+0 
	CALL        _mask+0, 0
	MOVF        R0, 0 
	MOVWF       LATD+0 
;Recovery_PWM - PIC18F45K22.c,145 :: 		RA1_bit = 0;
	BCF         RA1_bit+0, 1 
;Recovery_PWM - PIC18F45K22.c,146 :: 		RA0_bit = 1;                         // extract ones digit
	BSF         RA0_bit+0, 0 
;Recovery_PWM - PIC18F45K22.c,147 :: 		Delay_ms(6);
	MOVLW       16
	MOVWF       R12, 0
	MOVLW       148
	MOVWF       R13, 0
L_interrupt30:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt30
	DECFSZ      R12, 1, 1
	BRA         L_interrupt30
	NOP
;Recovery_PWM - PIC18F45K22.c,148 :: 		RA0_bit = 0;
	BCF         RA0_bit+0, 0 
;Recovery_PWM - PIC18F45K22.c,149 :: 		}
L_interrupt26:
;Recovery_PWM - PIC18F45K22.c,151 :: 		}
L_end_interrupt:
L__interrupt44:
	RETFIE      1
; end of _interrupt

_main:

;Recovery_PWM - PIC18F45K22.c,153 :: 		void main()                         // Main routine
;Recovery_PWM - PIC18F45K22.c,155 :: 		init();
	CALL        _init+0, 0
;Recovery_PWM - PIC18F45K22.c,156 :: 		while(1)                // Infinite loop
L_main31:
;Recovery_PWM - PIC18F45K22.c,158 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 1 
;Recovery_PWM - PIC18F45K22.c,159 :: 		numero = (ADRESL+(ADRESH*256))*1.2;
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	CALL        _Int2Double+0, 0
	MOVLW       154
	MOVWF       R4 
	MOVLW       153
	MOVWF       R5 
	MOVLW       25
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Word+0, 0
	MOVF        R0, 0 
	MOVWF       _numero+0 
	MOVF        R1, 0 
	MOVWF       _numero+1 
;Recovery_PWM - PIC18F45K22.c,160 :: 		if(RB0_bit == 1)  // Accensione
	BTFSS       RB0_bit+0, 0 
	GOTO        L_main33
;Recovery_PWM - PIC18F45K22.c,162 :: 		if(RB1_bit == 1)  // Distacco
	BTFSS       RB1_bit+0, 1 
	GOTO        L_main34
;Recovery_PWM - PIC18F45K22.c,164 :: 		cont1();
	CALL        _cont1+0, 0
;Recovery_PWM - PIC18F45K22.c,165 :: 		cont2();
	CALL        _cont2+0, 0
;Recovery_PWM - PIC18F45K22.c,166 :: 		}
L_main34:
;Recovery_PWM - PIC18F45K22.c,167 :: 		}
L_main33:
;Recovery_PWM - PIC18F45K22.c,168 :: 		}
	GOTO        L_main31
;Recovery_PWM - PIC18F45K22.c,169 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
