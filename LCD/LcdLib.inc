; This LCD library assumes that ALL 8 data pins [D7-D0] are connected to pins [7-0] of PORTD.
; Thus the LCD is used in 8-bit mode.
;
; Control pints [RS, R/W, E] are assumed to be connected to pins [0-2] of PORTE in this order
; That is, RS must be connected to pin0 of PORTE
;          R/W must be connected to pin1 of PORTE
;          E (Enable) must be connected to pin2 PORTE
;

#define LCD_NO_OF_DATA_BITS	4
;#define LCD_NO_OF_DATA_BITS	8
	
;------------------------------------------------------------
; This is how we set up the configuration bits of the LCD
#if 0
; These are the connections in our experiment board
#define	RS	PORTE, 0    ; RS is connected to pin 0 of PORTE
#define	RW	PORTE, 1    ; RW is connected to pin 1 of PORTE
#define	EN	PORTE, 2    ; E  is connected to pin 2 of PORTE

#else
; These are the connections in PICSIM
#define	RS	PORTE, 2    ; RS is connected to pin 2 of PORTE
#define	RW	PORTE, 0    ; RW is connected to pin 0 of PORTE
#define	EN	PORTE, 1    ; E  is connected to pin 1 of PORTE
#endif
    
#define D7	PORTD, 7    ; Which pin of the MCU is connected to D7 of the LCD?    
#define D6	PORTD, 6    ; Which pin of the MCU is connected to D6 of the LCD?    
#define D5	PORTD, 5    ; Which pin of the MCU is connected to D5 of the LCD?    
#define D4	PORTD, 4    ; Which pin of the MCU is connected to D4 of the LCD?  

#if LCD_NO_OF_DATA_BITS == 8    
#define D3	PORTD, 3    ; Which pin of the MCU is connected to D3 of the LCD?    
#define D2	PORTD, 2    ; Which pin of the MCU is connected to D2 of the LCD?    
#define D1	PORTD, 1    ; Which pin of the MCU is connected to D1 of the LCD?    
#define D0	PORTD, 0    ; Which pin of the MCU is connected to D0 of the LCD?    
#endif
    
; The LCD display has two lines of characters, 16 characters per line. 
; Each character is composed of matrix of pixels size 5x8. 
; The matrix is controlled by Hitachi HD44780 controller, 
; which performs all the operations that are required to run the matrix. 
; Controller operation is done in accordance with the instructions it receives as described below:
;
; A 2x16 character LCD has 14 pins
; DB0 - DB7, the 8 data bus lines, which perform read/write of data
; Vss, Vdd - Voltage supply pins
; R/W ? Pin writing/reading to/from - LCD
; RS - Pin selects registers between Instruction Register and Data Register
; E - "Enabling" pin; when this pin is set to logical low, the LCD does not care what is happening 
;     with R/W, RS, and the data bus lines; when this pin is set to logical high, the - LCD is processing the incoming data
; Vo - Pin for LCD contrast
;
; Some of the addresses represent the lines of LCD (0x00-0x0F- first line; 0x40-0x4F second line). 
; The rest of the addresses represent the ?non-visible? memory of the DRAM, 
; which can be also used as a general memory. The DDRAM address is the position 
; of the cursor on the display LCD (the received information will be written 
; at the place where the cursor is).
; 
; Below be show the meaning of each configuration of <RS:RW> bits.
; RS	R/W	 
; 0	0	Sends a command to LCD
; 0	1	Read busy flag (DB7) and address counter (DB0 to DB6)
; 1	0	Sends information to LCD
; 1	1	Reads information from LCD
	    
;------------------------------------------------------------
; Before we start using the LCD, we must first initialize certain bits
;
LCD_Initialize    
    ; During a power reset, LCD takes up to 10ms to reboot and stabilize
    ; before a command can be sent to it. Therefore, we wait for 10ms 
    ; before sending the first command
    BCF		EN		    ; Make EN pin 0
    BCF		RS		    ; Make RS bit 0 -- Will send commands
    BCF		RW		    ; Make RW bit 0
    CLRF	PORTD		    ; Make all bits of PORTD 0
    CALL	Delay_20ms	    ; Wait for 20ms
    
    ; Set LCD usage mode: 4-bit/2-lines/5x7 dot chars
    IF 	LCD_NO_OF_DATA_BITS == 4
	BCF	D7		    ; D7=0
	BCF	D6		    ; D6=0
	BSF	D5		    ; D5=1
	BSF	D4		    ; D4=1
	CALL	LCD_Send_Trigger    ; Send 0x3 to the LCD: Means Attention
	CALL	Delay_20ms
	
	CALL	LCD_Send_Trigger    ; Send 0x3 to the LCD: Means Attention
	CALL	Delay_20ms

	CALL	LCD_Send_Trigger    ; Send 0x3 to the LCD Means Attention
	CALL	Delay_20ms
	
	BCF	D7		    ; D7=0
	BCF	D6		    ; D6=0
	BSF	D5		    ; D5=1
	BCF	D4		    ; D4=0
	CALL	LCD_Send_Trigger    ; Send 0x2: Puts the LCD in 4-bit mode
	CALL	Delay_20ms
    
	; Now start sending commands
	MOVLW	0x28		    ; 4-bit, 2-lines, 5x7 dot characters: 0011 1000
	CALL	LCD_Send_Command    ; Send the command to the LCD
	
    ELSE	
	MOVLW	0x30		    ; Attention
	CALL	LCD_Send_Command    ; Send the command to the LCD
	CALL	Delay_20ms	    

	MOVLW	0x30		    ; Attention
	CALL	LCD_Send_Command    ; Send the command to the LCD
	CALL	Delay_20ms	    

	MOVLW	0x30		    ; Attention
	CALL	LCD_Send_Command    ; Send the command to the LCD
	CALL	Delay_20ms	    
	
	MOVLW	0x38		    ; 8-bit, 2-lines, 5x7 dot characters: 0011 1000
	CALL	LCD_Send_Command    ; Send the command to the LCD
    ENDIF	
    
	; Turn the LCD on and set cursor properties
