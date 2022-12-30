    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    
    ; ---------- Your code starts here --------------------------
    
    BSF		STATUS, RP0 ; Select Bank1
    MOVLW	0xFF
    MOVWF	TRISB
    MOVLW	0x00
    MOVWF	TRISA
    CLRF	TRISD
    BCF		STATUS, RP0 ; Select Bank0
    BSF		PORTA, 5
      
    digit_counter	 EQU        0x20
    NUM			 EQU        0x21
	 
    MOVLW	 0
    MOVWF	 digit_counter 
  
    CALL	 Init_NUM
    CALL         Show_digit

loop:
        
button_3:
    CALL	Delay100ms	    ;Wait for 100 ms before checking the button status again
    BTFSC	PORTB, 3
    GOTO	button_4	    ;not press 3
    GOTO	IncrementCounter    ;press 3
    
button_4:
    BTFSC	PORTB, 4
    GOTO	button_5	    ;not press 4
    GOTO	DecrementCounter    ;press 4
    
button_5:
    BTFSC	PORTB, 5
    GOTO        loop		    ;not press 5
    GOTO	ResetCounter        ;press 5
 
    
ResetCounter:                       ;reset counter to 0
    CALL	Delay100ms
    MOVLW	0
    MOVWF	digit_counter 
    GOTO	Show_digit
    
DecrementCounter:                   ;decrement counter
    CALL	Delay100ms
    MOVLW	0		   
    SUBWF	digit_counter, W		   
    BTFSS	STATUS, Z	   
    GOTO	not_0
    MOVLW	9
    MOVWF       digit_counter       ;0->9
    GOTO	Show_digit
not_0:
    DECF	digit_counter, F
    GOTO	Show_digit
    
IncrementCounter:                   ;increment counter
    CALL	Delay100ms
    MOVLW	9		   
    SUBWF	digit_counter, W		   
    BTFSS	STATUS, Z	   
    GOTO	not_9
    CLRF        digit_counter       ;9->0
    GOTO	Show_digit
not_9:
    INCF	digit_counter, F
    GOTO	Show_digit
    
    
Show_digit:
    MOVF	digit_counter, W
    CALL	GetCode       
    MOVWF	PORTD
    GOTO        loop
    
    
GetCode:
    MOVWF   FSR		; FSR = number
    MOVLW   NUM		; WREG = &LUT
    ADDWF   FSR, F	; FSR += &LUT
    MOVF    INDF, W	; WREG = LUT[number]
    RETURN
    
    
Delay100ms:
    i		EQU	    0x70		   
    j		EQU	    0x71		    
		
    MOVLW	    d'100'		    ; 
    MOVWF	    i			    ; i = 100
OuterLoop:
    MOVLW	    d'250'
    MOVWF	    j			    ; j = 250
InnerLoop:	
    NOP
    DECFSZ	    j, F		    ; j--
    GOTO	    InnerLoop

    DECFSZ	    i, F		    ; i?
    GOTO	    OuterLoop    
    RETURN

	
    
Init_NUM:
    MOVLW   B'00111111'		
    MOVWF   NUM			; LUT[0] = WREG    
    MOVLW   B'00000110'		
    MOVWF   NUM+1		; LUT[0] = WREG    
    MOVLW   B'01011011'		
    MOVWF   NUM+2		; LUT[0] = WREG    
    MOVLW   B'01001111'		
    MOVWF   NUM+3		; LUT[0] = WREG    
    MOVLW   B'01100110'		
    MOVWF   NUM+4		; LUT[0] = WREG    
    MOVLW   B'01101101'		
    MOVWF   NUM+5		; LUT[0] = WREG    
    MOVLW   B'01111101'		
    MOVWF   NUM+6		; LUT[0] = WREG    
    MOVLW   B'00000111'		
    MOVWF   NUM+7		; LUT[0] = WREG    
    MOVLW   B'01111111'		
    MOVWF   NUM+8		; LUT[0] = WREG    
    MOVLW   B'01101111'		  
    MOVWF   NUM+9		; LUT[0] = WREG  
    RETURN
  
    
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END
