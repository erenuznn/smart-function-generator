# Power Rail

USB-C 5V input splits into three independent regulation paths: bipolar
analog rails (boost + LDO, inverter + LDO) and a separate digital 3.3V
rail for the MCU/WiFi. Kept separate so digital switching noise never
reaches the precision analog supply.

```mermaid
flowchart TD
    USB[USB-C 5V In]

    USB --> BOOST[TPS61040 - Boost Converter -> 13V]
    USB --> INV[TPS63700 - Inverter -> -13V]
    USB --> DIGREG[AMS1117-3.3 - LDO]

    BOOST --> LDOP[ADP7142 - LDO -> +12V]
    INV --> LDON[ADP7182 - LDO -> -12V]

    LDOP --> ANALOG[Analog Rails: DAC, ADC, Op-amp, Buffer]
    LDON --> ANALOG

    DIGREG --> MCU[STM32G431 - MCU]
    DIGREG --> ESP[ESP32 - WiFi MCU]
```

**Open item:** digital 3.3V regulator part not yet selected.