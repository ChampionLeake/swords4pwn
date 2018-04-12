
all: build/public.sav

build/swords4pwn.elf: swords4pwn.s
	mkdir -p $(dir $@)
	arm-none-eabi-gcc -x assembler-with-cpp -nostartfiles -nostdlib -g -o $@ $< $(DEFINES)

build/public.sav: build/swords4pwn.elf
	arm-none-eabi-objcopy -O binary $< $@

clean:
	rm -rf build/
