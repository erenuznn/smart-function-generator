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
-

## Day 2 — YYYY-MM-DD

**Did:**
-

**Decided:**
-

**Problem / confusion:**
-

**Next:**
-
