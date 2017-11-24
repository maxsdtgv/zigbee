
_sendCommand:

;node1.c,99 :: 		void sendCommand(){
;node1.c,100 :: 		P2PSTATUS = 0;
	CLRF        _P2PSTATUS+0 
	CLRF        _P2PSTATUS+1 
;node1.c,101 :: 		MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_COMMAND,no);
	MOVLW       _this_PANID+0
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+0 
	MOVLW       hi_addr(_this_PANID+0)
	MOVWF       FARG_MRF_SendDataPkt_dstPAN+1 
	MOVLW       _dst_ADDRESS+0
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+0 
	MOVLW       hi_addr(_dst_ADDRESS+0)
	MOVWF       FARG_MRF_SendDataPkt_dstADDRESS+1 
	CLRF        FARG_MRF_SendDataPkt_Broadcast+0 
	MOVLW       3
	MOVWF       FARG_MRF_SendDataPkt_SEND_AS+0 
	CLRF        FARG_MRF_SendDataPkt_Sec_Enabled+0 
	CALL        _MRF_SendDataPkt+0, 0
;node1.c,102 :: 		}
L_end_sendCommand:
	RETURN      0
; end of _sendCommand

_interrupt:

;node1.c,105 :: 		void interrupt() iv 0x0008{
;node1.c,106 :: 		USB_Interrupt_Proc();
	CALL        _USB_Interrupt_Proc+0, 0
;node1.c,107 :: 		}
L_end_interrupt:
L__interrupt21:
	RETFIE      1
; end of _interrupt

_USB_Tasks:

;node1.c,109 :: 		void USB_Tasks(){
;node1.c,111 :: 		K = HID_Read();
	CALL        _HID_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _K+0 
;node1.c,112 :: 		if (K > 9) {
	MOVF        R0, 0 
	SUBLW       9
	BTFSC       STATUS+0, 0 
	GOTO        L_USB_Tasks0
;node1.c,113 :: 		if (userRD_buffer[0] == 0){return;}
	MOVF        1280, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_USB_Tasks1
	GOTO        L_end_USB_Tasks
L_USB_Tasks1:
;node1.c,114 :: 		FlushTx;
	CLRF        _DataLenght+0 
;node1.c,115 :: 		for (H = 0;H<10;H++){
	CLRF        USB_Tasks_H_L0+0 
L_USB_Tasks2:
	MOVLW       10
	SUBWF       USB_Tasks_H_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_USB_Tasks3
;node1.c,116 :: 		MRF_FillData(userRD_buffer[H]);
	MOVLW       _userRD_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_userRD_buffer+0)
	MOVWF       FSR0H 
	MOVF        USB_Tasks_H_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_MRF_FillData_txdata_byte+0 
	CALL        _MRF_FillData+0, 0
;node1.c,115 :: 		for (H = 0;H<10;H++){
	INCF        USB_Tasks_H_L0+0, 1 
;node1.c,117 :: 		}
	GOTO        L_USB_Tasks2
L_USB_Tasks3:
;node1.c,118 :: 		USB_RX_HASDATA = 1;
	BSF         _Gflags+0, 0 
;node1.c,119 :: 		}
L_USB_Tasks0:
;node1.c,120 :: 		}
L_end_USB_Tasks:
	RETURN      0
; end of _USB_Tasks

_MRF_Tasks:

