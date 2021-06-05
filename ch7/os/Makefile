U = ../user

SRCS = $(wildcard *.S *.c)
OBJS = $(addsuffix .o, $(basename $(SRCS))) link_app.o

# Try to infer the correct TOOLPREFIX if not set
TOOLPREFIX = riscv64-unknown-elf-
CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
GDB = $(TOOLPREFIX)gdb
PY = python3
CP = cp

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

LDFLAGS = -z max-page-size=4096

link_app.o: link_app.S
link_app.S: pack.py
	@$(PY) pack.py
kernel_app.ld: kernelld.py
	@$(PY) kernelld.py

kernel: $(OBJS) kernel_app.ld link_app.S
	$(LD) $(LDFLAGS) -T kernel_app.ld -o kernel $(OBJS)
	$(OBJDUMP) -S kernel > kernel.asm
	$(OBJDUMP) -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > kernel.sym

clean: 
	rm -f *.o *.d kernel *.sym *.asm link_app.S kernel_app.ld *.log

ifndef CPUS
CPUS := 1
endif

# BOARD
BOARD		?= qemu
SBI			?= rustsbi
BOOTLOADER	:= ../bootloader/$(SBI)-$(BOARD).bin

QEMU = qemu-system-riscv64
QEMUOPTS = \
	-nographic \
	-smp $(CPUS) \
	-machine virt \
	-bios $(BOOTLOADER) \
	-kernel kernel	\
	-drive file=$(U)/fs-copy.img,if=none,format=raw,id=x0 \
    -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

run: kernel
	$(CP) $(U)/fs.img $(U)/fs-copy.img
	$(QEMU) $(QEMUOPTS)

# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::1234"; \
	else echo "-s -p 1234"; fi)

debug: kernel .gdbinit
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB) &
	sleep 1
	$(GDB)


