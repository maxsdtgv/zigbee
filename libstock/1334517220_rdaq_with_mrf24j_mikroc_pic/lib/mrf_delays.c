/*module mrfdelays
'******************************************
'  do not change these delays.
'*******************************************/

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