
_setServo:

;Recovery_PWM.c,117 :: 		void setServo(U_INT servo_sx, U_INT servo_dx)
;Recovery_PWM.c,119 :: 		PDC0L = servo_sx&255;            //imposto i primi 8bit (bassi) del registro del servo di sinistra
	MOVLW       255
	ANDWF       FARG_setServo_servo_sx+0, 0 
	MOVWF       PDC0L+0 
;Recovery_PWM.c,120 :: 		PDC0H = servo_sx>>8;             //imposto i bit alti del registro del servo di sinistra
	MOVF        FARG_setServo_servo_sx+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       PDC0H+0 
;Recovery_PWM.c,121 :: 		PDC2L = servo_dx&255;            //imposto i bit bassi del servo di destra
	MOVLW       255
	ANDWF       FARG_setServo_servo_dx+0, 0 
	MOVWF       PDC2L+0 
;Recovery_PWM.c,122 :: 		PDC2H = servo_dx>>8;             //imposto i bit alti del servo di destra
	MOVF        FARG_setServo_servo_dx+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       PDC2H+0 
;Recovery_PWM.c,123 :: 		}
L_end_setServo:
	RETURN      0
; end of _setServo

_initServo:

;Recovery_PWM.c,126 :: 		void initServo()
;Recovery_PWM.c,128 :: 		setServo(SERVO_SX_INIT,SERVO_DX_INIT);    //imposto i valori iniziali
	MOVLW       213
	MOVWF       FARG_setServo_servo_sx+0 
	MOVLW       2
	MOVWF       FARG_setServo_servo_sx+1 
	MOVLW       192
	MOVWF       FARG_setServo_servo_dx+0 
	MOVLW       3
	MOVWF       FARG_setServo_servo_dx+1 
	CALL        _setServo+0, 0
;Recovery_PWM.c,129 :: 		}
L_end_initServo:
	RETURN      0
; end of _initServo

_init:

;Recovery_PWM.c,133 :: 		void init()                          // Device intialization
;Recovery_PWM.c,135 :: 		OSCCON = 0XFF;
	MOVLW       255
	MOVWF       OSCCON+0 
;Recovery_PWM.c,137 :: 		TRISA = 0b00101101;      // RA6, RA7 output
	MOVLW       45
	MOVWF       TRISA+0 
;Recovery_PWM.c,138 :: 		LATA = 0X00;             // Clear PORT A
	CLRF        LATA+0 
;Recovery_PWM.c,139 :: 		TRISB = 0b00001100;      // RB2, RB3 input
	MOVLW       12
	MOVWF       TRISB+0 
;Recovery_PWM.c,140 :: 		LATB = 0X00;             // Clear PORT B
	CLRF        LATB+0 
;Recovery_PWM.c,142 :: 		RCON.IPEN = 0;           // No priority
	BCF         RCON+0, 7 
;Recovery_PWM.c,143 :: 		INTCON.PEIE = 1;         // Abilito interrupt sulle periferiche
	BSF         INTCON+0, 6 
;Recovery_PWM.c,144 :: 		INTCON.GIE = 1;          // Enable GLOBAL interrupts
	BSF         INTCON+0, 7 
;Recovery_PWM.c,145 :: 		INTCON.RBIE = 1;         // Enable Port B Interrupt-On-Change
	BSF         INTCON+0, 3 
;Recovery_PWM.c,146 :: 		INTCON.RBIF = 0;         // Clear PORT B interrupt flag
	BCF         INTCON+0, 0 
;Recovery_PWM.c,147 :: 		INTCON.INT0IE = 1;       // Enable PORTA interrupt
	BSF         INTCON+0, 4 
;Recovery_PWM.c,148 :: 		INTCON.INT0IF = 0;       // Clear PORTA interrupt flag
	BCF         INTCON+0, 1 
;Recovery_PWM.c,149 :: 		INTCON2.INTEDG0 = 1;     // PORTA interrupt on rising edge
	BSF         INTCON2+0, 6 
;Recovery_PWM.c,150 :: 		ADCON1 = 0XFF;           // PORTA Digital I/O
	MOVLW       255
	MOVWF       ADCON1+0 
;Recovery_PWM.c,152 :: 		PTCON0 = 0b00001000;
	MOVLW       8
	MOVWF       PTCON0+0 
;Recovery_PWM.c,153 :: 		PTCON1 = 0b10000000;
	MOVLW       128
	MOVWF       PTCON1+0 
