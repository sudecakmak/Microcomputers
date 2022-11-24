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
    
    x	    EQU	    0x20
    y	    EQU	    0X21
    N	    EQU	    0X22
    sum	    EQU	    0X23
    R_L	    EQU	    0x24	; Low byte of the result
    R_H	    EQU	    0x25	; High byte of the result. R = X * Y
    temp    EQU     0x26
    count   EQU     0x27
    Rem     EQU     0x28
    Q       EQU     0x29
    A	    EQU	    0x32  
	
    MOVLW   A
    MOVWF   FSR ; FSR = &A[0]
    
    
main:
    
    MOVLW   112
    MOVWF   x
    MOVLW   100
    MOVWF   y
    MOVLW   125
    MOVWF   N
    
    
    CALL GenerateNumbers
    CALL AddNumbers
    CALL DisplayNumbers
    GOTO finish
    
    ;x*y
Multiply:
    COUNT   EQU	    0x70	
    CLRF    COUNT	; COUNT = 0
    BSF	    COUNT, 3	; COUNT = 8  
    CLRF    R_H		; R_H = 0
    MOVFW   y		; WREG = y (Multiplier)
    MOVWF   R_L		; R_L = WREG
    MOVFW   x		; WREG = x (Multiplicant)
    RRF	    R_L, F	; R_L = R_L >> 1
Mult8x8_Loop:
    BTFSC   STATUS, C	; Is the least significant bit of Y equal to 1?
    ADDWF   R_H, F	; R_H = R_H + WREG
    RRF	    R_H, F	; R_H = R_H >> 1
    RRF	    R_L, F	; R_L = R_L >> 1
    
    DECFSZ  COUNT	; COUNT = COUNT-1       
    GOTO    Mult8x8_Loop
    RETURN		; DONE

    ;temp/3
Division:
    Counter	    EQU	    0x71    
    MOVLW   8
    MOVWF   Counter
    CLRF    Rem
    MOVF    temp, W
    MOVWF   Q
process:
    BCF	    STATUS, C		
    RLF	    Q, F
    RLF	    Rem, F
    MOVLW   3
    SUBWF   Rem, W
    BTFSS   STATUS, C
    GOTO    countdown
    BSF	    Q, 0
    MOVWF   Rem
countdown:
    DECFSZ  Counter, F
    GOTO    process
    RETURN
    
    
GenerateNumbers:
    ;y<N
    MOVF	N, W		    ; WREG = N
    SUBWF	y, W		    ; WREG = y - WREG
    BTFSC	STATUS, C	    ; If y<N, then C must be NOT set
    GOTO	x_small_N
    GOTO        true
    ;x<N
x_small_N:
    MOVF	N, W		    ; WREG = N
    SUBWF	x, W		    ; WREG = x - WREG
    BTFSC	STATUS, C	    ; If x<N, then C must be NOT set
    GOTO	generate_end
    GOTO        true
true:
    ;(x + y) % 2
    MOVF    x, W
    ADDWF   y, W
    MOVWF   temp
    BTFSC   temp, 0
    GOTO    true_if
    ;else
    MOVF    x, W
    ADDWF   y, W
    MOVWF   temp
    MOVWF   temp
    CALL    Division
    INCF    count, F   ; count++
    
    ; A[count] = Q
    MOVF    Q, W
    MOVWF   INDF
    INCF    FSR, F
    
    ; y = y + 3
    INCF    y, F
    INCF    y, F
    INCF    y, F
    GOTO    GenerateNumbers
 
true_if:
    CALL    Multiply
    INCF    count, F    ; count++
    
    ; A[count] = R_L + R_H
    MOVF    R_L, W
    ADDWF   R_L, W  ;2*p0
    ADDWF   R_H, W
    MOVWF   temp
    MOVF    temp, W
    MOVWF   INDF
    INCF    FSR, F
    
    ; x = x + 1
    INCF    x, F
    GOTO    GenerateNumbers
    
generate_end: 
    RETURN
    
AddNumbers:
    MOVLW   0
    MOVWF   sum
    
    i	    EQU		0x72
    MOVLW   A
    MOVWF   FSR
    CLRF    i
loop:
    MOVF    count, W
    SUBWF   i, W
    BTFSC   STATUS, C
    GOTO    loop_end
    ;sum += A[i] 
    MOVF    INDF, W
    INCF    FSR, F
    ADDWF   sum, F
    ;i++
    INCF    i, F
    GOTO    loop
loop_end:
    RETURN
    
    
DisplayNumbers:
    BANKSEL	 TRISD
    CLRF	 TRISD
    MOVLW	 0xFF
    MOVWF	 TRISB
    BANKSEL	 PORTD
    
delayMiliSecond EQU 0x30
currentDelayMicroSecond EQU 0x31
 
    m EQU 0x73
    MOVLW d'5'
    MOVWF m
 
   
    MOVLW A
    MOVWF FSR
    MOVF sum, W
    MOVWF PORTD
    GOTO delay_250

for:
    MOVF INDF, W
    MOVWF PORTD
    INCF FSR, F
    ; FSR < 5
    DECFSZ m, F
    GOTO delay_250
    RETURN

delay_250:
    NOP
    DECFSZ delayMiliSecond, F
    GOTO delay_begin
    GOTO button_3

delay_begin:
    MOVLW d'250'
    MOVWF currentDelayMicroSecond
    GOTO delay_body

delay_body:
    NOP
    DECFSZ currentDelayMicroSecond, F
    GOTO delay_body
    GOTO delay_250

button_3:
    BTFSC PORTB, 3
    GOTO button_3
    GOTO for

    
    
finish:
    
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
    END



