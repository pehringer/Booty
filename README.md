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
#### Accumulator Register:
- General purpose register.
- Used for arithmetic and logic instructions.
- ah = upper 8-bits.
- al = lower 8-bits.
```
 _________    Bit #
|    |    | 00
|    | al |
| ax |____| 07
|    |    | 08
|    | ah |
|____|____| 15

```
#### Base Register:
- General purpose register.
- Used as pointer offset in memory instructions.
- bh = upper 8-bits.
- bl = lower 8-bits.
```
 _________    Bit #
|    |    | 00
|    | bl |
| bx |____| 07
|    |    | 08
|    | bh |
|____|____| 15

```
#### Count Register:
- General purpose register.
- Used for rotate and shift instructions.
- ch = upper 8-bits.
- cl = lower 8-bits.
```
 _________    Bit #
|    |    | 00
|    | cl |
| cx |____| 07
|    |    | 08
|    | ch |
|____|____| 15

```
#### Data Register:
- General purpose register.
- Used for I/O and extended arithmetic operations.
- dh = upper 8-bits
- dl = lower 8-bits
```
 _________    Bit #
|    |    | 00
|    | dl |
| dx |____| 07
|    |    | 08
|    | dh |
|____|____| 15
```
#### Stack pointer:
- Pointer to top of stack.
```
 _________    Bit #
|         | 00
|   sp    |
|_________| 15

```
#### Base Pointer:
- Pointer to any location on the stack.
```
 _________    Bit #
|         | 00
|   bp    |
|_________| 15

```
#### Source Index Register:
- Pointer to data source.
```
 _________    Bit #
|         | 00
|   si    |
|_________| 15

```
#### Destination Index Register:
- Pointer to data destination.
```
 _________    Bit #
|         | 00
|   di    |
|_________| 15

```
#### Instruction Pointer:
- Pointer to next instruction to execute.
```
 _________    Bit #
|         | 00
|   ip    |
|_________| 15

```
---
# 32-Bit Global Descriptor Table
### Global Descriptor Table Format:
- Defines various memory areas used during program execution.
- Made up of consecutive **Segment Descriptor** entries.
- First entry should always be NULL.
- Each entry is 8 bytes in size.
```
 ________________________________    Byte #
|                                | 00
| Entry 0  -  NULL               |
|________________________________| 07
|                                | 08
| Entry 1  -  Segment Descriptor |
|________________________________| 15
|                                | 16
| Entry 2  -  Segment Descriptor |
|________________________________| 23
|                                | 24
|             . . .              |
|________________________________| 31

```
### Segment Descriptor Format:
- Defines how to translate a logical address into a linear address.
- 8 bytes in size.
```
 _____________________________________    Bit #
|                                     | 00
| Limit                               |
|_____________________________________| 15
|                                     | 16
| Base                                |
|_____________________________________| 31
|                                     | 32
| Base                                |
|_____________________________________| 39
|        |                            | 40
|        | Accessed Bit               |
|        |____________________________| 40
|        |                            | 41
|        | Read/Write Bit             |
|        |____________________________| 41
|        |                            | 42
|        | Direction Bit              |
|        |____________________________| 42
|        |                            | 43
| Access | Execute Bit                |
|        |____________________________| 43
|        |                            | 44
|        | Descriptor type Bit        |
|        |____________________________| 44
|        |                            | 45
|        | Descriptor Privilege Level |
|        |____________________________| 46
|        |                            | 47
|        | Present Bit                |
|________|____________________________| 47
|                                     | 48
| Limit                               |
|_____________________________________| 51
|        |                            | 52
|        | Reserved                   |
|        |____________________________| 52
|        |                            | 53
|        | Long-Mode Code Flag        |
| Flags  |____________________________| 53
|        |                            | 54
|        | Size Flag                  |
|        |____________________________| 54
|        |                            | 55
|        | Granularity Flag           |
|________|____________________________| 55
|                                     | 56
| Base                                |
|_____________________________________| 63

```