;Recovery_PWM.c,154 :: 		PWMCON0 = 0b01000111;
	MOVLW       71
	MOVWF       PWMCON0+0 
;Recovery_PWM.c,155 :: 		PWMCON1 = 0X00;
	CLRF        PWMCON1+0 
;Recovery_PWM.c,156 :: 		PTPERH = FREQ_PWM>>8;
	MOVLW       9
	MOVWF       PTPERH+0 
;Recovery_PWM.c,157 :: 		PTPERL = FREQ_PWM&255;
	MOVLW       195
	MOVWF       PTPERL+0 
;Recovery_PWM.c,158 :: 		PTMRL = 0XFF;
	MOVLW       255
	MOVWF       PTMRL+0 
;Recovery_PWM.c,159 :: 		PTMRH = 0X00;
	CLRF        PTMRH+0 
;Recovery_PWM.c,160 :: 		initServo();
	CALL        _initServo+0, 0
;Recovery_PWM.c,169 :: 		}
L_end_init:
	RETURN      0
; end of _init

_interrupt:

;Recovery_PWM.c,214 :: 		void interrupt()                     // Interrupt service routine
;Recovery_PWM.c,216 :: 		if(INTCON.RBIF && INTCON.RBIE)    //se è scattato l'interrupt on change e gli interrupt on change sono abilitati
	BTFSS       INTCON+0, 0 
	GOTO        L_interrupt2
	BTFSS       INTCON+0, 3 
	GOTO        L_interrupt2
L__interrupt37:
;Recovery_PWM.c,218 :: 		if(YODA_ATTIVA_VALVOLE)      // STM1 - Apri Valvole
	BTFSS       RB2_bit+0, BitPos(RB2_bit+0) 
	GOTO        L_interrupt3
;Recovery_PWM.c,221 :: 		while(YODA_ATTIVA_VALVOLE && debouncer_valvole <= DEBOUNCER_TIME) //fino a che il segnale è attivo e non è ancora passato il tempo di debounce, giro qui
L_interrupt4:
	BTFSS       RB2_bit+0, BitPos(RB2_bit+0) 
	GOTO        L_interrupt5
	MOVLW       0
	MOVWF       R0 
	MOVF        _debouncer_valvole+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt46
	MOVF        _debouncer_valvole+0, 0 
	SUBLW       100
L__interrupt46:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt5
L__interrupt36:
;Recovery_PWM.c,223 :: 		debouncer_valvole++;
	MOVLW       1
	ADDWF       _debouncer_valvole+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _debouncer_valvole+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _debouncer_valvole+0 
	MOVF        R1, 0 
	MOVWF       _debouncer_valvole+1 
;Recovery_PWM.c,224 :: 		Delay_ms(1);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_interrupt8:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt8
	DECFSZ      R12, 1, 1
	BRA         L_interrupt8
	NOP
	NOP
;Recovery_PWM.c,225 :: 		}
	GOTO        L_interrupt4
L_interrupt5:
;Recovery_PWM.c,226 :: 		if(debouncer_valvole >= DEBOUNCER_TIME) //se sono uscito dal ciclo di debounce per via della scadenza del timer, allora attivo la porta, altrimenti ignoro il comando
	MOVLW       0
	SUBWF       _debouncer_valvole+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt47
	MOVLW       100
	SUBWF       _debouncer_valvole+0, 0 
L__interrupt47:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt9
;Recovery_PWM.c,228 :: 		flag_attiva_valvole=ON;
	MOVLW       1
	MOVWF       _flag_attiva_valvole+0 
;Recovery_PWM.c,239 :: 		}
	GOTO        L_interrupt10
L_interrupt9:
;Recovery_PWM.c,241 :: 		debouncer_valvole = 0;   //altrimenti lo resetto, per evitare che disturbi ripetuti mi diventino un segnale accettato
	CLRF        _debouncer_valvole+0 
	CLRF        _debouncer_valvole+1 
L_interrupt10:
;Recovery_PWM.c,242 :: 		}
L_interrupt3:
;Recovery_PWM.c,243 :: 		if(YODA_SGANCIA_ANELLO)      // STM2 - Sgancia Anello
	BTFSS       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L_interrupt11
