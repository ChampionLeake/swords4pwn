#---------------------------------------------------------------------------------
# path to tools
#---------------------------------------------------------------------------------
export PATH	:=	$(DEVKITARM)/bin:$(PATH)
export CC	:=	gcc
#---------------------------------------------------------------------------------
# the prefix on the compiler executables
#---------------------------------------------------------------------------------
PREFIX		:=	arm-none-eabi-
#---------------------------------------------------------------------------------

all: build/all.dat

build/swords4pwn.elf: swords4pwn.s
	mkdir -p $(dir $@)
	$(PREFIX)gcc -x assembler-with-cpp -nostartfiles -nostdlib -g -o $@ $< $(DEFINES)

build/all.dat: build/swords4pwn.elf
	arm-none-eabi-objcopy -O binary $< $@

clean:
	rm -rf build/
