/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xil_io.h"
#include "audio.h"
#include "oled.h"

/* INCLUDE_TIMER : definitely need timer, just don't want to mess up timer stuffs with rest of code */
#define INCLUDE_TIMER 1
/* MEASURE_TIME : set to 1 to measure the latency, default = 0 */
#define MEASURE_TIME 1

//void print(char *str);
#if (INCLUDE_TIMER == 1)

#include "xtime_l.h"
#include "xil_io.h"
#include "xparameters.h"

#define timer_base 0xF8F00000
/***********************************************************
Timer Registers
************************************************************/
static volatile int *timer_counter_l=(volatile int *)(timer_base+0x200);
static volatile int *timer_counter_h=(volatile int *)(timer_base+0x204);
static volatile int *timer_ctrl=(volatile int *)(timer_base+0x208);
/***********************************************************
Function definitions
************************************************************/
void init_timer(volatile int *timer_ctrl, volatile int *timer_counter_l, volatile int *timer_counter_h){
        *timer_ctrl=0x0;
        *timer_counter_l=0x1;
        *timer_counter_h=0x0;
        DATA_SYNC;
}

void start_timer(volatile int *timer_ctrl){
        *timer_ctrl=*timer_ctrl | 0x00000001;
        DATA_SYNC;
}

void stop_timer(volatile int *timer_ctrl){
        *timer_ctrl=*timer_ctrl & 0xFFFFFFFE;
        DATA_SYNC;
}
#endif /* INCLUDE_TIMER */

int main()
{
    //init_platform();
	u32 i;
	u32 ret[128];

	Xint16 audio_data[128];
	u8 *oled_equalizer_buf=(u8 *)malloc(128*sizeof(u8));//WARNING bro...: -Wimplicit-function-declaration

	/* -------- LED and HW related -------- */
	Xil_Out32(OLED_BASE_ADDR,0xff);
	OLED_Init();			//oled init
	IicConfig(XPAR_XIICPS_0_DEVICE_ID);
	AudioPllConfig(); //enable core clock for ADAU1761
	AudioConfigure();

	xil_printf("ADAU1761 configured\n\r");
while(1) {
	//DEBUG: xil_printf("*");

    // capture audio data
    get_audio(audio_data);

#if (MEASURE_TIME==1)
    // Your total latency (FFT + Magnitude + Noise cancellation + Averaging + to & fro  PS-PL communication) ...
    // should be less than 103us.
	init_timer(timer_ctrl, timer_counter_l, timer_counter_h);
	start_timer(timer_ctrl);
#endif

    for(i=0;i<128;i++)
    {
    	Xil_Out32(XPAR_AXI4BURST_PS2PL_0_S_AXI_MEM0_BASEADDR, audio_data[i]);
    	//DEBUG: xil_printf("sent data %0x\n\r", audio_data[i]);
    }

    //TODO: find more elegant way, checking some "completed status" signal maybe...
    usleep(10);// less than 10usec doesn't work

    for(i=0;i<128;i++)
    {
    	ret[i] = Xil_In32(XPAR_AXI4BURST_PS2PL_0_S_AXI_MEM0_BASEADDR);

    	//TODO: put these post-process in FPGA
    	oled_equalizer_buf[i] = (u8)(ret[i] >> 4);
    	//DEBUG: xil_printf("oled[%d]=%d\n\r", i, oled_equalizer_buf[i]);

    	if (oled_equalizer_buf[i] >= 40) {
    		oled_equalizer_buf[i] = 40;
    	}
    }

#if (MEASURE_TIME==1)
	stop_timer(timer_ctrl);
	//Calculate the time for the operation
	xil_printf("Communication time %d us\n\r", (*timer_counter_l) / 333);
#endif

    OLED_Clear();
    OLED_Equalizer_128(oled_equalizer_buf);
}
    return 0;
}
