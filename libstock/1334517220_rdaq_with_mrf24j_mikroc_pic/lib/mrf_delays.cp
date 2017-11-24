#line 1 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/lib/mrf_delays.c"
#line 6 "C:/Users/Nassorri/toshiba/PIC_MCU/mC_PRO/Programs/P18/RDAQ_560/lib/mrf_delays.c"
void mrf_delay2ms();
void mrf_delay400us();
void mrf_delay10us();

void mrf_delay400us(){
 delay_us(400);
}
void mrf_delay2ms(){
 delay_ms(2);
}

void mrf_delay10us(){
 delay_us(10);
}
