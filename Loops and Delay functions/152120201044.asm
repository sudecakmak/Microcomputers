    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    
    BANKSEL TRISB ; Select the Bank where TRISB is located (Bank 1)
    MOVLW 0xFF
    MOVWF TRISB ; Make all pins of PORTB as input pins
    CLRF TRISD ; Make all pins of PORTD as output pins
    BANKSEL PORTD ; Select the Bank where PORTB is located (Bank 0)
    CLRF PORTD ; Turn off all LEDs
    
    ; ---------- Your code starts here --------------------------
    
    fib0    EQU	    0x20
    fib1    EQU	    0x21
    fib	    EQU	    0x22
    i	    EQU	    0x23
    N	    EQU	    0x24
    temp    EQU     0x25
     
     
    MOVLW	1		    ; WREG = 1
    MOVWF	fib0		    ; fib0 = WREG

    MOVLW	2		    ; WREG = 2
    MOVWF	fib1		    ; fib1 = WREG
    
    MOVLW	2		    ; WREG = 2
    MOVWF	i		    ; i = WREG

    MOVLW	13		    ; WREG = 13
    MOVWF	N		    ; N = WREG
    
   
;for loop
loop_begin:	
	; Check if i<=N? If not, we will terminate the loop
	; The loop terminates when i > N or N < i.
	
	MOVF	i, W		    ; WREG = i
	SUBWF	N, W		    ; WREG = N - i
	BTFSS	STATUS, C	    ; No carry means N < i. Carry means N >= i or i <= N
	GOTO	loop_end	    ; when i > N, the loop terminates
	
loop_body:
    
        ;zib = (zib1 & 0x3f) + (zib0 | 0x05)
	
	MOVF	fib1, W		    ; WREG = fib1
	ANDLW	0x3f                ; WREG = fib1 & 0x3f
	MOVWF	temp                ; temp = WREG
	
	MOVF	fib0, W		    ; WREG = fib0
	IORLW	0x05                ; WREG = fib0 | 0x05
	ADDWF	temp, W		    ; WREG += temp
	MOVWF   fib                 ; fib = WREG
   
	MOVF	fib1, W		    ; WREG = fib1
	MOVWF   fib0                ; fib0 = WREG
	
	MOVF	fib, W		    ; WREG = fib
	MOVWF   fib1                ; fib1 = WREG
	MOVF	fib, W		    ; WREG = fib
	MOVWF   PORTD
	
	CALL    Delay250ms
	INCF	i, F		    ; i++
	
	button_3:     ; while (PORTB3 == 1)
	BTFSC	PORTB, 3
	GOTO	button_3
	GOTO	loop_begin
	
		
loop_end:
    
;------------------------------------------------------------------------------
; Waste 250ms in a loop
;------------------------------------------------------------------------------
Delay250ms:
	k	    EQU	    0x70		    ; Use memory slot 0x70
	j	    EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'250'		    
	MOVWF	    k			    ; k = 250
	
Delay250ms_OuterLoop:
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
	
Delay250ms_InnerLoop:	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    k, F		    ; k--
	GOTO	    Delay250ms_OuterLoop    
	RETURN
	
	
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END



