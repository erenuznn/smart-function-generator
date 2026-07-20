# Week 2

## Day 1 — 2026-07-20

**Did:**
- Checked ngspice model availability for locked parts before committing
  further simulation time. Downloaded and reviewed SPICE models for
  ADA4522, BUF634A, INA240A3.
- Set up Docker (hpretl/iic-osic-tools) + xschem + ngspice toolchain end
  to end: container networking, VNC access, volume mount, resolution.
  See journal/week-02-xschem-setup.md for the full setup/debugging
  reference notes.
- Built first xschem symbol (ADA4522), wrapping the existing vendor .cir
  subcircuit rather than modeling internals from scratch.
- Debugged two real issues (component missing from netlist entirely;
  stale duplicate attribute block in the .sym file), both resolved.
- Built and ran two test circuits: unity-gain buffer (confirms basic
  operation) and an open-loop polarity test (confirms pin ordering is
  genuinely correct, not just "no errors").

**Decided:**
- #decision Toolchain confirmed workable: ADA4522's plain-SPICE vendor
  model loads and simulates correctly in ngspice via xschem with no
  syntax changes needed.
- #decision Model tracking table (sim/models/README.md) will record not
  just "found the model" but pass/fail on an actual verification test,
  bar for "locked" is a working, correctly-behaving test circuit, not
  just a successful netlist.

**Problem / confusion (#bug):**
- INA293A3 model mistakenly downloaded/reviewed instead of INA240A3.
- BUF634A and INA240A3 models are PSpice behavioral macro-models using
  TI-specific functions (SGN, ABS, MAX, MIN, IF, PWR) and VSWITCH models,
  not plain portable SPICE like ADA4522. Expected to need real ngspice
  syntax translation, not yet attempted.
- xschem/Docker environment friction (port mapping, VNC password,
  resolution scaling, keyboard layout for special characters, symbol
  attribute propagation) cost significant time today. Full detail and
  fixes captured separately in journal/week-02-xschem-setup.md so it
  doesn't need re-solving next session.

**Next:**
- Build symbols for BUF634A and INA240A3 using the now-understood
  workflow, expect actual ngspice parse errors given their PSpice-specific
  syntax, debug and document the required fixes.
- Once all three high-priority models are verified, move to the actual
  foldback current-limit circuit design and simulation (deferred from
  earlier in the week).