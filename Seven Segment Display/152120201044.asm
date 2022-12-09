    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    
    BSF	    STATUS, RP0		; Select Bank1
    CLRF    TRISA		; PortA --> Output
    CLRF    TRISD		; PortD --> Output
    BCF	    STATUS, RP0		; Select Bank0

    
    CLRF    PORTD		; PORTD = 0
    CLRF    PORTA		; Deselect all SSDs	
    
    
    digit0	    EQU	    0x20
    digit1	    EQU	    0x21
    no_iteration    EQU     0x22
    i		    EQU     0x23
    LUT		    EQU     0x24
    
    CALL    Init_LUT
		    
    MOVLW	0
    MOVWF	digit0

    MOVLW	0
    MOVWF	digit1
    
    MOVLW	90		   
    MOVWF	no_iteration		   

    
    
for:    
    MOVLW	1		    
    MOVWF	i		   
loop_begin:	
    MOVF	i, W		    
    SUBWF	no_iteration, W	   
    BTFSS	STATUS, C	   
    GOTO	loop_end	    
loop_body:			    
   
    BSF		PORTA, 5
    BCF		PORTA, 4 
    MOVF	digit0, W
    CALL	GetCode      ; SSDCodes [digit0]  
    MOVWF	PORTD
    CALL	Delay5ms
    
    BSF		PORTA, 4
    BCF		PORTA, 5 
    MOVF	digit1, W
    CALL	GetCode      ; SSDCodes [digit1]  
    MOVWF	PORTD
    CALL	Delay5ms
    
    INCF	i, F		    ; i++
    GOTO	loop_begin
loop_end:
    
    CLRF	i
    INCF	digit0, F
    
    ;     if (digit0 == 10)
    MOVLW	10		   
    SUBWF	digit0, W		   
    BTFSS	STATUS, Z	   
    GOTO	not_equal
 
    MOVLW	0
    MOVWF	digit0
    INCF	digit1, F

not_equal:
    
    ;      if (digit1 == 2 && digit0 == 1)
    MOVLW	1		  
    SUBWF	digit0, W		   
    BTFSS	STATUS, Z	    
    GOTO	loop_begin
   
    MOVLW	2		   
    SUBWF	digit1, W		   
    BTFSS	STATUS, Z
    GOTO	loop_begin
    
    MOVLW	0
    MOVWF	digit0
    MOVLW	0
    MOVWF	digit1
    GOTO	loop_begin

    
GetCode:
    MOVWF   FSR		; FSR = number
    MOVLW   LUT		; WREG = &LUT
    ADDWF   FSR, F	; FSR += &LUT
    MOVF    INDF, W	; WREG = LUT[number]
    RETURN
    
    
Delay5ms:
	k	EQU	    0x70		    ; Use memory slot 0x70
	l	EQU	    0x71		    ; Use memory slot 0x71
	
	MOVLW	    d'5'		    ; 
	MOVWF	    k			    ; i = 5
Delay5ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    l			    ; j = 250
Delay5ms_InnerLoop	
	NOP
	DECFSZ	    l, F		    ; --j == 0?
	GOTO	    Delay5ms_InnerLoop

	DECFSZ	    k, F		    ; --i == 0?
	GOTO	    Delay5ms_OuterLoop
	RETURN
    
    
Init_LUT:
    MOVLW   B'00111111'		; 0
    MOVWF   LUT			; LUT[0] = WREG    
    MOVLW   B'00000110'		; 1
    MOVWF   LUT+1		; LUT[0] = WREG    
    MOVLW   B'01011011'		; 2
    MOVWF   LUT+2		; LUT[0] = WREG    
    MOVLW   B'01001111'		; 3
    MOVWF   LUT+3		; LUT[0] = WREG    
    MOVLW   B'01100110'		; 4
    MOVWF   LUT+4		; LUT[0] = WREG    
    MOVLW   B'01101101'		; 5
    MOVWF   LUT+5		; LUT[0] = WREG    
    MOVLW   B'01111101'		; 6
    MOVWF   LUT+6		; LUT[0] = WREG    
    MOVLW   B'00000111'		; 7
    MOVWF   LUT+7		; LUT[0] = WREG    
    MOVLW   B'01111111'		; 8
    MOVWF   LUT+8		; LUT[0] = WREG    
    MOVLW   B'01101111'		; 9    
    MOVWF   LUT+9		; LUT[0] = WREG  
    RETURN
    
    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END
