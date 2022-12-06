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
    
    
    
    ; If you want to change the delay you must go to the row """120"""
    
    Move_left	EQU	0x20
    Move_right	EQU	0x21
    dir		EQU     0x22
    count       EQU     0x23
    val         EQU     0x24
	 

    CLRF  TRISD
    CLRF  TRISB
    CLRF  PORTB
	
    MOVLW   0
    MOVWF   Move_left
    
    MOVLW   1
    MOVWF   Move_right
    
    MOVF    Move_left,W
    MOVWF   dir
    
    MOVLW   0x1
    MOVWF   val
    
    MOVLW   0
    MOVWF   count
	
    CALL SELECTDELAY
   
   
begin:
    MOVF    val,W
    MOVWF   PORTD
    CALL    SELECTDELAY
    
    INCF    count,F
    
    MOVLW   15
    SUBWF   count,W
    BTFSS   STATUS,Z
    GOTO    not_15
    
    CLRF    PORTD	     ; PORTD=0: Turn off all LEDs
    CALL    SELECTDELAY      ; Wait for -- sec

    MOVLW   0xFF	     ; WREG = 0xFF
    MOVWF   PORTD	     ; PORTD = WREG = 0xFF: Turn on all LEDs
    CALL    SELECTDELAY      ; Wait for -- sec 
    
    CLRF    PORTD	     ; PORTD=0: Turn off all LEDs
    CALL    SELECTDELAY      ; Wait for -- sec

    MOVLW   0xFF	     ; WREG = 0xFF
    MOVWF   PORTD	     ; PORTD = WREG = 0xFF: Turn on all LEDs
    CALL    SELECTDELAY      ; Wait for -- sec 
    
    CLRF    PORTD	     ; PORTD=0: Turn off all LEDs
    CALL    SELECTDELAY      ; Wait for -- sec
    
    MOVLW   0x1
    MOVWF   val
    
    MOVLW   0
    MOVWF   count
    
    MOVF    Move_left,W
    MOVWF   dir
    GOTO    begin
    
not_15:
    
    MOVLW 0x80
    SUBWF val, W
    BTFSS STATUS, Z
    GOTO not_80
    
    MOVF Move_right,W
    MOVWF dir
    
not_80:
    
    MOVF Move_left, W
    SUBWF dir, W
    BTFSS STATUS, Z
    GOTO not_equal
    
    BCF STATUS, C
    RLF val, F      ; val = val << 1
    GOTO begin
    
not_equal:
    
    BCF STATUS, C
    RRF val, F      ; val = val >> 1
    GOTO begin
       

SELECTDELAY:
    
    CALL DELAY250
    ;CALL DELAY500
    RETURN

   
DELAY250:
    
    i	EQU	    0x70		    ; Use memory slot 0x70
    j	EQU	    0x71		    ; Use memory slot 0x71
    
    MOVLW	    d'250'		    ; 
    MOVWF	    i			    ; i = 250

    Delay250ms_OuterLoop
    MOVLW	    d'250'
    MOVWF	    j			    ; j = 250

    Delay250ms_InnerLoop	
    NOP
    DECFSZ	    j, F		    ; j--
    GOTO	    Delay250ms_InnerLoop

    DECFSZ	    i, F		    ; i?
    GOTO	    Delay250ms_OuterLoop    
    RETURN
	    
	   
DELAY500:
    
    i	EQU	    0x70
    j	EQU	    0x71
    k	EQU	    0x72
    
    MOVLW	    d'2'
    MOVWF	    i			    ; i = 2
   
    Delay500ms_Loop1_Begin
    MOVLW	    d'250'
    MOVWF	    j			    ; j = 250
    
    Delay500ms_Loop2_Begin	
    MOVLW	    d'250'
    MOVWF	    k			    ; k = 250
    
    Delay500ms_Loop3_Begin	
    NOP					    ; Do nothing
    DECFSZ	    k, F		    ; k--
    GOTO	    Delay500ms_Loop3_Begin

    DECFSZ	    j, F		    ; j--
    GOTO	    Delay500ms_Loop2_Begin

    DECFSZ	    i, F		    ; i?
    GOTO	    Delay500ms_Loop1_Begin    
    RETURN
    

EndOf:
    
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END
