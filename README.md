# NanoRISC-V C2

### A Verilog-based RISC-V processor design using AMD/Xilinx Vivado

NanoRISC-V C2 is an educational processor-design project written in Verilog HDL. It brings together instruction fetch, instruction decoding, arithmetic and logic operations, register-file access, memory operations, branch/jump control, simulation testbenches, and FPGA implementation reports in a Vivado project.

> **Scope:** This is a learning-oriented RISC-V subset implementation, not a claim of full RV32I compliance. Consult the RTL and verification results before relying on any instruction or performance claim.

## Contents

- [Architecture](#architecture)
- [Implemented instruction subset](#implemented-instruction-subset)
- [Repository structure](#repository-structure)
- [Tools and target](#tools-and-target)
- [Simulation and verification](#simulation-and-verification)
- [Synthesis and timing results](#synthesis-and-timing-results)
- [Known limitations](#known-limitations)
- [Getting started](#getting-started)
- [Author](#author)

## Architecture

The top-level module is `nanoriscv_top`. Its main RTL modules are:

| Module | Responsibility |
|---|---|
| `pc_reg.v` | Program-counter state and sequential/redirected PC updates |
| `imem.v` | Instruction memory |
| `if_id_reg.v` | Pipeline register between instruction fetch and the execution/control stage |
| `control_unit.v` | Opcode/function-field decoding and control-signal generation |
| `imm_gen.v` | Immediate extraction and sign/zero extension for supported formats |
| `regfile.v` | 32 × 32-bit integer register file, with `x0` hardwired to zero on reads |
| `alu.v` | Arithmetic and logic operations |
| `dmem.v` | Data-memory reads and writes |
| `nanoriscv_top.v` | Top-level interconnection and `debug_out` output |

At a high level, the design fetches an instruction using the program counter, registers the fetched instruction, decodes and executes it, and accesses the register file or data memory as required. Branch and jump control can redirect the program counter.

**Important:** Although the design contains a fetch register and is described as a two-stage organization, it should not be described as a fully featured pipelined processor without additional verification. The RTL does not include a general hazard-detection/forwarding unit.

## Implemented instruction subset

The control logic contains paths for the following instruction operations:

| Category | Operations represented in the RTL |
|---|---|
| Register-register arithmetic/logic | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL` |
| Immediate arithmetic | `ADDI` |
| Memory | `LW`, `SW` |
| Conditional control flow | `BEQ`, `BNE` |
| Unconditional control flow | `JAL` |
| Upper immediate | `LUI` |

This table describes the operations represented by the current decode logic; it is **not** a claim of complete ISA compliance. Unsupported `funct3`/`funct7` combinations and edge cases should be rejected or verified explicitly before calling the design RV32I-compliant.

## Repository structure

The Vivado project includes the following main areas:

```text
NANORISCV_C2/
├── NANORISCV_C2.xpr
├── NANORISCV_C2.srcs/
│   ├── sources_1/new/
│   │   ├── alu.v
│   │   ├── control_unit.v
│   │   ├── dmem.v
│   │   ├── if_id_reg.v
│   │   ├── imem.v
│   │   ├── imm_gen.v
│   │   ├── nanoriscv_top.v
│   │   ├── pc_reg.v
│   │   └── regfile.v
│   ├── sim_1/new/
│   │   ├── tb_alu.v
│   │   ├── tb_control_unit.v
│   │   ├── tb_dmem.v
│   │   ├── tb_if_id_reg.v
│   │   ├── tb_imem.v
│   │   ├── tb_imm_gen.v
│   │   ├── tb_nanoriscv_top.v
│   │   ├── tb_pc_reg.v
│   │   └── tb_regfile.v
│   └── constrs_1/new/
│       └── timing.xdc
└── NANORISCV_C2.runs/
    ├── synth_1/
    └── impl_1/
```

Vivado-generated run and cache files may be present in the archived project; they are omitted from the abbreviated tree above.

## Tools and target

- **HDL:** Verilog
- **FPGA design environment:** AMD/Xilinx Vivado
- **Version in the archived reports:** Vivado 2025.2
- **Target part selected in the archived reports:** `xc7k70tfbv676-1`
- **Clock constraint:** 20 ns (50 MHz), as specified in `timing.xdc`

The target part is the device selected in the project reports. This alone does not establish that the design has been programmed onto a physical FPGA board.

## Simulation and verification

The project includes module-level testbenches for the ALU, control unit, data memory, fetch pipeline register, instruction memory, immediate generator, program counter, and register file. A top-level testbench also contains a small machine-code sequence intended to exercise arithmetic, load/store, branch, and jump-link behavior.

To inspect or run the project:

1. Install a compatible version of AMD/Xilinx Vivado.
2. Open `NANORISCV_C2.xpr`.
3. In **Flow Navigator**, select **Simulation → Run Simulation → Run Behavioral Simulation**.
4. Select the relevant testbench as the simulation top, if needed.
5. Inspect the console output and waveform signals.
6. Run the individual testbenches and check their results before reporting verification as passing.

The presence of a testbench does not by itself prove that it passes. Record actual pass/fail results from a fresh simulation run before describing the processor as fully verified.

## Synthesis and timing results

The archived Vivado reports contain the following results for the selected `xc7k70tfbv676-1` target:

| Metric | Archived result |
|---|---:|
| Synthesized slice LUTs | 495 |
| Synthesized slice registers | 128 |
| Synthesized RAMB18 blocks | 3 |
| DSP blocks | 0 |
| Clock period constraint | 20 ns (50 MHz) |
| Routed worst negative slack (WNS) | +8.731 ns |
| Routed total negative slack (TNS) | 0 ns |
| Routed worst hold slack (WHS) | +0.010 ns |
| Routed total hold slack (THS) | 0 ns |

The archived routed timing report states that all user-specified timing constraints were met for that run. These figures are report-specific and should be regenerated after any RTL, constraint, tool-version, or target-device change. They are FPGA implementation results, not ASIC PPA results.

## Known limitations and next steps

The current RTL is a starting point for learning processor design. Before treating it as a robust processor implementation, useful next steps include:

- Add a comprehensive instruction-level test suite and compare results against a trusted reference model.
- Validate immediate generation and branch/jump target calculations for boundary values.
- Add hazard handling or restructure the pipeline so dependent instructions execute correctly.
- Check reset behavior, memory initialization, and out-of-range memory accesses.
- Make the control unit explicitly reject unsupported instruction encodings.
- Review timing constraints and inspect critical paths after implementation.
- Document the FPGA board and pin constraints if hardware deployment is performed.

## Getting started

Clone the repository:

```bash
git clone https://github.com/devanshgit07/NANORISCV-C2.git
cd NANORISCV-C2
```

Open `NANORISCV_C2.xpr` in Vivado to inspect the design and its associated sources. Simulation and implementation results may vary depending on the installed Vivado version, target device, and project settings.

## Author

**Devansh Srivastava**  
Electronics and Communication Engineering, ABES Engineering College

- GitHub: [@devanshgit07](https://github.com/devanshgit07)

---

*Built as an educational digital-design project to explore Verilog RTL, processor organization, simulation, and FPGA implementation.*
