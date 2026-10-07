# CARDIAC Arithmetic

Three programs for a CARDIAC-style teaching computer — a single-accumulator,
decimal machine whose memory cells each hold **three digits** (`000`–`999`).
Because one cell cannot hold a six-digit number, each program works on six-digit
operands by splitting them into two three-digit halves (a low limb and a high
limb) and propagating the carry or borrow between them by hand. The
multiplication program instead builds its result by repeated addition.

**Authors:** [Dmitriy Kuramshin](https://github.com/Krmsh1n5)

## The machine

A CARDIAC-like accumulator machine: one accumulator, decimal three-digit words,
and a small instruction set. Everything a program does flows through the
accumulator — load a cell into it, add or subtract another cell, store it back.

### Instructions used in these programs

| Mnemonic | Meaning                                                           |
|----------|------------------------------------------------------------------|
| `LDA x`  | load the contents of cell `x` into the accumulator               |
| `STA x`  | store the accumulator into cell `x`                              |
| `LDI x`  | load **indirectly** — load the cell whose address is held in `x` |
| `STI x`  | store **indirectly** — store into the cell addressed by `x`      |
| `ADD x`  | add cell `x` to the accumulator                                 |
| `SUB x`  | subtract cell `x` from the accumulator                          |
| `INP x`  | read an input value into cell `x`                               |
| `OUT x`  | output the contents of cell `x`                                 |
| `JAZ x`  | jump to `x` if the accumulator is zero                          |
| `HRS`    | halt                                                            |

`ra` is the return-address value provided by the simulator when control is
transferred, used by the calling convention below.

### Directives

| Directive   | Meaning                                              |
|-------------|------------------------------------------------------|
| `.word v`   | reserve one cell initialised to value `v`            |
| `.space n`  | reserve `n` uninitialised cells                      |
| `.at n`     | continue placing the following code/data at address `n` |
| `label:`    | name the current address                             |

### Calling convention

There is no hardware `call`/`return`, so the programs implement one in software.
A call is an unconditional jump written as `LDA zero; JAZ <routine>` (the
accumulator is forced to zero so the conditional jump always taken). On entry a
routine saves the return address with `LDA ra; STA return_point`, and it returns
with `LDA zero; JAZ return_point`, jumping back to the saved address. Arguments
and results are passed through agreed-upon global cells (`local_num1`,
`local_num2`, and so on).

## Programs

### `src/addition.asm`

Adds two six-digit numbers. Input order is four three-digit values: `xlo`, `xhi`,
`ylo`, `yhi` (the low and high halves of `x`, then of `y`). The `add` routine
sums one pair of limbs plus the incoming carry, reduces the result modulo 1000,
and sets a global `carry` for the next limb. Main calls it twice — once for the
low limbs, once for the high — and outputs `zlo`, `zhi`, and the final `carry`.

### `src/subtraction.asm`

Subtracts limb by limb with borrow handling. Same four inputs as addition. The
`sub` routine compares the two limbs, stores either the difference or its
complement, and sets `carry` to signal a borrow. When the low limbs borrow, main
takes the result from `1000` before processing the high limbs. If the first
number is smaller than the second, the program outputs zeros.

### `src/multiplication.asm`

Multiplies by repeated addition. Input is two values: `main_num1` (the
multiplier) and `main_num2` (the multiplicand). The `multi` routine zeroes the
result cell, sets a counter to `num1`, then adds `num2` into the result once per
count while decrementing the counter to zero. The result is reached through the
indirect pointer `plocal_result`, which main points at `main_result` before the
call; the output is that single cell, so the product is assumed to fit in one
three-digit word (below 1000). The routine uses the same return-address
convention as the other two.

## Running

These target the CARDIAC-style assembler/simulator used in the course. Load a
`.asm` file, supply the inputs each program reads with `INP` (in the order listed
above), run, and read the values it sends to `OUT`.

> Fill in the exact simulator name and the load/run command you used, so the repo
> is reproducible for anyone who opens it.

## Project structure

```
cardiac-arithmetic/
├── src/
│   ├── addition.asm        six-digit addition with carry between limbs
│   ├── subtraction.asm     six-digit subtraction with borrow handling
│   └── multiplication.asm  multiplication by repeated addition
└── README.md
```

## Course

Built for **Computer Architecture** (Computer Sciences 2, 15 ECTS) at UFAZ. The
course covers:

- Combinational logic and the construction of an arithmetic logic unit; binary arithmetic
- Sequential logic: flip-flops, registers, counters, and memories
- Design of a simple processor and control unit
- Assembly language: instruction formats, instruction types and decoding; the relation between assembler and compiler
- Examples of processor families and platforms: Intel, ARM, RISC-V, and microcontrollers
- Pipeline and cache concepts

These programs come from the assembly-language portion of the course — writing
real routines for a simple machine where arithmetic wider than one word has to be
built up from single-word operations.