;Recovery_PWM.c,245 :: 		while(YODA_SGANCIA_ANELLO && debouncer_anello <= DEBOUNCER_TIME) //fino a che il segnale è attivo e non è ancora passato il tempo di debounce, giro qui
L_interrupt12:
	BTFSS       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L_interrupt13
	MOVLW       0
	MOVWF       R0 
	MOVF        _debouncer_anello+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt48
	MOVF        _debouncer_anello+0, 0 
	SUBLW       100
L__interrupt48:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt13
L__interrupt35:
;Recovery_PWM.c,247 :: 		debouncer_anello++;
	MOVLW       1
	ADDWF       _debouncer_anello+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _debouncer_anello+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _debouncer_anello+0 
	MOVF        R1, 0 
	MOVWF       _debouncer_anello+1 
;Recovery_PWM.c,248 :: 		Delay_ms(1);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_interrupt16:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt16
	DECFSZ      R12, 1, 1
	BRA         L_interrupt16
	NOP
	NOP
;Recovery_PWM.c,249 :: 		}
	GOTO        L_interrupt12
L_interrupt13:
;Recovery_PWM.c,250 :: 		if(debouncer_anello >= DEBOUNCER_TIME) //se sono uscito dal ciclo di debounce per via della scadenza del timer, allora attivo la porta, altrimenti ignoro il comando
	MOVLW       0
	SUBWF       _debouncer_anello+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt49
	MOVLW       100
	SUBWF       _debouncer_anello+0, 0 
L__interrupt49:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt17
;Recovery_PWM.c,252 :: 		flag_sgancia_anello = 1;
	MOVLW       1
	MOVWF       _flag_sgancia_anello+0 
;Recovery_PWM.c,253 :: 		}
	GOTO        L_interrupt18
L_interrupt17:
;Recovery_PWM.c,255 :: 		debouncer_anello = 0;
	CLRF        _debouncer_anello+0 
	CLRF        _debouncer_anello+1 
L_interrupt18:
;Recovery_PWM.c,256 :: 		}
L_interrupt11:
;Recovery_PWM.c,257 :: 		INTCON.RBIF = 0;
	BCF         INTCON+0, 0 
;Recovery_PWM.c,258 :: 		}
L_interrupt2:
;Recovery_PWM.c,259 :: 		if(INTCON.INT0IF)
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt19
;Recovery_PWM.c,261 :: 		if(RESET)      // Reset
	BTFSS       RA0_bit+0, BitPos(RA0_bit+0) 
	GOTO        L_interrupt20
;Recovery_PWM.c,263 :: 		flag_reset = 1;
	MOVLW       1
	MOVWF       _flag_reset+0 
;Recovery_PWM.c,264 :: 		}
L_interrupt20:
;Recovery_PWM.c,265 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;Recovery_PWM.c,266 :: 		}
L_interrupt19:
;Recovery_PWM.c,267 :: 		}
L_end_interrupt:
L__interrupt45:
	RETFIE      1
; end of _interrupt

_main:

;Recovery_PWM.c,273 :: 		void main()                          // Main routine
;Recovery_PWM.c,275 :: 		init();  //inizializzo
	CALL        _init+0, 0
;Recovery_PWM.c,276 :: 		while(1)                 // Infinite loop
L_main21:
;Recovery_PWM.c,293 :: 		if(flag_attiva_valvole && !ACK_VALVOLE)
	MOVF        _flag_attiva_valvole+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
	BTFSC       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_main25
L__main40:
;Recovery_PWM.c,295 :: 		ACK_VALVOLE = 1;
	BSF         RA6_bit+0, BitPos(RA6_bit+0) 
;Recovery_PWM.c,296 :: 		setServo(SERVO_SX_END,SERVO_DX_END); //porto i servo nella posizione finale.
	MOVLW       162
	MOVWF       FARG_setServo_servo_sx+0 
	MOVLW       3
	MOVWF       FARG_setServo_servo_sx+1 
	MOVLW       22
	MOVWF       FARG_setServo_servo_dx+0 
	MOVLW       3
	MOVWF       FARG_setServo_servo_dx+1 
	CALL        _setServo+0, 0
;Recovery_PWM.c,297 :: 		}
L_main25:
;Recovery_PWM.c,298 :: 		if(flag_sgancia_anello && !ACK_ANELLO)
	MOVF        _flag_sgancia_anello+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
	BTFSC       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_main28
L__main39:
;Recovery_PWM.c,300 :: 		ACK_ANELLO = 1; //avviso la yoda che lo sgancio è stato effettuato
	BSF         RA7_bit+0, BitPos(RA7_bit+0) 
