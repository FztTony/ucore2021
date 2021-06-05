SRCS = $(wildcard *.S *.c)
OBJS = $(addsuffix .o, $(basename $(SRCS)))

# Try to infer the correct TOOLPREFIX if not set
TOOLPREFIX = riscv64-unknown-elf-
CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
GDB = $(TOOLPREFIX)gdb

# log  level
LOG = INFO
ifeq ($(LOG),ERROR)
LOGNUM = 1
else
ifeq ($(LOG),WARN)
LOGNUM = 2
else
ifeq ($(LOG),INFO)
LOGNUM = 3
else
ifeq ($(LOG),DEBUG)
LOGNUM = 4
else
ifeq ($(LOG),TRACE)
LOGNUM = 5
else
LOGNUM = 3
endif
endif
endif
endif
endif

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CFLAGS += -DLOG=$(LOGNUM)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

LDFLAGS = -z max-page-size=4096

kernel: $(OBJS) kernel.ld
	$(LD) $(LDFLAGS) -T kernel.ld -o kernel $(OBJS)

clean: 
	rm -f *.o *.d kernel

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
	-device loader,addr=0x80200000,file=kernel

run: clean kernel
	$(QEMU) $(QEMUOPTS)

# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::1234"; \
	else echo "-s -p 1234"; fi)

debug: kernel .gdbinit
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB) &
	sleep 1
	$(GDB)


