//program node1

/*'+++++++++++++++++++++++++++++++++++++++
'   Compiled with mC PRO 5.60
'   14/04/2012
'
'
'+++++++++++++++++++++++++++++++++++++++*/

#define FlushTx  DataLenght = 0

//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//' Adjust Tx and Rx buffer lenght to a determined application.                      +
//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
const unsigned char _TXBufLen                              = 70; //'15 min   127 max
const unsigned char _RXBufLen                              = 70; //'15 min   127 max

//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//' these values don't need to be changed                                    +
//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
const unsigned     char _MAC_Len                               = 8;
const unsigned     char _ADDDR_Len                             = _MAC_Len;
const unsigned     char _PANID_Len                             = 2;
const unsigned     char _SADDR_Len                             = _PANID_Len;
//'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

const unsigned    char _SEND_AS_COMMAND                        = 0x03;
const unsigned    char _SEND_AS_DATA                           = 0x01;
const unsigned    char _RX_IS_COMMAND                          = _SEND_AS_COMMAND;
const unsigned    char _RX_IS_DATA                             = _SEND_AS_DATA;

//'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//' CapacityInfo Byte have the folowing Struct
//'___________________________________________
//'   7 6 5 4 3 2 1 0  Bit's
//'   0 0 0 0 0 0 0 0
//'   | | | | | | | |_ RX_On_When_Idle
//'   | | | | | | |___ DataRequest_Needed
//'   | | | | | |_____ TimeSync_Required
//'   | | | | |_______ Security_Enabled
//'   | | | |_________ --|
//'   | | |___________   |
//'   | |_____________   |____Reserved
//'   |_______________   |
//'                    --|
const unsigned char _P2P_CAPACITYINFO                       = 0x01; //'00000010
const unsigned char _P2P_CONNECTION_SIZE                    = 0x02;
//'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



static const no      = 0;
static const yes     = 255;

//'configures TRIS bit`s direction.
sbit MRF_RX_RF_INT_DIRECTION at TRISB.B2;
sbit MRF_CSDIRECTION         at TRISB.B3;
sbit MRF_WAKEDIRECTION       at TRISB.B4;
sbit MRF_RSTDIRECTION        at TRISB.B5;

//'configures PORT bit's
sbit MRF_RX_RF_INT           at PORTB.B2;
sbit MRF_CS                  at LATB.B3;
sbit MRF_WAKE                at LATB.B4;
sbit MRF_RST                 at LATB.B5;

sbit _RXHWIF                 at INT2IF_bit;  //INTCON3.INT2IF;
sbit _RXHWIE                 at INT2IE_bit;  //INTCON3.INT2IE;

unsigned char Src_Seq_Number at TMR0L;


//'configures array var's
unsigned char   this_PANID[_PANID_Len];  //'2
unsigned char   this_MAC[_MAC_Len];      //'8
unsigned char   dst_ADDRESS[_ADDDR_Len]; //'8


unsigned char RX_BUFFER[_RXBufLen];
unsigned char TX_BUFFER[_TXBufLen];
unsigned char Headerlenght;
unsigned char DataLenght;
unsigned int  P2PSTATUS;

unsigned char userRD_buffer[64] absolute 0x500;
unsigned char userWR_buffer[64] absolute 0x540;

unsigned char Gflags;
sbit USB_RX_HASDATA         at Gflags.B0;
sbit USB_TX_HASDATA         at Gflags.B1;
sbit RX_Tasks               at Gflags.B2;


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
     FlushTx;
     for (H = 0;H<10;H++){
         MRF_FillData(userRD_buffer[H]);
     }
     USB_RX_HASDATA = 1;
  }
}


void MRF_Tasks(){
    K = MRF_get_pktDC();
    if ((K && 0x80) == 0x80) {  //'is data
       K = (K & 0x7F);  //'get the lenght of packet
       for (J = 0;K<10;K++){
           userWR_buffer[j] = RX_BUFFER[j];
           USB_TX_HASDATA  = 1;
       }
       MRF_DiscardPacket();
    }else{                         //'is command
       MRF_DiscardPacket();
    }
}

void main(void) {

PORTA     = 0;            //' Clear PortA
PORTB     = 0;            //' Clear PortB
PORTC     = 0;            //' Clear PortC
TRISA     = 0x3F;         //' PortA all AD input
TRISB     = 0b00000100;
/*'           ||||||||___ 'SDI
'             |||||||____ 'SCL
'             ||||||_____ 'INT
'             |||||______ 'CS
'             ||||_______ 'RST
'             |||________ 'WAKE
'             ||_________ 'not used
'             |__________ 'not used*/


TRISC     = 0b10010000;    //' PortC.7 SDO, 4,5 USB, all others output
LATA      = 0;            //' Clear LATA
LATB      = 0;            //' Clear LATB
LATC      = 0;            //' Clear LATC

T0CON     = 0x80;         //' enable tmr0
INTCON    = 0b00000000;    //' disable all interrupts
INTCON2   = 0b00000000;    //' disable RBPU and make INTEDG2 on falling edge
INTCON3   = 0x00;         //' Hi priority interrupt's disabled
IPR1      = 0x00;         //' All priority's REG1 is Low
IPR2      = 0x00;         //' All priority's REG2 is Low
RCON.IPEN = 0;            //' Disable Priority Levels
PIE1      = 0;            //' All others interrupt on PIE1 disabled
PIE2      = 0;            //' all others interrupt on PIE2 disabled
PIR1      = 0;            //' All flags on PIR1 cleared
PIR2      = 0;            //' All flags on PIR2 cleared
ADCON1    = 0x0f;         //' AD0-AD4 selected

FlushTx;                  //' Clear TX buffer
UPUEN_bit = 0;

Gflags            = 0;
H                 = 0;
J                 = 0;
K                 = 0;
P2PSTATUS         = 0;
Headerlenght      = 0;
_RXHWIE           = 0;

HID_Enable(userRD_buffer, userWR_buffer);

//'Set's the Short MAC to Broadcast as 0xFFFF
this_PANID[0]    = 0x12; //'0xFF
this_PANID[1]    = 0x34; //'0xFF

//'Set's array to the Long MAC for test
//'near
this_MAC[0]    = 'N';
this_MAC[1]    = 'O';
this_MAC[2]    = 'D';
this_MAC[3]    = 'E';
this_MAC[4]    = ' ';
this_MAC[5]    = 'O';
this_MAC[6]    = 'N';
this_MAC[7]    = 'E';

//'far end
dst_ADDRESS[0] = 'N';
dst_ADDRESS[1] = 'O';
dst_ADDRESS[2] = 'D';
dst_ADDRESs[3] = 'E';
dst_ADDRESS[4] = ' ';
dst_ADDRESS[5] = 'T';
dst_ADDRESS[6] = 'W';
dst_ADDRESS[7] = 'O';

//'This is the first call for to configure the MRF module.
MRF_HW_Config();

//'initializes the module. if we get bad initialization
//'the func. will return false.
if (!MRF_Init(this_PANID)) {
   goto MRF_Module_NotInitialized;
}

_RXHWIF = 0;
_RXHWIE = 0;
INTCON.PEIE = 1;
INTCON.GIE  = 1;


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
       P2PSTATUS      = 0;
       MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
       FlushTx;
       INTCON.B7 = 1;
    }

} while (1);
MRF_Module_NotInitialized:
HID_Disable();
}//