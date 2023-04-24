/* 
 * File:   newmain.c
 * Author: Bryan Shum
 *         ECE 3301L-02 Lab8
 * Created on July 14, 2022, 12:46 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include "config.h"

# define _XTAL_FREQ 1000000 
# define SWITCH0        PORTBbits.RB1
# define LED0           PORTDbits.RD1

void __interrupt() toggleLed(void);

int main() 
{
    
    // All AN inputs are digital
    ADCON1 = 0x0f;
    
    // PORTD is output (connected to all LEDs)
    TRISD = 0x00;
    
    // RB1 is input (connected to SW0)
    TRISB = 0xff;
    
    // Initialize all LEDs to off
    PORTD = 0xFF;
    
    // Setup all interrupts
    INTCONbits.GIE = 1; // Global interrupt enable
    INTCONbits.INT0IE = 1; // Enable INT0
    INTCONbits.INT0IF = 0; // reset INT0 flag
    
    //INTCON2bits.INTEDG0 = 0; // falling edge
    //INTCON2bits.INTEDG0 = 1; // rising edge
    while(1){
        LED0 = 0;
        __delay_ms(500);
    }
}

void __interrupt() toggleLed(void)
{
    // test which interrupt called this Interrupt Service Routine
    
    // INT0
    if (INTCONbits.INT0IE && INTCONbits.INT0IF)
    {
        // Turn off the interrupt flag to avoid recursive interrupt calls
        INTCONbits.INT0IF = 0;
        
        // Do what needs to be done
        LED0 = 1; 
        __delay_ms(250);
    }
    return;
}

