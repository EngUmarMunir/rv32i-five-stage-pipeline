# RISC-V Pipelined CPU

A five-stage pipelined RV32I processor implemented in SystemVerilog. The design includes pipeline registers, forwarding logic, and hazard detection to support efficient instruction execution and basic pipeline control.

## Features
- Five-stage pipeline architecture:
 - Instruction Fetch (IF)
 - Instruction Decode (ID)
 - Execute (EX)
 - Memory Access (MEM)
 - Write Back (WB)

- Pipeline registers: IF/ID, ID/EX, EX/MEM, MEM/WB
- Data forwarding support
- Hazard detection and pipeline flush handling
- Separate instruction and data memories
- Modular RTL design for easy understanding and verification

## Repository Layout

- `Memory_file/` - Instruction memory initialization files. 
- `RTL_design/` - synthesizable RTL for the CPU and supporting blocks.
- `Test_bench/` - simulation testbench files.

## Main RTL Blocks

- `riscv_top.sv` – Top-level CPU integration
- `program_counter.sv` – Program counter logic
- `inst_mem.sv` – Instruction memory
- `reg_file.sv` – Register file
- `main_ctrl.sv` – Main control unit
- `imm_gen.sv` – Immediate generator
- `alu_ctrl.sv` – ALU control logic
- `alu.sv` – Arithmetic Logic Unit
- `branch.sv` – Branch handling
- `hazard_detection.sv` – Hazard detection unit
- `fwd_logic.sv` – Forwarding logic
- `data_mem.sv` – Data memory
- `load_store_unit.sv` – Load/store data handling

## Simulation 

The design can be simulated using Vivado XSim or any compatible SystemVerilog simulator.

### Steps

1. Add all files from `RTL_design/` and `Test_bench/`
2. Keep `Memory_file/fib_im.mem` in its original directory
3. Set `riscv_tb.sv` as the simulation top module
4. Run simulation

## Notes

- The processor is intended for educational and verification purposes
- Supports core RV32I-style integer pipeline behavior
- Includes basic hazard management and forwarding mechanisms
- The supplied testbench performs functional verification and basic runtime checks# rv32i-five-stage-pipeline
