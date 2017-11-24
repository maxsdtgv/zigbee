#line 1 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node1/node1.c"
#line 15 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node1/node1.c"
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
#line 48 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node1/node1.c"
const unsigned char _P2P_CAPACITYINFO = 0x01;
const unsigned char _P2P_CONNECTION_SIZE = 0x02;




static const no = 0;
static const yes = 255;


sbit MRF_RX_RF_INT_DIRECTION at TRISB.B2;
sbit MRF_CSDIRECTION at TRISB.B3;
sbit MRF_WAKEDIRECTION at TRISB.B4;
sbit MRF_RSTDIRECTION at TRISB.B5;


sbit MRF_RX_RF_INT at PORTB.B2;
sbit MRF_CS at LATB.B3;
sbit MRF_WAKE at LATB.B4;
sbit MRF_RST at LATB.B5;

sbit _RXHWIF at INT2IF_bit;
sbit _RXHWIE at INT2IE_bit;

unsigned char Src_Seq_Number at TMR0L;



unsigned char this_PANID[_PANID_Len];
unsigned char this_MAC[_MAC_Len];
unsigned char dst_ADDRESS[_ADDDR_Len];


unsigned char RX_BUFFER[_RXBufLen];
unsigned char TX_BUFFER[_TXBufLen];
unsigned char Headerlenght;
unsigned char DataLenght;
unsigned int P2PSTATUS;

unsigned char userRD_buffer[64] absolute 0x500;
unsigned char userWR_buffer[64] absolute 0x540;

unsigned char Gflags;
sbit USB_RX_HASDATA at Gflags.B0;
sbit USB_TX_HASDATA at Gflags.B1;
sbit RX_Tasks at Gflags.B2;


unsigned char H, J, K;


void sendCommand(){
 P2PSTATUS = 0;
 MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_COMMAND,no);
}


void interrupt() iv 0x0008{
 USB_Interrupt_Proc();
}

void USB_Tasks(){
unsigned char H;
 K = HID_Read();
 if (K > 9) {
 if (userRD_buffer[0] == 0){return;}
  DataLenght = 0 ;
 for (H = 0;H<10;H++){
 MRF_FillData(userRD_buffer[H]);
 }
 USB_RX_HASDATA = 1;
 }
}


void MRF_Tasks(){
 K = MRF_get_pktDC();
 if ((K && 0x80) == 0x80) {
 K = (K & 0x7F);
 for (J = 0;K<10;K++){
 userWR_buffer[j] = RX_BUFFER[j];
 USB_TX_HASDATA = 1;
 }
 MRF_DiscardPacket();
 }else{
 MRF_DiscardPacket();
 }
}

void main(void) {

PORTA = 0;
PORTB = 0;
PORTC = 0;
TRISA = 0x3F;
TRISB = 0b00000100;
#line 154 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/node1/node1.c"
TRISC = 0b10010000;
LATA = 0;
LATB = 0;
LATC = 0;

T0CON = 0x80;
INTCON = 0b00000000;
INTCON2 = 0b00000000;
INTCON3 = 0x00;
IPR1 = 0x00;
IPR2 = 0x00;
RCON.IPEN = 0;
PIE1 = 0;
PIE2 = 0;
PIR1 = 0;
PIR2 = 0;
ADCON1 = 0x0f;

 DataLenght = 0 ;
UPUEN_bit = 0;

Gflags = 0;
H = 0;
J = 0;
K = 0;
P2PSTATUS = 0;
Headerlenght = 0;
_RXHWIE = 0;

HID_Enable(userRD_buffer, userWR_buffer);


this_PANID[0] = 0x12;
this_PANID[1] = 0x34;



this_MAC[0] = 'N';
this_MAC[1] = 'O';
this_MAC[2] = 'D';
this_MAC[3] = 'E';
this_MAC[4] = ' ';
this_MAC[5] = 'O';
this_MAC[6] = 'N';
this_MAC[7] = 'E';


dst_ADDRESS[0] = 'N';
dst_ADDRESS[1] = 'O';
dst_ADDRESS[2] = 'D';
dst_ADDRESs[3] = 'E';
dst_ADDRESS[4] = ' ';
dst_ADDRESS[5] = 'T';
dst_ADDRESS[6] = 'W';
dst_ADDRESS[7] = 'O';


MRF_HW_Config();



if (!MRF_Init(this_PANID)) {
 goto MRF_Module_NotInitialized;
}

_RXHWIF = 0;
_RXHWIE = 0;
INTCON.PEIE = 1;
INTCON.GIE = 1;


do {

if (MRF_PacketReceived()){
 MRF_Tasks();
 }

 if (USB_TX_HASDATA) {
 HID_Write(userWR_buffer,17);
 USB_TX_HASDATA = 0;
 }

 USB_Tasks();

 if (USB_RX_HASDATA){
 INTCON.B7 = 0;
 USB_RX_HASDATA = 0;
 P2PSTATUS = 0;
 MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
  DataLenght = 0 ;
 INTCON.B7 = 1;
 }

} while (1);
MRF_Module_NotInitialized:
HID_Disable();
}
