#line 1 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node2/node2.c"
#line 32 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node2/node2.c"
const yes = 255;
const no = 0;





const unsigned char _TXBufLen = 70;
const unsigned char _RXBufLen = 70;






const unsigned char _MAC_Len = 8;
const unsigned char _ADDDR_Len = _MAC_Len;
const unsigned char _PANID_Len = 2;
const unsigned char _SADDR_Len = _PANID_Len;


const unsigned char _SEND_AS_COMMAND = 0x03;
const unsigned char _SEND_AS_DATA = 0x01;
const unsigned char _RX_IS_COMMAND = _SEND_AS_COMMAND;
const unsigned char _RX_IS_DATA = _SEND_AS_DATA;
#line 72 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node2/node2.c"
const unsigned char _P2P_CAPACITYINFO = 0x01;
const unsigned char _P2P_CONNECTION_SIZE = 0x02;




sbit MRF_RX_RF_INT_DIRECTION at TRISB.B2;
sbit MRF_CSDIRECTION at TRISB.B3;
sbit MRF_WAKEDIRECTION at TRISB.B4;
sbit MRF_RSTDIRECTION at TRISB.B5;


sbit MRF_RX_RF_INT at PORTB.B2;
sbit MRF_CS at LATB.B3;
sbit MRF_WAKE at LATB.B4;
sbit MRF_RST at LATB.B5;

unsigned char Src_Seq_Number at TMR0L;


sbit _RXHWIF at INT2IF_bit;
sbit _RXHWIE at INT2IE_bit;



unsigned char this_MAC[_MAC_Len];
unsigned char this_PANID[_PANID_Len];

unsigned char dst_ADDRESS[_MAC_Len];

unsigned char RX_BUFFER[_TXBufLen];
unsigned char TX_BUFFER[_RXBufLen];


unsigned char Headerlenght = 0;
unsigned char DataLenght = 0;
unsigned int P2PSTATUS = 0;


bit USB_RX_HAVEDATA;
bit USB_TX_HAVEDATA;
bit RX_Tasks ;
bit TX_Locked;
bit ad_Ready;

unsigned int counter;

unsigned char Timer1L;
unsigned char Timer1H;

void interrupt() {
 RDAQ_Int_Proc();
}

void main(){
PORTA = 0x00;
PORTB = 0x00;
PORTC = 0x00;
TRISA = 0b00101111;
TRISB = 0b00000101;







TRISC = 0x00;
LATA = 0x00;
LATB = 0x00;
LATC = 0x00;

INTCON = 0b00000000;
INTCON2 = 0b00000000;
INTCON3 = 0x00;
IPR1 = 0x00;
IPR2 = 0x00;
RCON.IPEN = 0x00;
PIE1 = 0x00;
PIE2 = 0x00;
PIR1 = 0x00;
PIR2 = 0x00;
ADCON1 = 0x0A;
CMCON = 0x07;

 DataLenght = 0; ;

Timer1H = 0x02;
Timer1L = 0x18;


T0CON = 0x80;
T1CON = 0x00;
TMR1L = Timer1L;
TMR1H = Timer1H;
TX_Locked = 0;
counter = 0;


T1CON = T1CON & 0xCF;



TX_BUFFER[10] = timer1h;
TX_BUFFER[11] = timer1l;
TX_BUFFER[12] = 0b00000000;
TX_BUFFER[13] = 0x7F;
TX_BUFFER[14] = 0x00;
TX_BUFFER[15] = 0b11001101;
TX_BUFFER[16] = 0x31;





ad_Ready = 0;
RX_Tasks = 0;


PWM1_Init(5000);
PWM1_Set_Duty(1);


MRF_HW_Config();




this_PANID[0] = 0x12;
this_PANID[1] = 0x34;



this_MAC[0] = 'N';
this_MAC[1] = 'O';
this_MAC[2] = 'D';
this_MAC[3] = 'E';
this_MAC[4] = ' ';
this_MAC[5] = 'T';
this_MAC[6] = 'W';
this_MAC[7] = 'O';


dst_ADDRESS[0] = 'N';
dst_ADDRESS[1] = 'O' ;
dst_ADDRESS[2] = 'D';
dst_ADDRESs[3] = 'E';
dst_ADDRESS[4] = ' ';
dst_ADDRESS[5] = 'O';
dst_ADDRESS[6] = 'N';
dst_ADDRESS[7] = 'E';




if (!MRF_Init(this_PANID)){
 goto MRF_Module_notInitialized;
}

TMR0ON_bit = 0;
T0CON = 0x28;
TMR0L = 0x00;
TMR0H = 0x00;

_RXHWIF = 0;


TMR1IF_bit = 0;
TMR1IE_bit = 1;
INTCON.PEIE = 1;
INTCON.GIE = 1;

TMR1ON_bit = 1;

do {
 if (MRF_PacketReceived()){
 INTCON.GIE = 0;
 RDAQ_Tasks();
 INTCON.GIE = 1;
 }
 if (ad_Ready){
 INTCON.GIE = 0;
 DataLenght = 17;
 P2PSTATUS = 0;
 MRF_SendDataPkt(this_PANID, dst_ADDRESS,no,_SEND_AS_DATA,no);
  DataLenght = 0; ;
 ad_Ready = 0;
 INTCON.GIE = 1;
 }



 if (TMR1ON_bit == 0){
 counter++;
 if (counter == 1000){
 counter = 0;
 DataLenght = 17;
 P2PSTATUS = 0;
 MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
 }
 }

 TX_BUFFER[14].B0 = RC0_bit;
 TX_BUFFER[14].B1 = RC1_bit;
 TX_BUFFER[14].B2 = RC6_bit;
 TX_BUFFER[14].B3 = RB6_bit;
 TX_BUFFER[14].B4 = RB7_bit;
}while(1);
MRF_Module_NotInitialized:


do {
 LATC0_bit = ~LATC0_bit;
 LATC1_bit = ~LATC1_bit;
 LATC6_bit = ~LATC6_bit;
 LATB6_bit = ~LATB6_bit;
 LATB7_bit = ~LATB7_bit;
 delay_ms(500);
}while(1);
}
