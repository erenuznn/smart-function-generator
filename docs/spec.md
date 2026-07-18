# Spec Sheet

Locked design targets. Update this file if any of these change, it's the
reference everything else (schematic, firmware, characterization) gets
checked against.

## Output

| Parameter | Value | Basis |
|---|---|---|
| Waveform types | Sine, square, triangle | — |
| Frequency range | 1 Hz – 10 kHz | Scoped down from an initial 1 MHz target for achievable fidelity, current limiting response time, and deliverable WiFi telemetry |
| Amplitude | ±5 V | — |
| Output current limit | 100 mA | Sized to drive a 50 ohm load at full +/-5V swing without saturating (standard bench instrument impedance) |
| DAC resolution | 16-bit | AD5761 |
| DAC update rate | 80 kSps (8x oversampling at 10kHz) | AD5761 settling time (7.5us typ for 10V step) gives a 133kSps typical ceiling; 80kSps keeps ~1.66x margin rather than running at the edge of a "typ" (not max) spec |
| Output slew rate requirement | >=0.314 V/us (theoretical min), actual ADA4522 SR = 1.4 V/us | ~4.5x margin |

## Power

| Rail | Target | Regulation | Notes |
|---|---|---|---|
| Analog positive | +12 V | ADP7142 LDO, fed by TPS61040 boost at 13V | 420mV max dropout @ 200mA sets the 13V boost target |
| Analog negative | -12 V | ADP7182 LDO, fed by TPS63700 inverter at -13V | 360mV max dropout @ 200mA (datasheet; JLCPCB summary listed 185mV typ) |
| Digital | 3.3 V | AMS1117-3.3, fed directly from USB-C 5V | Sized for 600mA to cover ESP32 WiFi TX burst current. Layout requirement: >=1000 sq mm copper pour on tab for theta_JA ~55-60C/W (T_rise ~56-61C); minimal pour degrades to 80C/W (~82C rise), still under 125C max but less margin |
| Input | 5 V | USB-C | Powers all three regulation paths in parallel |
| Analog rail current budget | ~150-200 mA per rail | — | Covers ADA4522/BUF634A quiescent + signal current + DAC/ADC reference draw |

## Measurement

| Parameter | Value | Basis |
|---|---|---|
| Current sense resistor | 0.1 ohm | ~1mW power loss at 100mA limit, 10mV signal at limit point |
| Current sense amp gain | INA240A3, 100 V/V | 10mV at limit -> 1V at INA output, clean fraction of ADC input range |
| Telemetry ADC | ADS1263, 32-bit, up to 38.4 kSPS | Not used for full-bandwidth waveform capture, only voltage/current/power telemetry |

## Protection

| Feature | Status |
|---|---|
| Fast analog current limit loop | Comparator/clamp topology not yet designed (open item) |
| Output short-circuit protection | Inherited from AD5761 and BUF634A internal protections; system-level response time still to be characterized |

## Firmware / Control

| Parameter | Value |
|---|---|
| MCU | STM32G431RBT6 (LQFP-64) |
| WiFi bridge | ESP32-WROOM-32-N4 (SMD, 4MB flash) |
| MCU <-> DAC | SPI, 24-bit frame, timer+DMA triggered at 80kSps |
| MCU <-> ADC | SPI, DRDY-interrupt driven (not fixed-rate polling) |
| MCU <-> ESP32 | UART |
| ESP32 <-> UI | WiFi, WebSocket |

## Open items

- Current limit comparator circuit topology not yet designed
- Feedback resistor divider values for TPS61040, TPS63700, ADP7142, ADP7182 not yet calculated
- Full waveform capture over WiFi limited by throughput; live view scoped to numeric telemetry + decimated/preview waveform, not full-bandwidth 10kHz capture (see Week 1 discussion)