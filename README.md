MIPS
====

A very simple MIPS core.

- 52 instructions in the MIPS-I instruction set are implemented.
- Modified Harvard architecture.
- No pipelining. All instructions are single-cycle.
- Supports unaligned memory access.
- Microcoded controller.

This core was designed in only one week. It was for the course project of VLSI designing, and will be fabricated with 180nm technology.

**Modules**
- alu.v: The ALU (Arithmetic Logic Unit). Executes arithmetic operations and R-type instructions.
- bu.v: Branch Unit. Comparing two numbers and set the jump signal according to *bfunc*.
- controller.v: Setup signals to coordinate every unit to execute an instruction. Uses the microcode to decode instructions.
- dataconv.v: Data Format Converter. Converts data from registers or the memory into different lengths and formats. Generates memory access addresses.
- dcache.v: Data Cache. Partially implemented.
- icache.v: Instruction Cache. Partially implemented.
- mux.v: 32-bit 2-to-1 multiplexer. Used in many cases.
- processor.v: Defines the top level connections between components.
- regfile.v: The register file. Contains 31 general purpose 32-bit registers. Register 0 is tied to 0x00000000.

**How to play with it**

1. Put instructions into *inst.bin*, and put initial data memory contents into *data.hex*. Please refer to demos for examples.
2. Use *testbench/processor_tb.v* as the testbench, and run it with any Verilog simulators. Note that some features are not supported by some simulators, which may causes errors.
3. The content of data memory will be dumped into *dump.hex* when simulation finishes.

**About the demos**

There are four demos. Every of them implements an image processing algorithm or a visual effect.

- Thresholding: Does thresholding on gray-scale images.
- Color_Thresholding: Does thesholding on every channel of a RGB image, generating a visual effect similar to the pseudo color. This demo is made for another version of this CPU which has an SIMD Architecture.
- Pixelate: The pixelate filter, a stylish filter.
- Luminance: Adjust luminance of an image. Made for the SIMD version supporting saturation arithmetic instructions.
