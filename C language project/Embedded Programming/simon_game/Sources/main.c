/* ###################################################################
**     Filename    : main.c
**     Project     : myproject
**     Processor   : MKL25Z128VLK4
**     Version     : Driver 01.01
**     Compiler    : GNU C Compiler
**     Date/Time   : 2022-12-06, 19:13, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.01
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */


/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "RED_LED.h"
#include "TU1.h"
#include "GREEN_LED.h"
#include "BLUE_LED.h"
#include "TU2.h"
#include "TSS1.h"
/* Including shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include <stdlib.h>
#include <time.h>

/* User includes (#include below this line is not maintained by Processor Expert) */

int ispressed=0;
static int y;				//This function is for the software timer in the program
void wait(wait_ms) {
	unsigned int i,j;
	for(i=0;i<wait_ms;i++){
		for(j=0;j<785;j++) {
				__asm("nop");
			}

		}
	}

int total_level=51;
int colour_sequence[50];
int level;
int user_input[50];
int colour;
int x;

/*lint -save  -e970 Disable MISRA rule (6.3) checking. */
int main(void)
/*lint -restore Enable MISRA rule (6.3) checking. */
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
	PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/
	TSS1_Configure();
  /* Write your code here */
  /* For example: for(;;) { } */
	for(;;)
	{

		int x;
		above:
		ispressed = 0;
		while(ispressed<2){
		TSS_Task();
		}
		if (TSS1_cKey0.Position > 0)
		{
		srand ((unsigned) TSS1_cKey0.Position);
		for (colour=0;colour<total_level;colour++)
			{
			colour_sequence[colour]=rand()%3;
			}
		for (x=0;x<3;x++)        //This for loop to indicate the starter of the game. If it restart,
			{					//it will restart from here: starter. The led will blink for 3 times
			RED_LED_SetRatio16(RED_LED_DeviceData,0x165F);
			GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x117F);
			BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x91FF);
			wait(1000);
			RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
			GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
			BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
			wait(1000);
			}
		}
		else
		{
		RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
		GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
		BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
		}

		wait(1000);
		ispressed = 0;
		while(ispressed<2){
		TSS_Task();
		}
		if (TSS1_cKey0.Position > 0)
		{
			for (level=1;level<total_level;level++)  //this for loop is for creating randomize sequence for the colour of the led
			{                                        //the sequence is generated randomly according to the random touch on the touchpad
				/**/
					for (colour=0;colour<level;colour++)
					{

					switch (colour_sequence[colour]) //this switch is used for the random function to choose between 3 colours to randomize
						{
						case 0: RED_LED_SetRatio16(RED_LED_DeviceData,0xFFFF);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
						wait(1000);
						RED_LED_SetRatio16(RED_LED_DeviceData,0x0);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
						wait(1000);
						break;
						case 1: RED_LED_SetRatio16(RED_LED_DeviceData,0x000);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0xFFFF);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
						wait(1000);
						RED_LED_SetRatio16(RED_LED_DeviceData,0x0);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
						wait(1000);
						break;
						case 2: RED_LED_SetRatio16(RED_LED_DeviceData,0x000);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0xFFFF);
						wait(1000);
						RED_LED_SetRatio16(RED_LED_DeviceData,0x0);GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
						wait(1000);
						break;
						default:
						break;
						}
					}
						for (colour=0;colour<level;colour++) //this for loop is for taking input from the user for
						{                                    //the selection of the colours

							ispressed=0;
							while (ispressed<2)
							{
								TSS_Task();
							}
								if (TSS1_cKey0.Position > 60)
									{
									user_input[colour]=2;
									RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0xFFFF);
									wait(1000);
									RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
									wait(1000);
									 /*update nanti*/
									}
									else if (TSS1_cKey0.Position < 10)
									{
									user_input[colour]=0;
									RED_LED_SetRatio16(RED_LED_DeviceData,0xFFFF);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
									wait(1000);
									RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
									wait(1000);

									}
									else
									{
									user_input[colour]=1;
									RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0xFFFF);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
									wait(1000);
									RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
									GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
									BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
									wait(1000);
									}
							}

						for (colour=0;colour<level;colour++) //this for loop is used for checking the user input and the sequence generated
						{                                    //if it is the same, it will blink in yellow and magenta for otherwise and restart back to level 1
						if (user_input[colour] != colour_sequence[colour])
						{
							for (x=0;x<1;x++)
							{
							RED_LED_SetRatio16(RED_LED_DeviceData,0xFFFF);
							GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x0);
							BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0xFFFF);
							wait(1000);
							RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
							GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
							BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
							wait(1000);
							goto above;

							}
						}
						else
						{
							for (x=0;x<1;x++)
							{
							RED_LED_SetRatio16(RED_LED_DeviceData,0xFFFF);
							GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0xFFFF);
							BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x0);
							wait(1000);
							RED_LED_SetRatio16(RED_LED_DeviceData,0x000);
							GREEN_LED_SetRatio16(GREEN_LED_DeviceData,0x000);
							BLUE_LED_SetRatio16(BLUE_LED_DeviceData,0x000);
							wait(1000);

							}
						}
					}


					}
				}
			}

  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.5 [05.21]
**     for the Freescale Kinetis series of microcontrollers.
**
** ###################################################################
*/
