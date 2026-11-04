# Portable CPU engineering maintenance

Baseline: `ead1c4154c76744e72cb93f23117c3efad5d6cbb`.

## Intent and approved scope

The account-wide engineering maintenance request authorizes reversible repairs,
portable self-checking verification, CI and accurate documentation. The user has
waived a separate planning approval gate. Preserve the five-stage pipeline,
forwarding, stalls, original course sources and vendor artifacts. Do not assign
a new license or claim complete RV32I conformance. No commit or push here.

## Specification

Provide an explicit source manifest for the vendor-independent `cpu_core`, a
standard-library Python/Icarus runner and bounded self-checks. Establish the
actual embedded chicken/rabbit program behavior through its public count ports.
Inspect and exercise arithmetic, load/store and hazard paths before making any
RTL repair. Keep the existing architectural boundaries and fix demonstrated
defects only. Exclude the VGA shell and missing vendor clock/image dependencies
from the portable core gate, with this limitation stated plainly.

## Plan

1. Read core/control/pipeline/memory/ROM sources and reproduce current behavior.
2. Add explicit portable sources and bounded application/unit checks.
3. Repair minimal evidenced defects while retaining the five-stage design.
4. Run relevant checks; document interfaces, limits, revisions and actual results.
5. Parent performs independent review and handles delivery.
6. Parent-requested follow-up: run bounded public-core Yosys hierarchy/process/
   optimization/structure checks; repair only concrete structural findings.

## Verification

Executed 2026-11-04 with Python 3 and Icarus Verilog 12.0 under Ubuntu WSL.
Tools were selected through `IVERILOG`, `VVP` and `IVERILOG_LIBDIR`; these local
paths are not embedded in project sources or scripts.

Canonical command: `python3 scripts/verify.py`.

### Baseline failures and repairs

- The initial public-core application check failed after the program reached
  uninitialized ROM, at simulation time 450 ns. The program had 33 initialized
  instructions and no terminal control transfer. Appending `jal x0, -132` at
  ROM word 33 restarts computation from the existing beginning, preserving the
  board's ability to refresh results as button inputs change. No pipeline stage
  or forwarding mechanism was replaced.
- Signed comparison reported `0 < 0x80000000` as true (ALU control 8). The original
  overflow signal was enabled only for the ADD/SUB controls, so it could not
  correct subtraction overflow for signed comparisons. The repaired compare
  selects the operand sign when signs differ, and the subtraction sign otherwise.
- After that repair, the unit check exposed arithmetic right shift of
  `0xffffffff` by 3 returning `0xdfffffff`, instead of `0xffffffff`. Sign-fill
  length incorrectly used the two-bit shift-operation selector; it now uses the
  five-bit shift amount, retaining the original shifter structure.
- Corrected the casing of the ALU overflow wire connection in `cpu_core`, which
  the compiler had diagnosed as an implicit undeclared net.
- Parent review identified that the first application regression's small-count
  range could hide an MMIO byte-order defect. The expanded check reproduced
  `(heads=300,legs=800)` yielding rabbits `0x00800064` and chickens `0x00800048`,
  rather than 100 and 200. `DATAMEM` had directly copied the logical count inputs
  into its reversed internal byte lanes and exposed raw output words. Four
  boundary conversions now encode inputs and decode outputs. The physical word
  representation, load/store implementation, ROM arithmetic and pipeline remain
  unchanged by this follow-up repair. The original 650 small-count combinations
  continue to pass; restricting documentation to that range was insufficient.
- The requested public-core Yosys structural pass initially reported 960 undriven
  bits, exactly the 30 reserved ROM words 34..63. Filling those words with NOPs
  inside the existing ROM initialization removes the structural gap without
  changing application words 0..33. The behavioral regression also explicitly
  checks these reserved words after reset. The pre-repair log remains locally
  at `build/structural/yosys_before_rom_fill.log`.

### Actual outcomes

| Check | Result |
| --- | --- |
| Public `cpu_core`, original embedded application | PASS, 662 reset cases: all 650 valid UI pairs, two original examples and ten cross-byte/high-bit cases through `heads=2^28`, with independent count-formula expectations |
| Live input updates without reset | PASS, `(20,68)` settles to 14 rabbits/6 chickens and `(65536,196608)` to 32768/32768; instruction fetches stay defined |
| Existing forwarding/bypass paths | Observed 9,310 load-use bypass indications and 19,289 ALU-forwarding indications across the application regression; outputs checked throughout each settled window |
| ALU arithmetic/logic/shifts/comparisons | PASS, 1,216 cases; all shift amounts 0..31, eight signed/unsigned patterns; BEQ/BNE/BLT/BLTU conditions also checked |
| Data memory | PASS, 964 loads against an independent byte-array model after word/halfword/byte stores, all offsets and cross-word combinations, sign/zero extension and disabled reads, plus logical MMIO word loads/output stores using full 32-bit patterns |
| Source-only copy into a Linux temporary directory containing spaces, both runners invoked from another directory | PASS, all three behavioral checks and the Yosys structural gate on the final source; no Git metadata, original vendor cache, host paths or external program image needed |
| Public-core Yosys 0.33: read all 19 manifest sources, hierarchy -check, proc, opt, check -assert | PASS after reserved-ROM repair, found/reported 0 problems; one ROM-to-register-list lowering warning; no undriven or implicit-net warnings |
| `git diff --check` | PASS |

The runner compiles only the explicit core manifest, uses temporary builds,
enforces compile/simulation timeouts and requires each test's success marker.
Temporary package-check files were removed. CI is configured to run the same
behavioral command and the separate `python3 scripts/structural.py` gate. The
latter has a 120-second timeout, accepts `YOSYS` for executable selection and
records the full log at `build/structural/yosys.log`. Latest post-ROM-repair
behavioral verification also passed all 662 cases, two live updates, 1,216 ALU
cases and 964 loads. Independent parent review inspected the ALU, byte mapping
and ROM changes, then reran all three behavioral checks and the public-core
Yosys check successfully after the final ROM repair. Hosted execution is a
separate delivery check against the actual pushed commit.

### Remaining boundaries

This is a functional application regression and targeted ALU/memory validation,
not an ISA compliance suite. It does not qualify all instruction sequences,
jump/branch hazards (including JALR/AUIPC), exceptions, traps, interrupts, illegal
instructions, arbitrary 32-bit application inputs or out-of-range memory behavior.
The original UI domain is exhausted; the higher-bit valid-count domain is sampled
with ten cases, not exhausted. These tests use even legs and `heads <= 2^28` to
avoid 32-bit overflow in the embedded program's `4*heads` intermediate.
The register file and data RAM remain unreset, and there is no public done/valid
or coherent-output-snapshot interface. Input changes may transiently mix values
until the repeated application computes a stable pair.

The original controls called `stall_EN1/2` implement a memory-result bypass;
they are not a general variable-latency memory stall protocol. This design choice
was inspected and retained rather than rearchitected.

The original register-file zero literals still produce Icarus width warnings;
array reads produce sensitivity diagnostics. These warnings predate the change.
The portable gate excludes the VGA/button/display board integration and missing
vendor clock IP. Yosys frontend/process/optimization checks are the only
structural processing performed. No vendor-IP reconstruction, technology mapping,
timing, place/route, FPGA operation or performance/power result was run or claimed. Historical Vivado
outputs are preserved and have not been regenerated for the changed source.

No license was invented and no board programming or deployment was performed.
Git delivery and its remote workflow are tracked separately from these local
implementation and verification results.
