
_mrf_delay400us:

;mrf_delays.c,10 :: 		void mrf_delay400us(){
;mrf_delays.c,11 :: 		delay_us(400);
	MOVLW       3
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_mrf_delay400us0:
	DECFSZ      R13, 1, 1
	BRA         L_mrf_delay400us0
	DECFSZ      R12, 1, 1
	BRA         L_mrf_delay400us0
	NOP
	NOP
;mrf_delays.c,12 :: 		}
L_end_mrf_delay400us:
	RETURN      0
; end of _mrf_delay400us

_mrf_delay2ms:

;mrf_delays.c,13 :: 		void mrf_delay2ms(){
;mrf_delays.c,14 :: 		delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_mrf_delay2ms1:
	DECFSZ      R13, 1, 1
	BRA         L_mrf_delay2ms1
	DECFSZ      R12, 1, 1
	BRA         L_mrf_delay2ms1
	NOP
	NOP
;mrf_delays.c,15 :: 		}
L_end_mrf_delay2ms:
	RETURN      0
; end of _mrf_delay2ms

_mrf_delay10us:

;mrf_delays.c,17 :: 		void mrf_delay10us(){
;mrf_delays.c,18 :: 		delay_us(10);
	MOVLW       16
	MOVWF       R13, 0
L_mrf_delay10us2:
	DECFSZ      R13, 1, 1
	BRA         L_mrf_delay10us2
	NOP
;mrf_delays.c,19 :: 		}
L_end_mrf_delay10us:
	RETURN      0
; end of _mrf_delay10us
