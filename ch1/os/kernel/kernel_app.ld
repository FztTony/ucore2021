OUTPUT_ARCH(riscv)
ENTRY(_entry)
BASE_ADDRESS = 0x80200000;

SECTIONS
{
    . = BASE_ADDRESS;
    skernel = .;

    stext = .;
    .text : {
        *(.text.entry)
        *(.text .text.*)
        . = ALIGN(0x1000);
        *(trampsec)
        . = ALIGN(0x1000);
    }

    . = ALIGN(4K);
    etext = .;
    srodata = .;
    .rodata : {
        *(.rodata .rodata.*)
    }

    . = ALIGN(4K);
    erodata = .;
    sdata = .;
    .data : {
        *(.data)
        . = ALIGN(0x1000);
        *(.data.app0)
        . = ALIGN(0x1000);
        *(.data.app1)
        . = ALIGN(0x1000);
        *(.data.app2)
        . = ALIGN(0x1000);
        *(.data.app3)
        . = ALIGN(0x1000);
        *(.data.app4)
        . = ALIGN(0x1000);
        *(.data.app5)
        . = ALIGN(0x1000);
        *(.data.app6)
        . = ALIGN(0x1000);
        *(.data.app7)
        . = ALIGN(0x1000);
        *(.data.app8)
        . = ALIGN(0x1000);
        *(.data.app9)

        *(.data.*)
    }
    
    . = ALIGN(4K);
    edata = .;
    .bss : {
        *(.bss.stack)
        sbss = .;
        *(.bss .bss.*)
    }

    . = ALIGN(4K);
    ebss = .;
    ekernel = .;

    /DISCARD/ : {
        *(.eh_frame)
    }
}