;Recovery_PWM.c,301 :: 		SGANCIO_ANELLO = 1; //attivo il ponte H
	BSF         RA4_bit+0, BitPos(RA4_bit+0) 
;Recovery_PWM.c,302 :: 		Delay_ms(2000);    //aspetto due secondi (il motorino gira)
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
;Recovery_PWM.c,303 :: 		SGANCIO_ANELLO = 0; //disattivo il ponte H
	BCF         RA4_bit+0, BitPos(RA4_bit+0) 
;Recovery_PWM.c,304 :: 		flag = 0;
	CLRF        _flag+0 
;Recovery_PWM.c,305 :: 		}
L_main28:
;Recovery_PWM.c,306 :: 		if(flag_reset)
	MOVF        _flag_reset+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main30
;Recovery_PWM.c,308 :: 		debouncer_valvole = 0;
	CLRF        _debouncer_valvole+0 
	CLRF        _debouncer_valvole+1 
;Recovery_PWM.c,309 :: 		debouncer_anello = 0;
	CLRF        _debouncer_anello+0 
	CLRF        _debouncer_anello+1 
;Recovery_PWM.c,310 :: 		SGANCIO_ANELLO = 0;
	BCF         RA4_bit+0, BitPos(RA4_bit+0) 
;Recovery_PWM.c,311 :: 		initServo();
	CALL        _initServo+0, 0
;Recovery_PWM.c,312 :: 		ACK_ANELLO = 0;
	BCF         RA7_bit+0, BitPos(RA7_bit+0) 
;Recovery_PWM.c,313 :: 		ACK_VALVOLE = 0;
	BCF         RA6_bit+0, BitPos(RA6_bit+0) 
;Recovery_PWM.c,314 :: 		flag = 0;
	CLRF        _flag+0 
;Recovery_PWM.c,315 :: 		flag_attiva_valvole = 0;
	CLRF        _flag_attiva_valvole+0 
;Recovery_PWM.c,316 :: 		flag_sgancia_anello = 0;
	CLRF        _flag_sgancia_anello+0 
;Recovery_PWM.c,317 :: 		flag_reset = 0;
	CLRF        _flag_reset+0 
;Recovery_PWM.c,318 :: 		disable_reinit = OFF;
	CLRF        _disable_reinit+0 
;Recovery_PWM.c,319 :: 		}
L_main30:
;Recovery_PWM.c,321 :: 		if(ACK_VALVOLE && ACK_ANELLO && !disable_reinit)
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_main33
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_main33
	MOVF        _disable_reinit+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main33
L__main38:
;Recovery_PWM.c,323 :: 		delay_ms(RESTORE_TIMER);     //attendo RESTORE_TIMER secondi
	MOVLW       2
	MOVWF       R10, 0
	MOVLW       150
	MOVWF       R11, 0
	MOVLW       216
	MOVWF       R12, 0
	MOVLW       8
	MOVWF       R13, 0
L_main34:
	DECFSZ      R13, 1, 1
	BRA         L_main34
	DECFSZ      R12, 1, 1
	BRA         L_main34
	DECFSZ      R11, 1, 1
	BRA         L_main34
	DECFSZ      R10, 1, 1
	BRA         L_main34
	NOP
;Recovery_PWM.c,325 :: 		setServo(SERVO_SX_AUTO_SET,SERVO_DX_AUTO_SET);  //se si usa questo, dopo RESTORE_TIMER secondi i servo si spostano a metà strada tra la posizione di ricaric e la posizione di espulsione.
	MOVLW       59
	MOVWF       FARG_setServo_servo_sx+0 
	MOVLW       3
	MOVWF       FARG_setServo_servo_sx+1 
	MOVLW       107
	MOVWF       FARG_setServo_servo_dx+0 
	MOVLW       3
	MOVWF       FARG_setServo_servo_dx+1 
	CALL        _setServo+0, 0
;Recovery_PWM.c,326 :: 		SGANCIO_ANELLO = OFF;
	BCF         RA4_bit+0, BitPos(RA4_bit+0) 
;Recovery_PWM.c,327 :: 		disable_reinit = ON;
	MOVLW       1
	MOVWF       _disable_reinit+0 
;Recovery_PWM.c,330 :: 		}
L_main33:
;Recovery_PWM.c,332 :: 		}
	GOTO        L_main21
;Recovery_PWM.c,333 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
