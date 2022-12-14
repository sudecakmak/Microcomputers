    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    cblock  0x48
    msg		
    endc

    ; Reset vector
    org	0x00	
    GOTO	MAIN		; Jump to the main function

    #include <Delay.inc>	; Delay library (Copy the contents here)
    #include <LcdLib.inc>	; LcdLib.inc (LCD) utility routines


MAIN:    
    BSF         STATUS, RP0	
    MOVLW	0x0	 		
    MOVWF       TRISD		
    MOVWF	TRISE			
    MOVLW	0x03		; Choose RA0 analog input and RA3 reference input
    MOVWF	ADCON1		; Register to configure PORTA's pins as analog/digital <11> means, all but one are analog

    BCF	        STATUS, RP0	; Select Bank0			
    CALL	LCD_Initialize	; Initialize the LCD
	
    BSF		STATUS, RP0		; Select Bank1
    CLRF	TRISA			; PortA --> Output
    CLRF	TRISD			; PortD --> Output
    BCF		STATUS, RP0	    	; Select Bank0

    CLRF	PORTD		; PORTD = 0
    CLRF	PORTA		; Deselect all SSDs	
    
    
    digit0	    EQU	    0x20
    digit1	    EQU	    0x21
    no_iteration    EQU     0x22
    i		    EQU     0x23
    NUM		    EQU     0x24
    
    CALL	Init_NUM
		    
    MOVLW	0
    MOVWF	digit0

    MOVLW	0
    MOVWF	digit1
    
    MOVLW	90		   
    MOVWF	no_iteration		   
    
    CALL        Countingup
    
for_loop:    
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
    CALL        Countingup   ; not 00
    MOVLW	2		   
    SUBWF	digit1, W		   
    BTFSS	STATUS, Z
    GOTO	for_loop
    
    MOVLW	1		  
    SUBWF	digit0, W		   
    BTFSS	STATUS, Z	    
    GOTO	for_loop
    
    CLRF	digit0
    CLRF	digit1
    CALL        Rollingup  ; 00
    GOTO	for_loop

    
GetCode:
    MOVWF   FSR		; FSR = number
    MOVLW   NUM		; WREG = &LUT
    ADDWF   FSR, F	; FSR += &LUT
    MOVF    INDF, W	; WREG = LUT[number]
    RETURN
    
    
Delay5ms:
	k	EQU	    0x70		    ; Use memory slot 0x70
	l	EQU	    0x71		    ; Use memory slot 0x71
	
	MOVLW	    d'5'		    ; 
	MOVWF	    k			    ; k = 5
OuterLoop:
	MOVLW	    d'250'
	MOVWF	    l			    ; l = 250
InnerLoop:	
	NOP
	DECFSZ	    l, F		    ; --l == 0?
	GOTO	    InnerLoop

	DECFSZ	    k, F		    ; --k == 0?
	GOTO	    OuterLoop
	RETURN
    
    
Init_NUM:
    MOVLW   B'00111111'		; 0
    MOVWF   NUM			; NUM[0] = WREG    
    MOVLW   B'00000110'		; 1
    MOVWF   NUM+1		 
    MOVLW   B'01011011'		; 2
    MOVWF   NUM+2		 
    MOVLW   B'01001111'		; 3
    MOVWF   NUM+3		  
    MOVLW   B'01100110'		; 4
    MOVWF   NUM+4		 
    MOVLW   B'01101101'		; 5
    MOVWF   NUM+5	   
    MOVLW   B'01111101'		; 6
    MOVWF   NUM+6		  
    MOVLW   B'00000111'		; 7
    MOVWF   NUM+7		  
    MOVLW   B'01111111'		; 8
    MOVWF   NUM+8		 
    MOVLW   B'01101111'		; 9    
    MOVWF   NUM+9		
    RETURN
  
    
DisplayCounter:
    call	LCD_Clear		; Clear the LCD screen

    ;Write Counter val
    MOVLW	'C'	    
    call	LCD_Send_Char

    MOVLW	'o'	    
    call	LCD_Send_Char

    MOVLW	'u'	    
    call	LCD_Send_Char

    MOVLW	'n'	    
    call	LCD_Send_Char

    MOVLW	't'	    
    call	LCD_Send_Char

    MOVLW	'e'	
    call	LCD_Send_Char

    MOVLW	'r'	
    call	LCD_Send_Char

    MOVLW	' '	
    call	LCD_Send_Char

    MOVLW	'V'	
    call	LCD_Send_Char

    MOVLW	'a'	
    call	LCD_Send_Char

    MOVLW	'l'	
    call	LCD_Send_Char
    
    MOVLW	':'	
    call	LCD_Send_Char
    
    MOVLW	' '	
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
    CALL        ShowMessage
    RETURN
    
ShowMessage:
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
    
Clear:
    ; Clear messagge in the second line
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
    
Countingup:
    CALL Clear
    
    ;Write counting up
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
    CALL Clear
    
    ;Write Rolled over to 0
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
    
    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END






