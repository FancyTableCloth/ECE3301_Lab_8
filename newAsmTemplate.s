config OSC = INTIO2
config BOR = OFF        ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
config STVREN = OFF     ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
config WDT = OFF        ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
config MCLRE = ON       ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#include <xc.inc>
	goto main	
	
	; Toggle the LEDs connected to RC0 to RC3 sequentially with some slow delay
	; Use interrupt to toggle the other led connected to RC4
	; ECE 3301L-02 Bryan Shum Lab8
psect intCodeHi, class = CODE, reloc = 2
    bcf	    INTCON, 1, a
    call    toggle
    retfie  0
	
psect code
PREV_STATUS equ 0x50
main: 

    ; set the I/O port directions
    setf    ADCON1, a   ; AN inputs are now digital inputs
    bcf     TRISD, 1, a	; RD1 is output (connected to LEDs)
    bsf	    TRISB, 1, a ; RB1 is input (connected to switch)
	
    ; initial output value
    setf    PORTD, a	; Start with all LEDs off
    
    ; Setup interrupts
    movlw   10010000B
    movwf   INTCON, w, a    ; Enable global interrupt, enable INT0, reset INT0 Flag
    bcf	    INTCON2, 6, a   ; Interrupt on falling edge (default)
    ;bsf	    INTCON2, 6, a   ; Interrupt on rising edge 
    
loop:
    movlw   0
    movwf   PORTD, a
    call    delay500ms    
    bra	    loop    
    
;--------------------------------------------------------------------------
    ; SUBROUTINES

toggle:
    btg	    PORTD, 1, a
    return	
    
delay2550us:			    ; 2550 us delay
	movlw	255
l1:	decf	WREG, w, a
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bnz	l1
	return 1

delay500ms:			    
	movlw	100		    
	movwf	0x10, a
l2:	call	delay2550us
	decf	0x10, f, a
	bnz	l2
	return 1
end


