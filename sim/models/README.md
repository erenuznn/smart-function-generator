# SPICE Models

Model files are kept locally only (not committed, see `.gitignore`), since
they're vendor-provided and not ours to redistribute. This file tracks
where each one came from and whether it's actually usable in ngspice, so
the reference set stays reproducible for anyone cloning the repo.

| Part | Source link | Format | ngspice compatible? | Notes |
|---|---|---|---|---|
| ADA4522-1 | https://www.analog.com/en/products/ada4522-1.html| .cir | Yes | |
| BUF634A | http://www.ti.com/litv/tsc/sbomay2b| .lib | Partial | |
| INA240A3 | https://www.ti.com/lit/zip/sbombc6 | .lib | Partial | |
| AD5761 | | | TBD | Lower priority, may simulate as ideal source instead |
| TPS61040 | | | TBD | Lower priority, power stage sim comes later |
| TPS63700 | | | TBD | Lower priority |
| ADP7142 | | | TBD | Lower priority |
| ADP7182 | | | TBD | Lower priority |
