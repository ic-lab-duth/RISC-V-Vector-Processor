# Overview

This directory contains the testing framework for the Risc-V core.
- The top testbench file `tb.sv` instantiates the core and creates log files
- `module_top.sv` imports a memory file with a pre-compiled program to the main memory. An example `memory.txt` is located in this directory

To run the simulation on Modelsim/Questasim 2 script files are provided.
- Open Questasim and navigate to the `sim` directory
- Execute `do compile.do` to build the RTL and enter the simulation

We use 2 flags on the RTL
- _MODEL_TECH_ to include the `structs.sv`,  this is defined by default on Questasim
- _INCLUDE_SVAS_ to include the related sva, this is defined optionally on `compile.do`