;node1.c,123 :: 		void MRF_Tasks(){
;node1.c,124 :: 		K = MRF_get_pktDC();
	CALL        _MRF_get_pktDC+0, 0
	MOVF        R0, 0 
	MOVWF       _K+0 
;node1.c,125 :: 		if ((K && 0x80) == 0x80) {  //'is data
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_MRF_Tasks6
	MOVLW       1
	MOVWF       R1 
	GOTO        L_MRF_Tasks5
L_MRF_Tasks6:
	CLRF        R1 
L_MRF_Tasks5:
	MOVF        R1, 0 
	XORLW       128
	BTFSS       STATUS+0, 2 
	GOTO        L_MRF_Tasks7
;node1.c,126 :: 		K = (K & 0x7F);  //'get the lenght of packet
	MOVLW       127
	ANDWF       _K+0, 1 
;node1.c,127 :: 		for (J = 0;K<10;K++){
	CLRF        _J+0 
L_MRF_Tasks8:
	MOVLW       10
	SUBWF       _K+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MRF_Tasks9
;node1.c,128 :: 		userWR_buffer[j] = RX_BUFFER[j];
	MOVLW       _userWR_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_userWR_buffer+0)
	MOVWF       FSR1H 
	MOVF        _J+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       _RX_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_RX_BUFFER+0)
	MOVWF       FSR0H 
	MOVF        _J+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;node1.c,129 :: 		USB_TX_HASDATA  = 1;
	BSF         _Gflags+0, 1 
;node1.c,127 :: 		for (J = 0;K<10;K++){
	INCF        _K+0, 1 
;node1.c,130 :: 		}
	GOTO        L_MRF_Tasks8
L_MRF_Tasks9:
;node1.c,131 :: 		MRF_DiscardPacket();
	CALL        _MRF_DiscardPacket+0, 0
;node1.c,132 :: 		}else{                         //'is command
	GOTO        L_MRF_Tasks11
L_MRF_Tasks7:
;node1.c,133 :: 		MRF_DiscardPacket();
	CALL        _MRF_DiscardPacket+0, 0
;node1.c,134 :: 		}
L_MRF_Tasks11:
;node1.c,135 :: 		}
L_end_MRF_Tasks:
	RETURN      0
; end of _MRF_Tasks

_main:

