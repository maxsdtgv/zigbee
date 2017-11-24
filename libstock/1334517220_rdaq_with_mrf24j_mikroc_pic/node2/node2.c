/*program node2
' *
' * Project name:
'     MRF24J40MA Small code.
' * Copyright:
'     (c) MAN, 21/08/2009>
' * Status:
'     <100% completed.>
' * Description:
'     This code send severous data between MRF24J40MA
'     performing a small R-DAQ and using the USB
'     to interfacing the PIC with PC.
'
' * Test configuration:
'     MCU:             PIC18F2550
'     Dev.Board:       custon
'     Oscillator:      20Mhz
'     Ext. Modules:    __lib_MRF24J40
'                      MRF24J40_const
'                      __module_Tasks
'                      mrf_Delays
'
'     SW:              mC PRO 5.60
' * NOTES:
'     This code can be compiled to other PIC MCU's with
'     minor modiffications.
'*/


#define  FlushTx    DataLenght = 0;

const yes = 255;
const no  = 0;


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


//configures TRIS bit`s direction.
sbit MRF_RX_RF_INT_DIRECTION  at TRISB.B2;
sbit MRF_CSDIRECTION          at TRISB.B3;
sbit MRF_WAKEDIRECTION        at TRISB.B4;
sbit MRF_RSTDIRECTION         at TRISB.B5;

//configures PORT bit's settings
sbit MRF_RX_RF_INT            at PORTB.B2;
sbit MRF_CS                   at LATB.B3;
sbit MRF_WAKE                 at LATB.B4;
sbit MRF_RST                  at LATB.B5;

unsigned char Src_Seq_Number  at TMR0L;


sbit _RXHWIF                  at INT2IF_bit;
sbit _RXHWIE                  at INT2IE_bit;


//configures array var's
unsigned char    this_MAC[_MAC_Len];
unsigned char    this_PANID[_PANID_Len];

unsigned char    dst_ADDRESS[_MAC_Len];

unsigned char RX_BUFFER[_TXBufLen];
unsigned char TX_BUFFER[_RXBufLen];


unsigned char Headerlenght = 0;
unsigned char DataLenght = 0;
unsigned int  P2PSTATUS = 0;


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
PORTA     = 0x00;         // Clear PortA
PORTB     = 0x00;         // Clear PortB
PORTC     = 0x00;         // Clear PortC
TRISA     = 0b00101111;    // PortA direction set
TRISB     = 0b00000101;    // PortB direction set
//              ||||||___   SDI
//              |||||____   SCL
//              ||||_____   INT
//              |||______   HW_CS
//              ||_______   HW_WAKE
//              |________   HW_RST
//                     ;
TRISC     = 0x00;         // PortC all output
LATA      = 0x00;         // Clear LATA
LATB      = 0x00;         // Clear LATB
LATC      = 0x00;         // Clear LATC

INTCON    = 0b00000000;    // disable all interrupts
INTCON2   = 0b00000000;    // Set RBPU to 0 and make INTEDG2 on falling edge
INTCON3   = 0x00;         // Hi priority interrupt//s disabled
IPR1      = 0x00;         // All priority's REG1 is Low
IPR2      = 0x00;         // All priority's REG2 is Low
RCON.IPEN = 0x00;         // Disable Priority Levels
PIE1      = 0x00;         // All others interrupt on PIE1 disabled
PIE2      = 0x00;         // all others interrupt on PIE2 disabled
PIR1      = 0x00;         // All flags on PIR1 cleared
PIR2      = 0x00;         // All flags on PIR2 cleared
ADCON1    = 0x0A;         // All ports as A/D In.
CMCON     = 0x07;         // Comparators off

FlushTx;                  // Clear TX ctrl buffer

Timer1H =    0x02;
Timer1L =    0x18;  //13ms


T0CON = 0x80; //start TMR0
T1CON = 0x00;
TMR1L = Timer1L;
TMR1H = Timer1H;
TX_Locked = 0;
counter   = 0;


T1CON = T1CON & 0xCF; //%11001111 1:1
//T1CON = T1CON or  0x30 //%00110000 1:8

//default values on initialization
TX_BUFFER[10] = timer1h;      //idx 11 pc
TX_BUFFER[11] = timer1l;      //idx 12 pc
TX_BUFFER[12] = 0b00000000;   //idx 13 pc
TX_BUFFER[13] = 0x7F;         //idx 14 pc
TX_BUFFER[14] = 0x00;         //idx 15 pc
TX_BUFFER[15] = 0b11001101;   //idx 16 pc
TX_BUFFER[16] = 0x31;         //idx 17 pc





ad_Ready = 0;
RX_Tasks = 0;

//initialize PWM to 5Khz
PWM1_Init(5000);
PWM1_Set_Duty(1);

//This is the first call for to configure the MRF module.
MRF_HW_Config();


//Set the local PANID.
//for bradcasting use 0xFFFF.
this_PANID[0]    = 0x12;
this_PANID[1]    = 0x34;

//Set's array to the Long MAC for test
//near
this_MAC[0]    = 'N';
this_MAC[1]    = 'O';
this_MAC[2]    = 'D';
this_MAC[3]    = 'E';
this_MAC[4]    = ' ';
this_MAC[5]    = 'T';
this_MAC[6]    = 'W';
this_MAC[7]    = 'O';

//far end.
dst_ADDRESS[0] = 'N';
dst_ADDRESS[1] = 'O' ;
dst_ADDRESS[2] = 'D';
dst_ADDRESs[3] = 'E';
dst_ADDRESS[4] = ' ';
dst_ADDRESS[5] = 'O';
dst_ADDRESS[6] = 'N';
dst_ADDRESS[7] = 'E';


//Initializes Module and return
//false if module was not initialized
if (!MRF_Init(this_PANID)){
   goto MRF_Module_notInitialized;
}

TMR0ON_bit = 0;    //stop tmr0
T0CON      = 0x28; //reconfigures TMR0 as couter
TMR0L      = 0x00;
TMR0H      = 0x00;

_RXHWIF = 0;
//_RXHWIE = 1

TMR1IF_bit  = 0;
TMR1IE_bit  = 1;
INTCON.PEIE = 1;
INTCON.GIE  = 1;
//
TMR1ON_bit  = 1;

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
           FlushTx;
           ad_Ready = 0;
           INTCON.GIE = 1;
      }
      //+++++++++++++++++++++++++++++++++++++
      // this is for performing data sending
      // when the sample is off
      if (TMR1ON_bit == 0){
         counter++;
         if (counter == 1000){
            counter = 0;
            DataLenght = 17;
            P2PSTATUS  = 0;
            MRF_SendDataPkt(this_PANID,dst_ADDRESS,no,_SEND_AS_DATA,no);
         }
      }
      //refresh GPIO//s status
      TX_BUFFER[14].B0 = RC0_bit;
      TX_BUFFER[14].B1 = RC1_bit;
      TX_BUFFER[14].B2 = RC6_bit;
      TX_BUFFER[14].B3 = RB6_bit;
      TX_BUFFER[14].B4 = RB7_bit;
}while(1);
MRF_Module_NotInitialized:
//if for some raeson the module don//t
//initializes the GPIO's will flash
do {
      LATC0_bit = ~LATC0_bit;
      LATC1_bit = ~LATC1_bit;
      LATC6_bit = ~LATC6_bit;
      LATB6_bit = ~LATB6_bit;
      LATB7_bit = ~LATB7_bit;
      delay_ms(500);
}while(1);
}//