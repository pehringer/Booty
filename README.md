# Required Tools

- NASM:
  + Assembler and disassembler for the Intel x86 architecture.
  + It can be used to write 16-bit, 32-bit and 64-bit programs.
  
- QEMU:
  + Emulates processors through dynamic binary translation.
  + Provides a set of different hardware and device models.

---

# Compiling Assembly Code

```
nasm -f bin [ASSEMBLY_FILE_NAME].asm -o [MACHINE_FILE_NAME].bin
```

---

# Running Machine Code

```
qemu-system-x86_64 -fda [MACHINE_FILE_NAME].bin
```

---

# 16-Bit Registers

**AX** - Accumulator Register:
- General purpose register.
- Used for arithmetic and logic instructions.
- ah = upper 8-bits.
- al = lower 8-bits.

**BX** - Base Register:
- General purpose register.
- Used as pointer offset in memory instructions.
- bh = upper 8-bits.
- bl = lower 8-bits.

**CX** - Count Register:
- General purpose register.
- Used for rotate and shift instructions.
- ch = upper 8-bits.
- cl = lower 8-bits.

**DX** - Data Register:
- General purpose register.
- Used for I/O and extended arithmetic operations.
- dh = upper 8-bits
- dl = lower 8-bits.

**SP** - Stack pointer:
- Pointer to top of stack.

**BP** - Base Pointer:
- Pointer to any location on the stack.

**SI** - Source Index Register:
- Pointer to data source.

**DI** - Destination Index Register:
- Pointer to data destination.

**IP** - Instruction Pointer:
 - Pointer to next instruction to execute.

---

# 32-Bit Global Descriptor Table (GDT)

### Global Descriptor Table Pointer:

The LGDT (Load Global Descriptor Table) instruction is used to load the GDT. The LGDT instruction does this by setting the GDTR (Global Descriptor Table Register) with a pointer to the to **Global Descriptor**. The pointer format is as follows:
- 16-bit **Size**: The size of the GDT in bytes.
- 32-bit **Offset**: The linear address of the GDT in memory.

```
 ________  Bit#
|        | 00
| Limit  |
|________| 15
|        | 16
| Offset |
|________| 47

```

### Global Descriptor Table Format:

Defines various memory areas used during program execution. The table is made up of consecutive **Segment Descriptor** entries. The first entry should always be a NULL **Segment Descriptor** (all zeros). The table format is as follows:

```
 ____________________  Byte#
|                    | 00
| NULL               |
|____________________| 07
|                    | 08
| Segment Descriptor |
|____________________| 15
|                    | 16
| Segment Descriptor |
|____________________| 23
|                    | 24
| . . .              |
|____________________| 31

```

### Segment Descriptor Format:

Defines how to translate a logical address into a linear address. The discriptor format is as follows:
- 16-bit **Limit**: (bits 00-15 of 20-bit value) Maximum addressable unit (either 1 byte units or 4KiB pages).
- 16-bit **Base**: (bits 00-15 of 32-bit value) Linear address where the segment begins.
- 08-bit **Base**: (bits 16-23 of 32-bit value) Linear address where the segment begins.
- 08-bit **Access**:
  + 01-bit **Accessed**: Best set to 0, the CPU will set it when the segment is accessed.
  + 01-bit **Readable/Writable**:
    * Code segments: write access never allowed for segment:
      * 0 = read access not allowed.
      * 1 = read access allowed.
    * Data segments: Read access always allowed for segment:
      * 0 = write access not allowed.
      * 1 = write access allowed.
  + 01-bit **Direction/Conforming**:
    * Code segments:
      * 0 = code in this segment can only be executed from equal privilege levels (**Descriptor Privilege Level**).
      * 1 = code in this segment can be executed from equal or lower privilege levels.
    * Data segments:
      * 0 = segment grows up.
      * 1 = segment grows down (then Offset has to be greater than Limit).
  + 01-bit **Executable**:
    * 0 = Descriptor defines data segment.
    * 1 = defines code segment which can be executed.
  + 01-bit **Descriptor Type**:
    * 0 = Descriptor defines system segment (Task State Segment).
    * 1 = defines code or data segment.
  + 02-bit **Descriptor Privilege Level**: CPU Privilege level for segment:
    * 0 = highest (kernel).
    * 3 = lowest (user applications).
  + 01-bit **Present**: Entry refers to valid segment. Must be 1 for any valid segment.
- 04-bit **Limit**: (bits 16-19 of 20-bit value) Maximum addressable unit (either 1 byte units or 4KiB pages).
- 08-bit **Flags**:
  + 01-bit ***Reserved***.
  + 01-bit **Long-Mode Code**:
    * 1 = Descriptor defines 64-bit code segment (Size Flag should always be 0).
    * 0 = any other type of segment.
  + 01-bit **Size**:
    * 0 = Descriptor defines a 16-bit protected mode segment.
    * 1 = defines a 32-bit protected mode segment.
  + 01-bit **Granularity**:
    * 0 = Limit is in 1 Byte blocks.
    * 1 = limit is in 4 KiB blocks.
- 08-bit **Base**:  (bits 24-31 of 32-bit value) Linear address where the segment begins.

```
 _____________________________________  Bit#
|                                     | 00
| Limit 0:15                          |
|_____________________________________| 15
|                                     | 16
| Base 0:15                           |
|_____________________________________| 31
|                                     | 32
| Base 16:23                          |
|_____________________________________| 39
|        |                            | 40
|        | Accessed                   |
|        |____________________________| 40
|        |                            | 41
|        | Readable/Writable          |
|        |____________________________| 41
|        |                            | 42
|        | Direction/Conforming       |
|        |____________________________| 42
|        |                            | 43
| Access | Executable                 |
|        |____________________________| 43
|        |                            | 44
|        | Descriptor Type            |
|        |____________________________| 44
|        |                            | 45
|        | Descriptor Privilege Level | 
|        |____________________________| 46
|        |                            | 47
|        | Present                    |
|________|____________________________| 47
|                                     | 48
| Limit 16:19                         |
|_____________________________________| 51
|        |                            | 52
|        | Reserved                   |    
|        |____________________________| 52
|        |                            | 53
|        | Long-Mode Code             |
| Flags  |____________________________| 53
|        |                            | 54
|        | Size                       |
|        |____________________________| 54
|        |                            | 55
|        | Granularity                | 
|________|____________________________| 55
|                                     | 56
| Base 24:31                          |
|_____________________________________| 63

```













