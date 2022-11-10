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

    ;--------------------------------------------------------------------------
    tmp1	EQU	0x20	; A temporary variable
    tmp2	EQU	0x21	; Another temporary variable
    tmp3        EQU     0x22    ; Another temporary variable
   
    x	        EQU	0x23
    y		EQU	0x24
    z		EQU	0x25
    
    r1		EQU	0x26
    r2		EQU	0x27
    r3		EQU	0x28
    r4		EQU	0x29
    r		EQU	0x30
    
    MOVLW   5		; WREG = 5
    MOVWF   x		; x = 5
    MOVLW   6		; WREG = 6
    MOVWF   y		; x = 6
    MOVLW   7       	; WREG = 7
    MOVWF   z		; z = 7
    
    ; r1 = (5 * x - 2 * y + z - 3);    
   
    ; 5 * x
    MOVF    x, W	; WREG = x
    MOVWF   tmp1	; tmp1 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp1, F	; tmp1 = tmp1*2
    RLF	    tmp1, F	; tmp1 = tmp1*2
    MOVF    tmp1, W     ; WREG = tmp1
    ADDWF   x, W	; WREG = tmp1+WREG
    MOVWF   tmp1        ; tmp1 = WREG
    
    ; 2 * y
    MOVF    y, W	; WREG = y
    MOVWF   tmp2	; tmp2 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp2, F	; tmp2 = tmp2*2
    
    ; z - 3
    MOVLW   3	        ; WREG = 3
    SUBWF   z, W	; WREG = z-WREG 
    MOVWF   tmp3	; tmp3 = WREG
    
    ; (5 * x - 2 * y + z - 3)
    MOVF    tmp2, W	; WREG = tmp2
    SUBWF   tmp1, W	; WREG = tmp1-WREG
    ADDWF   tmp3, W     ; WREG = tmp3+WREG
    
    MOVWF   r1		; r1 = WREG [r1 = (5 * x - 2 * y + z - 3)] 

