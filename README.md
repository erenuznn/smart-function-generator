# Smart Function Generator

Precision sine/square/triangle function generator (1 Hz to 10 kHz, ±5 V) with
current limiting, WiFi connectivity, and a real time web dashboard for
voltage, current, and power telemetry.

> Status: in progress. See `journal/` for the running build log.

## Overview

- Output: sine / square / triangle, 1 Hz to 10 kHz, ±5 V
- Protection: analog fast current limiter, protects both the generator and
  connected circuits
- Control/measurement: STM32 (waveform generation + measurement),
  ESP32 (WiFi bridge)
- Interface: browser dashboard, real time waveform and telemetry display

## Spec

See [`docs/spec.md`](./docs/spec.md) for the full locked design targets.

## Architecture

See [`docs/architecture/`](./docs/architecture/README.md) for the full
block diagrams: power rail, signal generation path, and feedback
connections.


- **STM32**: DDS-style waveform synthesis (phase accumulator + DMA + timer),
  external DAC drive, current sense/ADC readback, fast analog current limit
  loop
- **External DAC**: precision output stage, replacing the MCU's internal DAC
  for resolution
- **External ADC**: precision telemetry readback for voltage/current/power
- **ESP32**: WiFi bridge between STM32 and browser dashboard
- **Power**: USB-C 5V in, boost + inverter for bipolar rails, linear
  regulation for analog supply cleanliness

## Repository structure

```
hardware/    KiCAD schematic and PCB layout files
sim/         LTspice simulation files (output stage, current limiter, power)
firmware/    STM32 and ESP32 firmware
ui/          Web dashboard (browser UI)
journal/     Weekly build log, written as the project happens
docs/        Design notes, characterization results, images
```

## Design decisions

Key tradeoffs and why specific parts were chosen (DAC, ADC, sense amp, op-amp,
sense resistor) will be documented here as they're finalized. See `journal/`
for the reasoning trail as it happened.

## Measured performance

To be filled in during Phase 5 (characterization week): THD, noise floor,
frequency accuracy, current limit response time.

## Build log

Day by day process, including failures and debugging, is in
[`journal/`](./journal).

## License

TBD
