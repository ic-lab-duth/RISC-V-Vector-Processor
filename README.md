# Overview

A 6-stage core, 2-Wide Superscalar, implementing the RISC-V ISA (RV32IMF).
Features:

- Dual Fetch & Dual Issue
- Dynamic Branch Prediction
- Register Renaming Scheme
- OoO Execution
- Non-blocking data cache
- Reservation Stations

A Decoupled Vector Engine, implementing the RISC-V ISA (RV32V).
Features:

- Multiple parallel execution lanes supporting **VOPI**, **VOPM**, and **VOPF** operations of the RISC-V Vector ISA
- Configurable **vector length**, **lane width**, and **number of lanes**
- Support for variable SEW configurations (8/16/32/64)  across VOPI, VOPM, and VOPF operations
- Compatible with **Vector-Vector**, **Vector-Scalar**, and **Vector-Immediate** operations
- Implements commonly used permutation instructions, including:
  - vrgather
  - vslide1down
  - vslide1up
  - vcompress

### Directory Hierarchy

The folder hierarchy is organised as follows:

- `rtl` : contains all the synthesisable RTL files
- `sva` : contains related x-checks and assertions for the design
- `sim` : contains scripts for running in Questasim


## How to Compile

The `/sim` directory is used for the simulation flow and it contains detailed instructions for both the flow and compiling C code. That way you can generate your own executable file and convert it to a memory file suitable for the CPU. Examples (code,  precompiled files and Makefiles) are included in the `/sim/examples` directory.

_**To compile:**_

- include a compiled `memory.txt` file inside the `/sim` directory
- run the `compile.do` in questasim with: "`do compile.do`"


The testbench hierarchy can be seen below:

_**TB Level Hierarchy:**_
->`tb` -> `module_top` -> `processor_top`-> `vector_top`

| Hierarchy Name | Details                                                      |
| :------------: | ------------------------------------------------------------ |
|       tb       | top level of the TB, instantiating the datapath              |
|   module_top   | The top level of the cpu datapath, connecting the memories and the surrounding logic with the core |
| processor_top  | The top level of the core datapath                           |
|   vector_top   | The top level of the vector core datapath                    |

# Pending Features

- CSR, SYSTEM instructions and Priviledged ISA
- Extend the list of supported instructions for the 'F' extension
- Extend the supported permutation instructions 
- Add additional Examples

## Reference

The permutation implementation of RISC-V Vector Core will be presented in IEEE Computer Society Annual Symposium on VLSI, July 2025. You can find the paper [here](https://arxiv.org/abs/2505.07112). To cite this work, please use: 

```
@article{titopoulos2025efficient,
  title={Efficient Implementation of RISC-V Vector Permutation Instructions},
  author={Titopoulos, Vasileios and Alexakis, George and Nicopoulos, Chrysostomos and Dimitrakopoulos, Giorgos},
  journal={arXiv preprint arXiv:2505.07112},
  year={2025}
}
```

## Contributors

Currently active: [Vasileios Titopoulos](https://github.com/Vasitito), [George Alexakis](https://github.com/GAlexakis) and [Giorgos Dimitrakopoulos](https://github.com/gdimitrak)



# License

This project is licensed under the [MIT License](./LICENSE).