;node1.c,137 :: 		void main(void) {
;node1.c,139 :: 		PORTA     = 0;            //' Clear PortA
	CLRF        PORTA+0 
;node1.c,140 :: 		PORTB     = 0;            //' Clear PortB
	CLRF        PORTB+0 
;node1.c,141 :: 		PORTC     = 0;            //' Clear PortC
	CLRF        PORTC+0 
;node1.c,142 :: 		TRISA     = 0x3F;         //' PortA all AD input
	MOVLW       63
	MOVWF       TRISA+0 
;node1.c,143 :: 		TRISB     = 0b00000100;
	MOVLW       4
	MOVWF       TRISB+0 
;node1.c,154 :: 		TRISC     = 0b10010000;    //' PortC.7 SDO, 4,5 USB, all others output
	MOVLW       144
	MOVWF       TRISC+0 
;node1.c,155 :: 		LATA      = 0;            //' Clear LATA
	CLRF        LATA+0 
;node1.c,156 :: 		LATB      = 0;            //' Clear LATB
	CLRF        LATB+0 
;node1.c,157 :: 		LATC      = 0;            //' Clear LATC
	CLRF        LATC+0 
;node1.c,159 :: 		T0CON     = 0x80;         //' enable tmr0
	MOVLW       128
	MOVWF       T0CON+0 
;node1.c,160 :: 		INTCON    = 0b00000000;    //' disable all interrupts
	CLRF        INTCON+0 
;node1.c,161 :: 		INTCON2   = 0b00000000;    //' disable RBPU and make INTEDG2 on falling edge
	CLRF        INTCON2+0 
;node1.c,162 :: 		INTCON3   = 0x00;         //' Hi priority interrupt's disabled
	CLRF        INTCON3+0 
;node1.c,163 :: 		IPR1      = 0x00;         //' All priority's REG1 is Low
	CLRF        IPR1+0 
;node1.c,164 :: 		IPR2      = 0x00;         //' All priority's REG2 is Low
	CLRF        IPR2+0 
;node1.c,165 :: 		RCON.IPEN = 0;            //' Disable Priority Levels
	BCF         RCON+0, 7 
;node1.c,166 :: 		PIE1      = 0;            //' All others interrupt on PIE1 disabled
	CLRF        PIE1+0 
;node1.c,167 :: 		PIE2      = 0;            //' all others interrupt on PIE2 disabled
	CLRF        PIE2+0 
;node1.c,168 :: 		PIR1      = 0;            //' All flags on PIR1 cleared
	CLRF        PIR1+0 
;node1.c,169 :: 		PIR2      = 0;            //' All flags on PIR2 cleared
	CLRF        PIR2+0 
;node1.c,170 :: 		ADCON1    = 0x0f;         //' AD0-AD4 selected
	MOVLW       15
	MOVWF       ADCON1+0 
;node1.c,172 :: 		FlushTx;                  //' Clear TX buffer
	CLRF        _DataLenght+0 
;node1.c,173 :: 		UPUEN_bit = 0;
	BCF         UPUEN_bit+0, 4 
;node1.c,175 :: 		Gflags            = 0;
	CLRF        _Gflags+0 
;node1.c,176 :: 		H                 = 0;
	CLRF        _H+0 
;node1.c,177 :: 		J                 = 0;
	CLRF        _J+0 
;node1.c,178 :: 		K                 = 0;
	CLRF        _K+0 
;node1.c,179 :: 		P2PSTATUS         = 0;
	CLRF        _P2PSTATUS+0 
	CLRF        _P2PSTATUS+1 
;node1.c,180 :: 		Headerlenght      = 0;
	CLRF        _Headerlenght+0 
;node1.c,181 :: 		_RXHWIE           = 0;
	BCF         INT2IE_bit+0, 4 
;node1.c,183 :: 		HID_Enable(userRD_buffer, userWR_buffer);
	MOVLW       _userRD_buffer+0
	MOVWF       FARG_HID_Enable_readbuff+0 
	MOVLW       hi_addr(_userRD_buffer+0)
	MOVWF       FARG_HID_Enable_readbuff+1 
	MOVLW       _userWR_buffer+0
	MOVWF       FARG_HID_Enable_writebuff+0 
	MOVLW       hi_addr(_userWR_buffer+0)
	MOVWF       FARG_HID_Enable_writebuff+1 
	CALL        _HID_Enable+0, 0
;node1.c,186 :: 		this_PANID[0]    = 0x12; //'0xFF
	MOVLW       18
	MOVWF       _this_PANID+0 
;node1.c,187 :: 		this_PANID[1]    = 0x34; //'0xFF
	MOVLW       52
	MOVWF       _this_PANID+1 
;node1.c,191 :: 		this_MAC[0]    = 'N';
	MOVLW       78
	MOVWF       _this_MAC+0 
;node1.c,192 :: 		this_MAC[1]    = 'O';
	MOVLW       79
	MOVWF       _this_MAC+1 
;node1.c,193 :: 		this_MAC[2]    = 'D';
	MOVLW       68
	MOVWF       _this_MAC+2 
;node1.c,194 :: 		this_MAC[3]    = 'E';
	MOVLW       69
	MOVWF       _this_MAC+3 
;node1.c,195 :: 		this_MAC[4]    = ' ';
	MOVLW       32
	MOVWF       _this_MAC+4 
;node1.c,196 :: 		this_MAC[5]    = 'O';
	MOVLW       79
	MOVWF       _this_MAC+5 
;node1.c,197 :: 		this_MAC[6]    = 'N';
	MOVLW       78
	MOVWF       _this_MAC+6 
;node1.c,198 :: 		this_MAC[7]    = 'E';
	MOVLW       69
	MOVWF       _this_MAC+7 
;node1.c,201 :: 		dst_ADDRESS[0] = 'N';
	MOVLW       78
	MOVWF       _dst_ADDRESS+0 
;node1.c,202 :: 		dst_ADDRESS[1] = 'O';
	MOVLW       79
	MOVWF       _dst_ADDRESS+1 
;node1.c,203 :: 		dst_ADDRESS[2] = 'D';
	MOVLW       68
	MOVWF       _dst_ADDRESS+2 
;node1.c,204 :: 		dst_ADDRESs[3] = 'E';
	MOVLW       69
	MOVWF       _dst_ADDRESS+3 
;node1.c,205 :: 		dst_ADDRESS[4] = ' ';
	MOVLW       32
	MOVWF       _dst_ADDRESS+4 
;node1.c,206 :: 		dst_ADDRESS[5] = 'T';
	MOVLW       84
	MOVWF       _dst_ADDRESS+5 
;node1.c,207 :: 		dst_ADDRESS[6] = 'W';
	MOVLW       87
	MOVWF       _dst_ADDRESS+6 
;node1.c,208 :: 		dst_ADDRESS[7] = 'O';
	MOVLW       79
	MOVWF       _dst_ADDRESS+7 
;node1.c,211 :: 		MRF_HW_Config();
	CALL        _MRF_HW_Config+0, 0
;node1.c,215 :: 		if (!MRF_Init(this_PANID)) {
	MOVLW       _this_PANID+0
	MOVWF       FARG_MRF_Init_PANID+0 
	MOVLW       hi_addr(_this_PANID+0)
	MOVWF       FARG_MRF_Init_PANID+1 
	CALL        _MRF_Init+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main12
;node1.c,216 :: 		goto MRF_Module_NotInitialized;
	GOTO        ___main_MRF_Module_NotInitialized
;node1.c,217 :: 		}
L_main12:
;node1.c,219 :: 		_RXHWIF = 0;
	BCF         INT2IF_bit+0, 1 
;node1.c,220 :: 		_RXHWIE = 0;
	BCF         INT2IE_bit+0, 4 
;node1.c,221 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;node1.c,222 :: 		INTCON.GIE  = 1;
	BSF         INTCON+0, 7 
;node1.c,225 :: 		do {
L_main13:
;node1.c,227 :: 		if (MRF_PacketReceived()){
	CALL        _MRF_PacketReceived+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;node1.c,228 :: 		MRF_Tasks();
	CALL        _MRF_Tasks+0, 0
;node1.c,229 :: 		}
L_main16:
;node1.c,231 :: 		if (USB_TX_HASDATA) {
	BTFSS       _Gflags+0, 1 
	GOTO        L_main17
;node1.c,232 :: 		HID_Write(userWR_buffer,17);
	MOVLW       _userWR_buffer+0
	MOVWF       FARG_HID_Write_writebuff+0 
	MOVLW       hi_addr(_userWR_buffer+0)
	MOVWF       FARG_HID_Write_writebuff+1 
	MOVLW       17
	MOVWF       FARG_HID_Write_len+0 
	CALL        _HID_Write+0, 0
;node1.c,233 :: 		USB_TX_HASDATA = 0;
	BCF         _Gflags+0, 1 
;node1.c,234 :: 		}
L_main17:
;node1.c,236 :: 		USB_Tasks();
	CALL        _USB_Tasks+0, 0
;node1.c,238 :: 		if (USB_RX_HASDATA){
	BTFSS       _Gflags+0, 0 
	GOTO        L_main18
;node1.c,239 :: 		INTCON.B7 = 0;
	BCF         INTCON+0, 7 
;node1.c,240 :: 		USB_RX_HASDATA = 0;
	BCF         _Gflags+0, 0 
;node1.c,241 :: 		P2PSTATUS      = 0;
	CLRF        _P2PSTATUS+0 
	CLRF        _P2PSTATUS+1 
;node1.c,242 :: 		MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
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
;node1.c,243 :: 		FlushTx;
	CLRF        _DataLenght+0 
;node1.c,244 :: 		INTCON.B7 = 1;
	BSF         INTCON+0, 7 
;node1.c,245 :: 		}
L_main18:
;node1.c,247 :: 		} while (1);
	GOTO        L_main13
;node1.c,248 :: 		MRF_Module_NotInitialized:
___main_MRF_Module_NotInitialized:
;node1.c,249 :: 		HID_Disable();
	CALL        _HID_Disable+0, 0
;node1.c,250 :: 		}//
L_end_main:
	GOTO        $+0
; end of _main
