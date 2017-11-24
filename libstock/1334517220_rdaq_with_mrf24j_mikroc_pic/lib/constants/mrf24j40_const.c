
//module  MRF_24J40_Const

/*'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'*
'* Project name:
'    MRF24J40MA module constant's
'* Copyright:
'    (c) Marcio Nassorri 06/2/2009
'* Revision History:
'    V-1.0.0.0
'
'* Description:
'              Global constants defined up to now
'              is for use with module lib for
'              MRF24J40MA and its purpose use
'              in this program.
'              many others can be added to this.
'  Warning:
'              the RX_BUFFER and TX_BUFFER array
'              have every time yours index set to
'              _TXBufLen and _RXBufLen constants
'              we can resise it changing the literals value
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/



const unsigned  char _CCA_THreshold                              = 0x0E;
const unsigned  char _CARRIER_SENSE_ONLY                         = 0x40 | _CCA_Threshold;
const unsigned  char _ENERGY_ABOVE_THRESHOLD                     = 0x80 | _CCA_THreshold;
const unsigned  char _CARRIER_SENSE_WITH_ENERGY_ABOVE_THRESHOLD  = 0xC0 | _CCA_Threshold;
const unsigned  char _RSSI_1_Bit_Mode                            = 0x80;
const unsigned  char _RSSI_RX_PACKET                             = 0x40;
const unsigned  char _RSSI_READY                                 = 0x01;



const unsigned  char _RF_PLLENABLED                             = 0x80;
const unsigned  char _RF_PLLDISABLED                            = 0x00;
const unsigned  char _RF_BATMONENABLED                          = 0x08;
const unsigned  char _RF_TX_FILTER                              = 0x80;
const unsigned  char _RF_VCO_ENABLED                            = 0x10;


//'mode addressing in P2P mode
const unsigned  char _lngSource_ShortDest                       = 0xC8;
const unsigned  char _lngSource_lngDest                         = 0xCC;
const unsigned  char _Shortdest_Shortsource                     = 0x88;
const unsigned  char _DestNone_ShortSource                      = 0x80;
const unsigned  char _ShortDest_SourceNone                      = 0x08;
const unsigned  char _lngDest_ShortSource                       = 0x8C;


//'MRF24J40 Register's Low RAM
const unsigned  char   _RXMCR     = 0x00;
const unsigned  char   _PANIDL    = 0x01;
const unsigned  char   _PANIDH    = 0x02;
const unsigned  char   _SADRL     = 0x03;
const unsigned  char   _SADRH     = 0x04;
const unsigned  char   _EADR0     = 0x05;
const unsigned  char   _EADR1     = 0x06;
const unsigned  char   _EADR2     = 0x07;
const unsigned  char   _EADR3     = 0x08;
const unsigned  char   _EADR4     = 0x09;
const unsigned  char   _EADR5     = 0x0A;
const unsigned  char   _EADR6     = 0x0B;
const unsigned  char   _EADR7     = 0x0C;
const unsigned  char   _RXFLUSH   = 0x0D;
const unsigned  char   _TXNMTRIG  = 0x1B;
const unsigned  char   _TXSR      = 0x24;
const unsigned  char   _ISRSTS    = 0x31;
const unsigned  char   _INTMSK    = 0x32;
const unsigned  char   _GPIO      = 0x33;
const unsigned  char   _TRISGPIO  = 0x34;
const unsigned  char   _RFCTL     = 0x36;
const unsigned  char   _BBREG2    = 0x3A;
const unsigned  char   _BBREG6    = 0x3E;
const unsigned  char   _RSSITHCCA = 0x3F;


//'Hi RAM Registers              ;
const unsigned  int     _RFCTRL0   = 0x200;
const unsigned  int     _RFCTRL2   = 0x202;
const unsigned  int     _RFCTRL3   = 0x203;
const unsigned  int     _RFCTRL6   = 0x206;
const unsigned  int     _RFCTRL7   = 0x207;
const unsigned  int     _RFCTRL8   = 0x208;
const unsigned  int     _CLKINTCR  = 0x211;
const unsigned  int     _CLKCTRL   = 0x220;

//'Base address for buffer of MRF24J40MA
const unsigned char    _TXDATABASEADDR    = 0x00;
const unsigned char    _TXBEACONBASEADDR  = 0x80;
const unsigned char    _TXGTS_1BASEADDR   = 0x100;
const unsigned char    _TXGTS_2BASEADDR   = 0x180;
const unsigned char    _RXBUFBASEADDR     = 0x300;

//'some commands for module
const unsigned char _CMD_P2P_CONNECTION_REQUEST             = 0x81;
const unsigned char _CMD_P2P_CONNECTION_REMOVAL_REQUEST     = 0x82;
const unsigned char _CMD_DATA_REQUEST                       = 0x83;
const unsigned char _CMD_CHANNEL_HOPPING                    = 0x84;
const unsigned char _CMD_TIME_SYNCHRONIZATION_REQUEST       = 0x85;
const unsigned char _CMD_TIME_SYNCHRONIZATION_NOTIFICATION  = 0x86;

const unsigned char _CMD_P2P_CONNECTION_RESPONSE            = 0x91;
const unsigned char _CMD_P2P_CONNECTION_REMOVAL_RESPONSE    = 0x92;
const unsigned char _CMD_MAC_DATA_REQUEST                   = 0x04;


//*