# Week 1 — Architecture and documentation skeleton

## Day 1 — 2026-07-15

**Did:**
- Created the GitHub repo, 
  started looking for compatible components, 
  gathered datasheets for the #locked components.

**Decided:**
- #decision DAC update rate set to 80 kSps (8x oversampling at 10kHz target),
  based on AD5761 t12 settling spec (7.5us typ for 10V step at 16-bit res).
  This gives us around 1.66x margin over settling limit rather than running at the edge
  of the 133 kSps theoretical ceiling. SPI bus itself (24-bit frame, 50MHz max SCLK)
  is not the bottleneck, settling time is.

**Problem / confusion:**
-

**Next:**
- Still have to decide on ADC, INA, Op-Amp, Boost Converter, LDO and Inverter.

## Day 2 — 2026-07-16

**Did:**
- Continued with component selection,
  added a buffer after the output op-amp,


**Decided:**
- #decision Limit current is 100mA calibrated for 50Ohm resistance
  with 5V supply voltage. 

- #decision INA Gain is selected to have 1V corresponding to a 100mA
  current over 100mOhm sense resistor. INA240A3PWR offers 100V/V Gain.

- #decision Output stage = ADA4522-1 (precision, 5uV offset) + BUF634A
  (250 mA current buffer) in composite amplifier topology, buffer inside
  the feedback loop. ADA4522 alone only sources 22mA, insufficient for
  100mA current limit target.

- #decision Bipolar rail target set to +/- 12V, based on BUF634A's
  +/-18V max supply limit

- #decision Boost converter: TPS61040, 850mA max output, well above the 
  estimated worst case 200mA budget. Adjustable output so it needs feedback
  resistor divider sized against datasheet reference voltage for 12V.

- #decision Inverter: TPS63700, 360mA max, dedicated inverting buck-boost,
  -2V to -15V adjustable range.

- #decision Corrected architecture: boost and inverter both run in parallel
  directly from USB-C 5V input, not in series. Less conversion loss.

- #decision LDO negative rail: ADP7182 (TSOT-23-5), 200mA, 18uVrms noise,
  66dB PSRR@10kHz, 185mV dropout @ 200mA.

- #decision Because of LDO dropout (185mV negative, need to check ADP7142's
  positive dropout spec too), boost/inverter targets revised from +/-12V
  to roughly +13V/-13V so the LDOs have real headroom to regulate cleanly
  to the final +/-12V rails.

- #decision Confirmed ADP7142 max dropout = 420mV @ 200mA. Combined with
  ADP7182's 185mV, final rail targets locked:
  Boost (TPS61040): 13V (12V LDO out + 420mV dropout + ~580mV margin)
  Inverter (TPS63700): -13V (-12V LDO out + 185mV dropout + ~815mV margin)

- #decision Corrected ADP7182 dropout: datasheet max is -360mV @ 200mA
  (JLCPCB's summary field showed 185mV, which was the typ value, not max).
  Recalculated negative rail margin: -13V inverter target still holds,
  now with ~0.64V margin over the -12.36V minimum required. 


**Problem / confusion:**
-

**Next:**
-
