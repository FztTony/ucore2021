#include "riscv.h"
#include "defs.h"
#include "memory_layout.h"

void freerange(void *pa_start, void *pa_end);

extern char ekernel[];

struct linklist {
    struct linklist *next;
};

struct {
    struct linklist *freelist;
} kmem;

void
kinit()
{
    freerange(ekernel, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char*)PGROUNDUP((uint64)pa_start);
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
        kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    struct linklist *l;
    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < ekernel || (uint64)pa >= PHYSTOP)
        panic("kfree");
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    l = (struct linklist*)pa;
    l->next = kmem.freelist;
    kmem.freelist = l;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    struct linklist *l;
    l = kmem.freelist;
    if(l) {
        kmem.freelist = l->next;
        memset((char *) l, 5, PGSIZE);// fill with junk
    }
    return (void*)l;
}