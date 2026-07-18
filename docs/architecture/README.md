# Architecture

Three focused views of the system, rather than one dense diagram.

1. [Power Rail](./power-rail.md) — USB-C input through to regulated
   analog and digital supplies.
2. [Signal Path](./signal-path.md) — MCU to output connector, the main
   waveform generation chain.
3. [Feedback Connections](./feedback-loops.md) — voltage feedback loop and
   current sense/limit loop, both acting on the output stage.

See [`datasheets/README.md`](../../datasheets/README.md) for the full
locked component list with part numbers and JLCPCB links.