; Keep these variables in the 16 byte memory area shared by all banks 
; so that we don't have to worry about bank selection
; The shared ares is in between [0x70-0x7f]
delay_counter1	EQU	0x7c
delay_counter2	EQU	0x7d
delay_counter3	EQU	0x7e
delay_counter4	EQU	0x7f	

;------------------------------------------------------------
; Assumes that the microprocessor is run with a 4Mhz oscilator
; In a 4Mhz oscilator, one operation takes 1 microsecond	
; With this code, 42x3=126 cycles are obtained on the average
;------------------------------------------------------------
Delay_125us
	MOVLW	0x2A		    ; Decimal 42
	MOVWF	delay_counter1	    ; 
LABEL_125us_DELAY
	DECFSZ	delay_counter1, F   ; 
	GOTO	LABEL_125us_DELAY
	RETURN	

;------------------------------------------------------------
; Simply call Delay_125us 8 times to obtain a 1ms delay
;------------------------------------------------------------
Delay_1ms
	MOVLW	.8		    ; WREG <- Decimal 8
	MOVWF	delay_counter2	    ; delay_counter2 <- WREG
LABEL_1ms_DELAY	
	CALL	Delay_125us	    ; Call 125 microsecond delay
	DECFSZ	delay_counter2, F   ; Do this 8 times. 8x125us = 1ms
	GOTO	LABEL_1ms_DELAY	   
	RETURN
	
;------------------------------------------------------------
; Simply call Delay_1ms 5 times to obtain a 5ms delay
;------------------------------------------------------------
Delay_5ms
	MOVLW	.5		    ; WREG <- Decimal 5
	MOVWF	delay_counter3	    ; delay_counter3 <- WREG
LABEL_5ms_DELAY	
	CALL	Delay_1ms	    ; Call 1 microsecond delay
	DECFSZ	delay_counter3, F   ; Do this 5 times. 5x1ms = 5ms
	GOTO	LABEL_5ms_DELAY	    
	RETURN

;------------------------------------------------------------
; Simply call Delay_1ms 20 times to obtain a 20ms delay
;------------------------------------------------------------
Delay_20ms
	MOVLW	.20		    ; WREG <- Decimal 5
	MOVWF	delay_counter3	    ; delay_counter3 <- WREG
LABEL_20ms_DELAY	
	CALL	Delay_1ms	    ; Call 1 microsecond delay
	DECFSZ	delay_counter3, F   ; Do this 20 times. 30x1ms = 20ms
	GOTO	LABEL_20ms_DELAY	    
	RETURN
	
;------------------------------------------------------------
; Simply call Delay_5ms 10 times to obtain a 100ms delay
;------------------------------------------------------------
Delay_50ms
	MOVLW	.10		    ; WREG <- Decimal 10
	MOVWF	delay_counter4	    ; delay_counter4 <- WREG
LABEL_50ms_DELAY	
	CALL	Delay_5ms	    ; Call 5 microsecond delay
	DECFSZ	delay_counter4, F   ; Do this 10 times. 10x5ms = 50ms
	GOTO	LABEL_50ms_DELAY	    
	RETURN

;------------------------------------------------------------
; Simply call Delay_5ms 20 times to obtain a 100ms delay
;------------------------------------------------------------
Delay_100ms
	MOVLW	.20		    ; WREG <- Decimal 20
	MOVWF	delay_counter4	    ; delay_counter4 <- WREG
LABEL_100ms_DELAY	
	CALL	Delay_5ms	    ; Call 5 microsecond delay
	DECFSZ	delay_counter4, F   ; Do this 20 times. 20x5ms = 100ms
	GOTO	LABEL_100ms_DELAY	    
	RETURN

;------------------------------------------------------------
; Simply call Delay_5ms 50 times to obtain a 250ms delay
;------------------------------------------------------------
Delay_250ms
	MOVLW	.50		    ; WREG <- Decimal 50
	MOVWF	delay_counter4	    ; delay_counter4 <- WREG
LABEL_250ms_DELAY	
	CALL	Delay_5ms	    ; Call 5 microsecond delay
	DECFSZ	delay_counter4, F   ; Do this 50 times. 50x5ms = 250ms
	GOTO	LABEL_250ms_DELAY	    
	RETURN

;------------------------------------------------------------
; Simply call Delay_5ms 100 times to obtain a 500ms delay
;------------------------------------------------------------
Delay_500ms
	MOVLW	.100		    ; WREG <- Decimal 100
	MOVWF	delay_counter4	    ; delay_counter4 <- WREG
LABEL_500ms_DELAY	
	CALL	Delay_5ms	    ; Call 5 microsecond delay
	DECFSZ	delay_counter4, F   ; Do this 100 times. 100x5ms = 500ms
	GOTO	LABEL_500ms_DELAY	    
	RETURN
	
;------------------------------------------------------------
; Simply call Delay_5ms 200 times to obtain a 1sec delay
;------------------------------------------------------------
Delay_1s
	MOVLW	.200		    ; WREG <- Decimal 200
	MOVWF	delay_counter4	    ; delay_counter4 <- WREG
LABEL_1s_DELAY	
	CALL	Delay_5ms	    ; Call 5 microsecond delay
	DECFSZ	delay_counter4, F   ; Do this 200 times. 200x5ms = 1sec
	GOTO	LABEL_1s_DELAY	    
	RETURN
	
	

	