OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS {
    . = 0x80400000;

    .startup : {
        *crt.S.o(.text)
    }

    .text : { *(.text) }
    .data : { *(.data .rodata) }

    /DISCARD/ : { *(.eh_*) }
}