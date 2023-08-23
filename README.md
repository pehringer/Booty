# Required Tools
- NASM:
  + Assembler and disassembler for the Intel x86 architecture.
  + It can be used to write 16-bit, 32-bit and 64-bit programs.
- QEMU:
  + Emulates processors through dynamic binary translation.
  + Provides a set of different hardware and device models.

# Compiling Assembly Code
```
nasm -f bin [ASSEMBLY_FILE_NAME].asm -o [MACHINE_FILE_NAME].bin
```

# Running Machine Code
```
qemu-system-x86_64 -fda [MACHINE_FILE_NAME].bin
```

# 16-Bit Registers
---
#### Accumulator Register:
- General purpose register.
- Used for arithmetic and logic instructions.
- ah = upper 8-bits.
- al = lower 8-bits.
```
 _________
|    |    | 00
|    | al |
| ax |____| 07
|    |    | 08
|    | ah |
|____|____| 15

```
---
#### Base Register:
- General purpose register.
- Used as pointer offset in memory instructions.
- bh = upper 8-bits.
- bl = lower 8-bits.
```
 _________
|    |    | 00
|    | bl |
| bx |____| 07
|    |    | 08
|    | bh |
|____|____| 15

```
---
#### Count Register:
- General purpose register.
- Used for rotate and shift instructions.
- ch = upper 8-bits.
- cl = lower 8-bits.
```
 _________
|    |    | 00
|    | cl |
| cx |____| 07
|    |    | 08
|    | ch |
|____|____| 15

```
---
#### Data Register:
- General purpose register.
- Used for I/O and extended arithmetic operations.
- dh = upper 8-bits
- dl = lower 8-bits
```
 _________
|    |    | 00
|    | dl |
| dx |____| 07
|    |    | 08
|    | dh |
|____|____| 15
```
---
Stack pointer:
- Pointer to top of stack.
```
 _________
|         | 00
|   sp    |
|_________| 15

```
---
Base Pointer:
- Pointer to any location on the stack.
```
 _________
|         | 00
|   bp    |
|_________| 15

```
---
Source Index Register:
- Pointer to data source.
```
 _________
|         | 00
|   si    |
|_________| 15

```
---
Destination Index Register:
- Pointer to data destination.
```
 _________
|         | 00
|   di    |
|_________| 15

```
---
Instruction Pointer:
- Pointer to next instruction to execute.
```
 _________
|         | 00
|   ip    |
|_________| 15

```
---
