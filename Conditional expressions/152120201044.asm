    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF     STATUS, RP0	; Select Bank1
    CLRF    TRISB	; Set all pins of PORTB as output
    CLRF    TRISD	; Set all pins of PORTD as output
    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTB	; Turn off all LEDs connected to PORTB
    CLRF    PORTD	; Turn off all LEDs connected to PORTD
    
    ; ---------- Your code starts here --------------------------
    
x EQU 0x20
y EQU 0x21
box EQU 0x22
 
    MOVLW 5
    MOVWF x
    MOVLW 6
    MOVWF y
    
    ;if (x < 0 || x > 11 || y < 0 || y > 10) box = -1;   
    BTFSS x, 7          ; x < 0 Eger son biti 1 ise negatiftir.
    GOTO CHECK_X_11     ; false
    GOTO BOX_EDGES      ; true
    
CHECK_X_11:
    MOVF	x, W		    ; WREG = x
    SUBLW	11		    ; WREG = 11 - WREG
    BTFSC	STATUS, C
    GOTO CHECK_Y_0
    GOTO BOX_EDGES
    
CHECK_Y_0:
    BTFSS y, 7 ; y < 0 Eger son biti 1 ise negatiftir.
    GOTO CHECK_Y_10
    GOTO BOX_EDGES
    
CHECK_Y_10:
    MOVF	y, W		    ; WREG = y
    SUBLW	10		    ; WREG = 10 - WREG
    BTFSC	STATUS, C
    GOTO CHECK_X_3
    GOTO BOX_EDGES
    
BOX_EDGES:
    MOVLW	-1		    ; WREG = -1
    MOVWF	box		    ; box = WREG
    GOTO END_STATEMENT
    
    
    
 ;else if (x <= 3){
     ; if (y <= 1)        box = 3;
     ; else if (y <= 4)   box = 2;
     ; else               box = 1;
     
CHECK_X_3:
    MOVF	x, W		    ; WREG = x
    SUBLW	3		    ; WREG = 3 - WREG
    BTFSS	STATUS, C	    ; If 3>=x, then C must be SET
    GOTO	CHECK_X_7	; false
    GOTO        CHECK_Y_1       ; true
    
CHECK_Y_1:
    MOVF	y, W		    ; WREG = y
    SUBLW	1		    ; WREG = 1 - WREG
    BTFSS	STATUS, C	    ; If 1>=y, then C must be SET
    GOTO	CHECK_Y_4	
    MOVLW	3		    ; WREG = 3
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_Y_4:
    MOVF	y, W		    ; WREG = y
    SUBLW	4		    ; WREG = 4 - WREG
    BTFSS	STATUS, C	    ; If 4>=y, then C must be SET
    GOTO	CHECK_Y_ELSE 	
    MOVLW	2		    ; WREG = 2
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_Y_ELSE:
    MOVLW	1		    ; WREG = 1
    MOVWF	box		    ; box = WREG
    GOTO END_STATEMENT
    
    
    
;else if (x <= 7)
    ;if (y <= 5) box=5;
    ;else           box=4;

CHECK_X_7:
    MOVF	x, W		    ; WREG = x
    SUBLW	7		    ; WREG = 7 - WREG
    BTFSS	STATUS, C	    ; If 7>=x, then C must be SET
    GOTO	CHECK_X_OTHER	
    GOTO        CHECK_Y_5      
    
    
CHECK_Y_5:
    MOVF	y, W		    ; WREG = y
    SUBLW	5		    ; WREG = 5 - WREG
    BTFSS	STATUS, C	    ; If 5>=y, then C must be SET
    GOTO	CHECK_Y_OTHER	
    MOVLW	5		    ; WREG = 5
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_Y_OTHER:
    MOVLW	4		    ; WREG = 4
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
    
;else 
    ;if (y<=2)         box=9;
    ;else if (y<=6) box=8;
    ;else if (y<=8) box=7;
    ;else                 box=6;
CHECK_X_OTHER:
    MOVF	y, W		    ; WREG = y
    SUBLW	2	            ; WREG = 2 - WREG
    BTFSS	STATUS, C	    ; If 2>=y, then C must be SET
    GOTO	CHECK_Y_6	
    MOVLW	9		    ; WREG = 9
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_Y_6:
    MOVF	y, W		    ; WREG = y
    SUBLW	6		    ; WREG = 6 - WREG
    BTFSS	STATUS, C	    ; If 6>=y, then C must be SET
    GOTO	CHECK_Y_8	
    MOVLW	8		    ; WREG = 8
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_Y_8:
    MOVF	y, W		    ; WREG = y
    SUBLW	8		    ; WREG = 8 - WREG
    BTFSS	STATUS, C	    ; If 8>=y, then C must be SET
    GOTO	CHECK_OTHER	
    MOVLW	7		    ; WREG = 7
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
CHECK_OTHER:
    MOVLW	6		    ; WREG = 6
    MOVWF	box		    ; box = WREG
    GOTO        END_STATEMENT
    
    
END_STATEMENT:
    MOVF box, W


    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END