;--------------------------------------
    CLRF   tmp1   ; Clear tmp1
    CLRF   tmp2   ; Clear tmp2 
    CLRF   tmp3   ; Clear tmp3
    
    ;  r2 = (x + 5) * 4 - 3 * y + z; 
    
    ;  (x + 5) * 4
    MOVLW   5   	; WREG = 5
    ADDWF   x, W	; WREG = x+WREG 
    MOVWF   tmp1	; tmp1 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp1, F	; tmp1 = tmp1*2
    RLF	    tmp1, F	; tmp1 = tmp1*2
    
    ;3 * y + z
    MOVF    y, W	; WREG = y
    MOVWF   tmp2	; tmp2 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp2, F	; tmp2 = tmp2*2
    MOVF    tmp2, W     ; WREG = tmp2
    ADDWF   y, W	; WREG = y+WREG
    MOVWF   tmp2        ; tmp2 = WREG
    
    MOVF    tmp2, W	; WREG = tmp2
    SUBWF   tmp1, W	; WREG = tmp1-WREG
    ADDWF   z, W	; WREG = z+WREG
    
    MOVWF   r2		; r2 = WREG  [r2 = (x + 5) * 4 - 3 * y + z]
    
    
    ;--------------------------------------
    CLRF   tmp1   ; Clear tmp1
    CLRF   tmp2   ; Clear tmp2 
    CLRF   tmp3   ; Clear tmp3
    
    ;   r3 = x / 2 + y / 2 + z / 4;  
    
    ; x / 2
    MOVF    x, W	; WREG = x
    MOVWF   tmp1	; tmp1 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RRF	    tmp1, F	; tmp1 = tmp1/2
   
    ; y / 2
    MOVF    y, W	; WREG = y
    MOVWF   tmp2	; tmp2 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RRF	    tmp2, F	; tmp2 = tmp2/2
    
    ; z / 4
    MOVF    z, W	; WREG = z
    MOVWF   tmp3	; tmp3 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RRF	    tmp3, F	; tmp3 = tmp3/2
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RRF	    tmp3, F	; tmp3 = tmp3/2
    
    MOVF    tmp1, W	; WREG = tmp1
    ADDWF   tmp2, W	; WREG = tmp2+WREG
    ADDWF   tmp3, W	; WREG = tmp3+WREG
    
    MOVWF   r3		; r3 = WREG  [r3 = x / 2 + y / 2 + z / 4]
    
    
    ;--------------------------------------
    CLRF   tmp1   ; Clear tmp1
    CLRF   tmp2   ; Clear tmp2 
    CLRF   tmp3   ; Clear tmp3
    
    ; r4 = (3 * x - y - 3 * z) * 2 - 30;  
    
    ;( 3 * x - y)
    MOVF     x, W	; WREG = x
    MOVWF   tmp1	; tmp1 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp1, F	; tmp1 = tmp1*2
    MOVF    tmp1, W     ; WREG = tmp1
    ADDWF   x, W	; WREG = x+WREG 
    MOVWF   tmp1        ; tmp1 = WREG
    
    MOVF    y, W	; WREG = y
    MOVWF   tmp2	; tmp2 = WREG
    
    MOVF    tmp2, W	; WREG = tmp2
    SUBWF   tmp1, W	; WREG = tmp1-WREG
    MOVWF   tmp1	; tmp1 = WREG
    
    ;3 * z
    MOVF    z, W	; WREG = z
    MOVWF   tmp2	; tmp2 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp2, F	; tmp2 = tmp2*2
    MOVF    tmp2, W     ; WREG = tmp2
    ADDWF   z, W	; WREG = z+WREG
    MOVWF   tmp2        ; tmp2 = WREG
    
    ;(3 * x - y - 3 * z)
    MOVF    tmp2, W	; WREG = tmp2
    SUBWF   tmp1, W	; WREG = tmp1-WREG
    
    ;(3 * x - y - 3 * z) * 2
    MOVWF   tmp3	; tmp3 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp3, F	; tmp3 = tmp3*2
    
    ; (3 * x - y - 3 * z) * 2 - 30
    MOVLW   30		; WREG = 30
    MOVWF   tmp1	; tmp1 = 30
    MOVF    tmp1, W	; WREG = tmp1
    SUBWF   tmp3, W	; WREG = tmp3-WREG
    
    MOVWF   r4		; r4 = WREG  [r3 = (3 * x - y - 3 * z) * 2 - 30]
    
   ;----------------------------------------
   
    CLRF   tmp1   ; Clear tmp1
    CLRF   tmp2   ; Clear tmp2 
    CLRF   tmp3   ; Clear tmp3
    
    ; r = 3 * r1 + 2 * r2 - r3 / 2 - r4;
    ;3 * r1
    MOVF    r1, W	; WREG = r1
    MOVWF   tmp1	; tmp1 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp1, F	; tmp1 = tmp1*2
    MOVF    tmp1, W     ; WREG = tmp1
    ADDWF   r1, W	; WREG = r1+WREG
    MOVWF   tmp1        ; tmp1 = WREG
    
    ;3 * r1 + 2 * r2
    MOVF    r2, W	; WREG = r2
    MOVWF   tmp2	; tmp2 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RLF	    tmp2, F	; tmp2 = tmp2*2
    MOVF    tmp2, W	; WREG = tmp2
    ADDWF   tmp1, W     ; WREG = tmp1+WREG
    MOVWF   tmp1        ; tmp1 = WREG
    
     ; r3 / 2
    MOVF    r3, W	; WREG = r3
    MOVWF   tmp3	; tmp3 = WREG
    BCF	    STATUS, C	; Clear the carry bit in STATUS register
    RRF	    tmp3, F	; tmp3 = tmp3/2
    MOVF    tmp3, W     ; WREG = tmp3
   
    ;r = 3 * r1 + 2 * r2 - r3 / 2
    SUBWF   tmp1, W     ; WREG = tmp1-WREG
    MOVWF   tmp3	; tmp3 = WREG
    
     ; r = 3 * r1 + 2 * r2 - r3 / 2 - r4;
    MOVF    r4, W	; WREG = r4
    SUBWF   tmp3, W     ; WREG = tmp3-WREG
    
    MOVWF   r		; r = WREG  [r = 3 * r1 + 2 * r2 - r3 / 2 - r4]
    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END
    


