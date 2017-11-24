
_interrupt:

;node2.c,122 :: 		void interrupt() {
;node2.c,123 :: 		RDAQ_Int_Proc();
	CALL        _RDAQ_Int_Proc+0, 0
;node2.c,124 :: 		}
L_end_interrupt:
L__interrupt13:
	RETFIE      1
; end of _interrupt

_main:

;node2.c,126 :: 		void main(){
;node2.c,127 :: 		PORTA     = 0x00;         // Clear PortA
	CLRF        PORTA+0 
;node2.c,128 :: 		PORTB     = 0x00;         // Clear PortB
	CLRF        PORTB+0 
;node2.c,129 :: 		PORTC     = 0x00;         // Clear PortC
	CLRF        PORTC+0 
;node2.c,130 :: 		TRISA     = 0b00101111;    // PortA direction set
	MOVLW       47
	MOVWF       TRISA+0 
;node2.c,131 :: 		TRISB     = 0b00000101;    // PortB direction set
	MOVLW       5
	MOVWF       TRISB+0 
;node2.c,139 :: 		TRISC     = 0x00;         // PortC all output
	CLRF        TRISC+0 
;node2.c,140 :: 		LATA      = 0x00;         // Clear LATA
	CLRF        LATA+0 
;node2.c,141 :: 		LATB      = 0x00;         // Clear LATB
	CLRF        LATB+0 
;node2.c,142 :: 		LATC      = 0x00;         // Clear LATC
	CLRF        LATC+0 
;node2.c,144 :: 		INTCON    = 0b00000000;    // disable all interrupts
	CLRF        INTCON+0 
;node2.c,145 :: 		INTCON2   = 0b00000000;    // Set RBPU to 0 and make INTEDG2 on falling edge
	CLRF        INTCON2+0 
;node2.c,146 :: 		INTCON3   = 0x00;         // Hi priority interrupt//s disabled
	CLRF        INTCON3+0 
;node2.c,147 :: 		IPR1      = 0x00;         // All priority's REG1 is Low
	CLRF        IPR1+0 
;node2.c,148 :: 		IPR2      = 0x00;         // All priority's REG2 is Low
	CLRF        IPR2+0 
;node2.c,149 :: 		RCON.IPEN = 0x00;         // Disable Priority Levels
	BCF         RCON+0, 7 
;node2.c,150 :: 		PIE1      = 0x00;         // All others interrupt on PIE1 disabled
	CLRF        PIE1+0 
;node2.c,151 :: 		PIE2      = 0x00;         // all others interrupt on PIE2 disabled
	CLRF        PIE2+0 
;node2.c,152 :: 		PIR1      = 0x00;         // All flags on PIR1 cleared
	CLRF        PIR1+0 
;node2.c,153 :: 		PIR2      = 0x00;         // All flags on PIR2 cleared
	CLRF        PIR2+0 
;node2.c,154 :: 		ADCON1    = 0x0A;         // All ports as A/D In.
	MOVLW       10
	MOVWF       ADCON1+0 
;node2.c,155 :: 		CMCON     = 0x07;         // Comparators off
	MOVLW       7
	MOVWF       CMCON+0 
;node2.c,157 :: 		FlushTx;                  // Clear TX ctrl buffer
	CLRF        _DataLenght+0 
;node2.c,159 :: 		Timer1H =    0x02;
	MOVLW       2
	MOVWF       _Timer1H+0 
;node2.c,160 :: 		Timer1L =    0x18;  //13ms
	MOVLW       24
	MOVWF       _Timer1L+0 
;node2.c,163 :: 		T0CON = 0x80; //start TMR0
	MOVLW       128
	MOVWF       T0CON+0 
;node2.c,164 :: 		T1CON = 0x00;
	CLRF        T1CON+0 
;node2.c,165 :: 		TMR1L = Timer1L;
	MOVLW       24
	MOVWF       TMR1L+0 
;node2.c,166 :: 		TMR1H = Timer1H;
	MOVLW       2
	MOVWF       TMR1H+0 
;node2.c,167 :: 		TX_Locked = 0;
	BCF         _TX_Locked+0, BitPos(_TX_Locked+0) 
;node2.c,168 :: 		counter   = 0;
	CLRF        _counter+0 
	CLRF        _counter+1 
;node2.c,171 :: 		T1CON = T1CON & 0xCF; //%11001111 1:1
	MOVLW       207
	ANDWF       T1CON+0, 1 
;node2.c,175 :: 		TX_BUFFER[10] = timer1h;      //idx 11 pc
	MOVLW       2
	MOVWF       _TX_BUFFER+10 
;node2.c,176 :: 		TX_BUFFER[11] = timer1l;      //idx 12 pc
	MOVLW       24
	MOVWF       _TX_BUFFER+11 
;node2.c,177 :: 		TX_BUFFER[12] = 0b00000000;   //idx 13 pc
	CLRF        _TX_BUFFER+12 
;node2.c,178 :: 		TX_BUFFER[13] = 0x7F;         //idx 14 pc
	MOVLW       127
	MOVWF       _TX_BUFFER+13 
;node2.c,179 :: 		TX_BUFFER[14] = 0x00;         //idx 15 pc
	CLRF        _TX_BUFFER+14 
;node2.c,180 :: 		TX_BUFFER[15] = 0b11001101;   //idx 16 pc
	MOVLW       205
	MOVWF       _TX_BUFFER+15 
;node2.c,181 :: 		TX_BUFFER[16] = 0x31;         //idx 17 pc
	MOVLW       49
	MOVWF       _TX_BUFFER+16 
;node2.c,187 :: 		ad_Ready = 0;
	BCF         _ad_Ready+0, BitPos(_ad_Ready+0) 
;node2.c,188 :: 		RX_Tasks = 0;
	BCF         _RX_Tasks+0, BitPos(_RX_Tasks+0) 
;node2.c,191 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       249
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;node2.c,192 :: 		PWM1_Set_Duty(1);
	MOVLW       1
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;node2.c,195 :: 		MRF_HW_Config();
	CALL        _MRF_HW_Config+0, 0
;node2.c,200 :: 		this_PANID[0]    = 0x12;
	MOVLW       18
	MOVWF       _this_PANID+0 
;node2.c,201 :: 		this_PANID[1]    = 0x34;
	MOVLW       52
	MOVWF       _this_PANID+1 
;node2.c,205 :: 		this_MAC[0]    = 'N';
	MOVLW       78
	MOVWF       _this_MAC+0 
;node2.c,206 :: 		this_MAC[1]    = 'O';
	MOVLW       79
	MOVWF       _this_MAC+1 
;node2.c,207 :: 		this_MAC[2]    = 'D';
	MOVLW       68
	MOVWF       _this_MAC+2 
;node2.c,208 :: 		this_MAC[3]    = 'E';
	MOVLW       69
	MOVWF       _this_MAC+3 
;node2.c,209 :: 		this_MAC[4]    = ' ';
	MOVLW       32
	MOVWF       _this_MAC+4 
;node2.c,210 :: 		this_MAC[5]    = 'T';
	MOVLW       84
	MOVWF       _this_MAC+5 
;node2.c,211 :: 		this_MAC[6]    = 'W';
	MOVLW       87
	MOVWF       _this_MAC+6 
;node2.c,212 :: 		this_MAC[7]    = 'O';
	MOVLW       79
	MOVWF       _this_MAC+7 
;node2.c,215 :: 		dst_ADDRESS[0] = 'N';
	MOVLW       78
	MOVWF       _dst_ADDRESS+0 
;node2.c,216 :: 		dst_ADDRESS[1] = 'O' ;
	MOVLW       79
	MOVWF       _dst_ADDRESS+1 
;node2.c,217 :: 		dst_ADDRESS[2] = 'D';
	MOVLW       68
	MOVWF       _dst_ADDRESS+2 
;node2.c,218 :: 		dst_ADDRESs[3] = 'E';
	MOVLW       69
	MOVWF       _dst_ADDRESS+3 
;node2.c,219 :: 		dst_ADDRESS[4] = ' ';
	MOVLW       32
	MOVWF       _dst_ADDRESS+4 
;node2.c,220 :: 		dst_ADDRESS[5] = 'O';
	MOVLW       79
	MOVWF       _dst_ADDRESS+5 
;node2.c,221 :: 		dst_ADDRESS[6] = 'N';
	MOVLW       78
	MOVWF       _dst_ADDRESS+6 
;node2.c,222 :: 		dst_ADDRESS[7] = 'E';
	MOVLW       69
	MOVWF       _dst_ADDRESS+7 
;node2.c,227 :: 		if (!MRF_Init(this_PANID)){
	MOVLW       _this_PANID+0
	MOVWF       FARG_MRF_Init_PANID+0 
	MOVLW       hi_addr(_this_PANID+0)
	MOVWF       FARG_MRF_Init_PANID+1 
	CALL        _MRF_Init+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main0
;node2.c,228 :: 		goto MRF_Module_notInitialized;
	GOTO        ___main_MRF_Module_notInitialized
;node2.c,229 :: 		}
L_main0:
;node2.c,231 :: 		TMR0ON_bit = 0;    //stop tmr0
	BCF         TMR0ON_bit+0, 7 
;node2.c,232 :: 		T0CON      = 0x28; //reconfigures TMR0 as couter
	MOVLW       40
	MOVWF       T0CON+0 
;node2.c,233 :: 		TMR0L      = 0x00;
	CLRF        TMR0L+0 
;node2.c,234 :: 		TMR0H      = 0x00;
	CLRF        TMR0H+0 
;node2.c,236 :: 		_RXHWIF = 0;
	BCF         INT2IF_bit+0, 1 
;node2.c,239 :: 		TMR1IF_bit  = 0;
	BCF         TMR1IF_bit+0, 0 
;node2.c,240 :: 		TMR1IE_bit  = 1;
	BSF         TMR1IE_bit+0, 0 
;node2.c,241 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;node2.c,242 :: 		INTCON.GIE  = 1;
	BSF         INTCON+0, 7 
;node2.c,244 :: 		TMR1ON_bit  = 1;
	BSF         TMR1ON_bit+0, 0 
;node2.c,246 :: 		do {
L_main1:
;node2.c,247 :: 		if (MRF_PacketReceived()){
	CALL        _MRF_PacketReceived+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;node2.c,248 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;node2.c,249 :: 		RDAQ_Tasks();
	CALL        _RDAQ_Tasks+0, 0
;node2.c,250 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;node2.c,251 :: 		}
L_main4:
;node2.c,252 :: 		if (ad_Ready){
	BTFSS       _ad_Ready+0, BitPos(_ad_Ready+0) 
	GOTO        L_main5
;node2.c,253 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;node2.c,254 :: 		DataLenght = 17;
	MOVLW       17
	MOVWF       _DataLenght+0 
;node2.c,255 :: 		P2PSTATUS = 0;
	CLRF        _P2PSTATUS+0 
	CLRF        _P2PSTATUS+1 
;node2.c,256 :: 		MRF_SendDataPkt(this_PANID, dst_ADDRESS,no,_SEND_AS_DATA,no);
	MOVLW       _this_PANID+0
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+0 
	MOVLW       hi_addr(_this_PANID+0)
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+1 
	MOVLW       _dst_ADDRESS+0
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+0 
	MOVLW       hi_addr(_dst_ADDRESS+0)
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+1 
	CLRF        FARG_MRF_SendDataPkt_Broadcast+0 
	MOVLW       1
	MOVWF       FARG_MRF_SendDataPkt_SEND_AS+0 
	CLRF        FARG_MRF_SendDataPkt_Sec_Enabled+0 
	CALL        _MRF_SendDataPkt+0, 0
;node2.c,257 :: 		FlushTx;
	CLRF        _DataLenght+0 
;node2.c,258 :: 		ad_Ready = 0;
	BCF         _ad_Ready+0, BitPos(_ad_Ready+0) 
;node2.c,259 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;node2.c,260 :: 		}
L_main5:
;node2.c,264 :: 		if (TMR1ON_bit == 0){
	BTFSC       TMR1ON_bit+0, 0 
	GOTO        L_main6
;node2.c,265 :: 		counter++;
	INFSNZ      _counter+0, 1 
	INCF        _counter+1, 1 
;node2.c,266 :: 		if (counter == 1000){
	MOVF        _counter+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVLW       232
	XORWF       _counter+0, 0 
L__main15:
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;node2.c,267 :: 		counter = 0;
	CLRF        _counter+0 
	CLRF        _counter+1 
;node2.c,268 :: 		DataLenght = 17;
	MOVLW       17
	MOVWF       _DataLenght+0 
;node2.c,269 :: 		P2PSTATUS  = 0;
	CLRF        _P2PSTATUS+0 
	CLRF        _P2PSTATUS+1 
;node2.c,270 :: 		MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
	MOVLW       _this_PANID+0
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+0 
	MOVLW       hi_addr(_this_PANID+0)
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+1 
	MOVLW       _dst_ADDRESS+0
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+0 
	MOVLW       hi_addr(_dst_ADDRESS+0)
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+1 
	CLRF        FARG_MRF_SendDataPkt_Broadcast+0 
	MOVLW       1
	MOVWF       FARG_MRF_SendDataPkt_SEND_AS+0 
	CLRF        FARG_MRF_SendDataPkt_Sec_Enabled+0 
	CALL        _MRF_SendDataPkt+0, 0
;node2.c,271 :: 		}
L_main7:
;node2.c,272 :: 		}
L_main6:
;node2.c,274 :: 		TX_BUFFER[14].B0 = RC0_bit;
	BTFSC       RC0_bit+0, 0 
	GOTO        L__main16
	BCF         _TX_BUFFER+14, 0 
	GOTO        L__main17
L__main16:
	BSF         _TX_BUFFER+14, 0 
L__main17:
;node2.c,275 :: 		TX_BUFFER[14].B1 = RC1_bit;
	BTFSC       RC1_bit+0, 1 
	GOTO        L__main18
	BCF         _TX_BUFFER+14, 1 
	GOTO        L__main19
L__main18:
	BSF         _TX_BUFFER+14, 1 
L__main19:
;node2.c,276 :: 		TX_BUFFER[14].B2 = RC6_bit;
	BTFSC       RC6_bit+0, 6 
	GOTO        L__main20
	BCF         _TX_BUFFER+14, 2 
	GOTO        L__main21
L__main20:
	BSF         _TX_BUFFER+14, 2 
L__main21:
;node2.c,277 :: 		TX_BUFFER[14].B3 = RB6_bit;
	BTFSC       RB6_bit+0, 6 
	GOTO        L__main22
	BCF         _TX_BUFFER+14, 3 
	GOTO        L__main23
L__main22:
	BSF         _TX_BUFFER+14, 3 
L__main23:
;node2.c,278 :: 		TX_BUFFER[14].B4 = RB7_bit;
	BTFSC       RB7_bit+0, 7 
	GOTO        L__main24
	BCF         _TX_BUFFER+14, 4 
	GOTO        L__main25
L__main24:
	BSF         _TX_BUFFER+14, 4 
L__main25:
;node2.c,279 :: 		}while(1);
	GOTO        L_main1
;node2.c,280 :: 		MRF_Module_NotInitialized:
___main_MRF_Module_notInitialized:
;node2.c,283 :: 		do {
L_main8:
;node2.c,284 :: 		LATC0_bit = ~LATC0_bit;
	BTG         LATC0_bit+0, 0 
;node2.c,285 :: 		LATC1_bit = ~LATC1_bit;
	BTG         LATC1_bit+0, 1 
;node2.c,286 :: 		LATC6_bit = ~LATC6_bit;
	BTG         LATC6_bit+0, 6 
;node2.c,287 :: 		LATB6_bit = ~LATB6_bit;
	BTG         LATB6_bit+0, 6 
;node2.c,288 :: 		LATB7_bit = ~LATB7_bit;
	BTG         LATB7_bit+0, 7 
;node2.c,289 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	DECFSZ      R11, 1, 1
	BRA         L_main11
	NOP
;node2.c,290 :: 		}while(1);
	GOTO        L_main8
;node2.c,291 :: 		}//
L_end_main:
	GOTO        $+0
; end of _main
