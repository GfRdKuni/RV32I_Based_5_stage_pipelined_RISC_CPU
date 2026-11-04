# Five-stage RISC-V course CPU

A Verilog CPU project for the Digital Logic Foundation (H) course, with an
IF/ID/EX/MEM/WB pipeline, register forwarding, load-use bypass controls, a
chicken/rabbit counting program, and a historical button/display/VGA board shell.
This repository contains an educational RV32I-oriented implementation; the tests
below establish specific behavior, not complete ISA conformance.

## Run portable verification

Install Python 3 and Icarus Verilog (`iverilog` and `vvp`) on your PATH. The local
verification used Icarus 12.0 under Ubuntu WSL. On Debian/Ubuntu:

```sh
sudo apt-get update
sudo apt-get install -y python3 iverilog
python3 scripts/verify.py
```

With native Windows tool installations, use `python scripts/verify.py` in
PowerShell. `IVERILOG` and `VVP` can select executable paths, and the optional
`IVERILOG_LIBDIR` selects the backend directory for an unpacked Icarus installation.
The runner uses explicit sources, temporary build files, bounded simulation and
nonzero exit status on mismatch. No Python packages, compiler toolchain, downloaded
program images or vendor IP are required for the core tests.

For the separate public-core structural check, install Yosys and run:

```sh
sudo apt-get install -y yosys
python3 scripts/structural.py
```

This reads the same 19-source core manifest, checks hierarchy, lowers RTL
processes, optimizes and runs `check -assert`. `YOSYS` can select its executable.
The 120-second-bounded run saves its log to ignored `build/structural/yosys.log`.
The local Yosys 0.33 result reported zero structural problems. This does not
establish technology mapping, physical implementation or timing closure.

Both commands are configured in [CI](.github/workflows/core.yml). Local execution
does not establish that remote CI has run.

The checks cover:

- The actual embedded ROM program through the public `cpu_core` ports, across
  all 650 valid chicken/rabbit combinations with even leg counts up to 98, plus
  two examples, ten cross-byte/high-bit cases, and two live input changes without
  reset. Representative high-bit cases reach `heads=2^28` while keeping the
  program's intermediate arithmetic within 32 bits.
- Observed ALU forwarding and load-use bypass activity during that program,
  defined instruction fetches and stable outputs once inputs settle.
- 1,216 ALU arithmetic/logic/shift/comparison cases, every shift amount from 0 to
  31 on eight patterns, plus signed, unsigned and equality branch comparisons.
- 964 memory loads against an independent byte-array reference, covering
  byte/halfword/word accesses, every byte offset, cross-word accesses and signed
  versus unsigned extension, plus full-word MMIO input/output byte order.

## Core interface and application

`RTL/cpu_core.v` is the vendor-independent integration top:

| Port | Behavior |
| --- | --- |
| `clk` | Pipeline state advances on rising edges; register/memory writes use falling edges |
| `rst_n` | Active-low asynchronous pipeline reset; a falling edge initializes the ROM |
| `headin`, `legsin` | Logical 32-bit counts, encoded into data-memory words every falling edge |
| `rabbitout`, `chickenout` | Logical counts decoded from words 8 and 7, exposed continuously |

Apply an asserted reset transition and hold it across multiple clock edges before
release. The register file and data RAM have no reset clearing operation. Outputs
can be unknown or retain an earlier value until the program writes them; reset is
not an output-valid event. There is no start, ready or done handshake.

For valid inputs, the embedded program computes
`rabbits = (legs - 2*heads)/2` and `chickens = (4*heads - legs)/2`. The exhaustive
UI regression covers `0 <= heads <= 49`, even `legs <= 98`, and
`2*heads <= legs <= 4*heads`. Additional representative cases cover byte
boundaries and `heads` up to `2^28`, with even legs in the same valid ratio, so
`4*heads` remains within 32 bits. For example, `(heads=10, legs=26)` produces
3 rabbits and 7 chickens; `(300,800)` produces 100 and 200. The high-bit domain
is sampled, not exhausted. Invalid or negative inputs and cases with arithmetic
overflow have no checked application contract.

The program repeats through a final `jal x0, -132` at ROM word 33. Hold inputs
stable while results settle. The regression allows 40 core clocks after reset
release and 80 clocks after a live input change; these are tested observation
windows, not a new completion signal. The two outputs can update on different
cycles, and no coherent snapshot protocol is provided for changing inputs.
Reserved ROM words 34 through 63 contain NOPs; addressing beyond this 64-word
instruction memory remains outside the checked program contract.

The original memory layout is retained: a word's lowest addressed byte occupies
bits 31:24 internally. Loads/stores reverse byte lanes to implement little-endian
byte addressing. The count ports encode/decode that internal representation so
CPU word loads and stores agree with the logical 32-bit port values. Inputs map
to words 9 (`headin`, byte address 36) and 10 (`legsin`, address 40); outputs map
to words 7 and 8 (addresses 28 and 32). This conversion leaves the original
internal memory layout and load/store byte-addressing logic intact. The count
ports remain a fixed application interface rather than a general memory bus.

## Source layout and boundaries

| Path | Purpose |
| --- | --- |
| `RTL/cpu_core.v` and pipeline/control/ALU/memory modules | Portable core and fixed ROM program |
| `tests/core_sources.f` | Explicit core source manifest, excluding peripheral/vendor files |
| `tests/`, `scripts/verify.py`, `scripts/structural.py` | Current behavioral and structural checks |
| `RTL/riscvcpu.v`, input/display/VGA modules | Historical FPGA board shell |
| `constrs_1/`, `RISCV32ICPU.runs/`, `RISCV32ICPU.sim/` | Original constraints and Vivado implementation/simulation artifacts |
| `CPU18小组实验报告.pdf` | Original course report |

The board top is `top_module`. The VGA path depends on generated clock IP such
as `clk_wiz_0`; the portable gate compiles `cpu_core` without substituting fake
vendor clocks. Historical netlists, reports, cached builds and image data are
preserved and have not been regenerated for the repaired RTL.

The controls named `stall_EN1/2` select the current memory result for a following
dependent instruction; this design retains its existing bypass scheme. It does
not implement a general external-memory ready/stall interface. Other instruction
sequences, all jump/branch hazards, traps, interrupts, illegal instructions,
out-of-range memory access, a compliance suite and FPGA peripheral integration
remain unqualified. No technology mapping, timing closure, place/route, hardware execution,
performance or power result is established by these behavioral checks.

The existing register-file literals produce Icarus width warnings, and its array
reads produce sensitivity diagnostics. These pre-existing warnings are retained;
the runner checks actual simulation results.

See [revision log](CHANGELOG.md) and [engineering evidence](docs/engineering-review.md).
No license file was present in the baseline; this maintenance assigns no license.
