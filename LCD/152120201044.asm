    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    cblock  0x50
    msg	; 0x20 -- We will have 4 digits digits[0]: LSB, digits[1], digits[2], digit[3]: MSB		
    endc

    ; Reset vector
    org	0x00	
    GOTO	MAIN		; Jump to the main function

    #include <Delay.inc>	; Delay library (Copy the contents here)
    #include <LcdLib.inc>	; LcdLib.inc (LCD) utility routines

; This is the start of our main function
MAIN:    
    BSF         STATUS, RP0	; Select Bank1
    MOVLW	0x0	 	; WREG <- 0	
    MOVWF       TRISD		; Make all pins of PORTD output
    MOVWF	TRISE		; Make all ports of PORTE output	
    MOVLW	0x03		; Choose RA0 analog input and RA3 reference input
    MOVWF	ADCON1		; Register to configure PORTA's pins as analog/digital <11> means, all but one are analog

    BCF	        STATUS, RP0	; Select Bank0			
    CALL	LCD_Initialize	; Initialize the LCD
	
    BSF		STATUS, RP0		; Select Bank1
    CLRF	TRISA		;	PortA --> Output
    CLRF	TRISD		;	PortD --> Output
    BCF		STATUS, RP0		; Select Bank0

    CLRF	PORTD		; PORTD = 0
    CLRF	PORTA		; Deselect all SSDs	
    
    
    digit0	    EQU	    0x20
    digit1	    EQU	    0x21
    no_iteration    EQU     0x22
    i		    EQU     0x23
    LUT		    EQU     0x24
    
    CALL	Init_LUT
		    
    MOVLW	0
    MOVWF	digit0

    MOVLW	0
    MOVWF	digit1
    
    MOVLW	90		   
    MOVWF	no_iteration		   
    
    CALL        Countingup
    
for:    
    BCF		PORTA, 5
    BCF		PORTA, 4
    CALL        DisplayCounter
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
    CALL        Countingup
    MOVLW	2		   
    SUBWF	digit1, W		   
    BTFSS	STATUS, Z
    GOTO	for
    
    MOVLW	1		  
    SUBWF	digit0, W		   
    BTFSS	STATUS, Z	    
    GOTO	for
    
    CLRF	digit0
    CLRF	digit1
    CALL        Rollingup
    GOTO	for

    
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
Delay5ms_OuterLoop:
	MOVLW	    d'250'
	MOVWF	    l			    ; j = 250
Delay5ms_InnerLoop:	
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
  
    
DisplayCounter:
    call	LCD_Clear		; Clear the LCD screen

    movlw	'C'	    
    call	LCD_Send_Char

    movlw	'o'	    
    call	LCD_Send_Char

    movlw	'u'	    
    call	LCD_Send_Char

    movlw	'n'	    
    call	LCD_Send_Char

    movlw	't'	    
    call	LCD_Send_Char

    movlw	'e'	
    call	LCD_Send_Char

    movlw	'r'	
    call	LCD_Send_Char

    movlw	' '	
    call	LCD_Send_Char

    movlw	'V'	
    call	LCD_Send_Char

    movlw	'a'	
    call	LCD_Send_Char

    movlw	'l'	
    call	LCD_Send_Char
    
    movlw	':'	
    call	LCD_Send_Char
    
    movlw	' '	
    call	LCD_Send_Char
    

    ; Print digit1: digits[1]
    MOVF	digit1, W ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char

    ; Print digit1: LSB
    MOVF	digit0, W   ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char

    
    ; The rest of the characters will get displayed on the second line
    CALL	LCD_MoveCursor2SecondLine   ; Move the cursor to the start of the second line
    CALL        DisplayMessage
    RETURN
    
DisplayMessage:
    MOVF	msg, W
    CALL	LCD_Send_Char
    MOVF	msg+1, W
    CALL	LCD_Send_Char
    MOVF	msg+2, W
    CALL	LCD_Send_Char
    MOVF	msg+3, W
    CALL	LCD_Send_Char
    MOVF	msg+4, W
    CALL	LCD_Send_Char
    MOVF	msg+5, W
    CALL	LCD_Send_Char
    MOVF	msg+6, W
    CALL	LCD_Send_Char
    MOVF	msg+7, W
    CALL	LCD_Send_Char
    MOVF	msg+8, W
    CALL	LCD_Send_Char
    MOVF	msg+9, W
    CALL	LCD_Send_Char
    MOVF	msg+10, W
    CALL	LCD_Send_Char
    MOVF	msg+11, W
    CALL	LCD_Send_Char
    MOVF	msg+12, W
    CALL	LCD_Send_Char
    MOVF	msg+13, W
    CALL	LCD_Send_Char
    MOVF	msg+14, W
    CALL	LCD_Send_Char
    MOVF	msg+15, W
    CALL	LCD_Send_Char
    RETURN
    
Countingup:
    CALL ClearMessage
    MOVLW 'C'
    MOVWF msg
    MOVLW 'o'
    MOVWF msg + 1
    MOVLW 'u'
    MOVWF msg + 2
    MOVLW 'n'
    MOVWF msg + 3
    MOVLW 't'
    MOVWF msg + 4
    MOVLW 'i'
    MOVWF msg + 5
    MOVLW 'n'
    MOVWF msg + 6
    MOVLW 'g'
    MOVWF msg + 7
    MOVLW ' '
    MOVWF msg + 8
    MOVLW 'u'
    MOVWF msg + 9
    MOVLW 'p'
    MOVWF msg + 10
    MOVLW '.'
    MOVWF msg + 11
    MOVLW '.'
    MOVWF msg + 12
    MOVLW '.'
    MOVWF msg + 13
    RETURN
    
Rollingup:
    CALL ClearMessage
    MOVLW 'R'
    MOVWF msg
    MOVLW 'o'
    MOVWF msg + 1
    MOVLW 'l'
    MOVWF msg + 2
    MOVLW 'l'
    MOVWF msg + 3
    MOVLW 'e'
    MOVWF msg + 4
    MOVLW 'd'
    MOVWF msg + 5
    MOVLW ' '
    MOVWF msg + 6
    MOVLW 'o'
    MOVWF msg + 7
    MOVLW 'v'
    MOVWF msg + 8
    MOVLW 'e'
    MOVWF msg + 9
    MOVLW 'r'
    MOVWF msg + 10
    MOVLW ' '
    MOVWF msg + 11
    MOVLW 't'
    MOVWF msg + 12
    MOVLW 'o'
    MOVWF msg + 13
    MOVLW ' '
    MOVWF msg + 14
    MOVLW '0'
    MOVWF msg + 15
    RETURN
    
ClearMessage:
    CLRF msg
    CLRF msg+1
    CLRF msg+2
    CLRF msg+3
    CLRF msg+4
    CLRF msg+5
    CLRF msg+6
    CLRF msg+7
    CLRF msg+8
    CLRF msg+9
    CLRF msg+10
    CLRF msg+11
    CLRF msg+12
    CLRF msg+13
    CLRF msg+14
    CLRF msg+15
    RETURN
    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END