;	MOVLW	0x0F		    ; LCD open, cursor on, cursor blinking:      0000 1111
;	MOVLW	0x0E		    ; LCD open, cursor on, cursor off:      0000 1111
	MOVLW	0x0C		    ; LCD open, cursor off, cursor not blinking: 0000 1100
	CALL	LCD_Send_Command    ; Send the command to the LCD

	MOVLW	0x06		    ; Entry mode: 0000 0110
	CALL	LCD_Send_Command    ; Send the command to the LCD
	
	; Clear the current contents of the LCD and move the cursor to the start of the first line
	CALL	LCD_Clear
	RETURN

;------------------------------------------------------------	
; Sends one byte stored in WREG to the LCD
;	
LCD_Send
    MOVWF	PORTD		    ; PORTD <- WREG
    CALL	LCD_Send_Trigger    ; Send the trigger signal to LCD so that the sent command is executed
	
    IF	LCD_NO_OF_DATA_BITS == 4
	SWAPF	PORTD		    ; Swap bits [7-4] with [3-0]
	CALL	LCD_Send_Trigger    ; Send the trigger signal to LCD so that the sent command is executed
    ENDIF
    
    RETURN
	
;------------------------------------------------------------	
; Display the character in WREG at the current cursor position
;	
LCD_Send_Command
	BCF	RS		    ; 
	BCF	RW		    ; <RS:RW>=<0:0> means we are sending a command to the LCD

	CALL	LCD_Send	    ; Send the command
	RETURN
		
;------------------------------------------------------------	
; Display the character in WREG at the current cursor position
;	
LCD_Send_Char
	BSF	RS		    ; 
	BCF	RW		    ; <RS:RW>=<1:0> means, we will be sending data

	CALL	LCD_Send	    ; Send the character
	RETURN
	
;------------------------------------------------------------	
; Clear the LCD
;
LCD_Clear	
	MOVLW	0x01		    ; 0x1 is the clear LCD command
	CALL	LCD_Send_Command	

	CALL	Delay_5ms	    ; Wait for 5 ms for LCD to finish clearing the screen
	RETURN	

;------------------------------------------------------------	
; Move the cursor to the start of the second line
;
LCD_MoveCursor2SecondLine
	; Set DD RAM Address:
	; This sets the DD RAM address.
	; and the cursor advances in the direction where the I/D bit was set to. The line settings are as follows:
	; RS	R/W	D7	D6	D5	D4	D3	D2	D1	D0
	; 0	0	1	MSB DD RAM ADDRESS LSB	
	MOVLW	0xC0		    ; Address of the first byte of the second line: 0x40
	CALL	LCD_Send_Command
	RETURN
	
;------------------------------------------------------------
; For LCD to process a given data (from the data bits), we first
; need to enable it, wait for some time (until LCD finishes processing
; the command), and then disable the E pin. This is called sending a trigger signal
; This essentially means that we send the following signal to the E pin of the LCD
;      +-----+ 
;      |     |
;      |     |
; -----+ 1us +--------
;
; Many flip-flop based devices work this way. After you put the data at the input pins
; of the device, you need to send a trigger signal for the device to process that input
;
LCD_Send_Trigger		
	BCF	EN		; Bring the Enable bit to 0
	NOP
	NOP
	NOP
	NOP			; Wait for 5 microseconds
	BSF	EN		; Bring the Enable bit to 1
	NOP			
	NOP
	NOP
	NOP
	NOP			; Wait for 5 microseconds	
	BCF	EN		; Bring the Enable bit back to 0 (processing occurs on this falling edge?)
	CALL	Delay_125us	; Wait 125 microsecond for LCD to finish processing of the previous command
	RETURN