# Revision log

## Portable core maintenance — 2026-11-04

- Preserve the original five-stage core, forwarding/load-use bypass structure,
  FPGA shell, course report and historical Vivado artifacts.
- Correct arithmetic-right-shift sign filling to use the actual shift amount.
- Correct signed less-than across operands with different signs, including the
  signed branch comparison path.
- Append a ROM jump back to the application start so live input changes can be
  recomputed without executing uninitialized ROM entries.
- Fill reserved ROM words 34..63 with NOPs after Yosys exposed 960 undriven bits;
  add a bounded public-core hierarchy/process/optimization/structure gate to CI.
- Correct the case mismatch on the core's ALU overflow wire.
- Encode/decode logical count words at the four MMIO boundaries, fixing
  cross-byte inputs such as 300 heads/800 legs while preserving internal byte
  layout, load/store operations and all original small-count results.
- Add explicit portable source selection, bounded self-checks, CI configuration
  and documentation of actual interfaces and verification limits.

See [engineering evidence](docs/engineering-review.md). Historical implementation
outputs have not been regenerated for these source changes.
