# Week 2 (Docker/xschem/ngspice setup) — session notes

## Environment setup, resolved

- hpretl/iic-osic-tools via Docker Desktop. Run with ONLY port 5901 mapped
  (avoid mapping 80, causes conflicts). Docker Desktop auto-assigns the
  actual host port, check the container's port column (e.g. "55000:5901"),
  connect via that mapped port, not 5901 directly.

- Connect with Mac's built-in VNC client: Finder -> Cmd+K ->
  `vnc://localhost:<mapped port>`. Password is printed in the container's
  startup log (`http://localhost/?password=...`), same password works for
  native VNC.

- Volume mount: Host path = repo root -> Container path = `/foss/designs`

- Screen resolution: View -> Turn Scaling On in Screen Sharing app, fits
  the fixed 1680x1050 remote desktop to the actual window. (Proper fix
  for later: set VNC_RESOLUTION env var to match Mac's native resolution
  on container start, not done yet, scaling is good enough for now.)

- Keyboard: **`@` is typed with Control+Y** in this VNC/keyboard setup,
  not Shift+2. Worth remembering directly rather than fighting it each
  time. Container's keyboard layout was never explicitly set
  (KEYBOARD_LAYOUT env var), a proper fix for later if other characters
  cause similar issues.

## xschem symbol-from-subcircuit workflow, resolved

For wrapping an existing vendor .cir/.lib subcircuit as a usable symbol
(not building the internals yourself):

1. Create a new blank symbol, draw shape, add pins with `sim_pinnumber`
   set on ALL pins (0-indexed, matching the .subckt's port order) - if
   even one pin is missing this attribute, xschem silently falls back to
   pin creation order instead of sorting, no error given.
   Followed tutorial at https://xschem.sourceforge.io/stefan/xschem_man/tutorial_create_symbol.html

2. Set attributes ON THE .SYM FILE ITSELF, not just on the schematic
   instance. #bug hit today: attributes set on the instance didn't
   propagate, symbol was drawn on the schematic (turned red, as expected
   for a primitive/no-schematic-view symbol) but silently produced NO
   X-line and no .include in the netlist. No error, just missing.
   Always verify the actual .sym file content directly
   (`cat symbols/whatever.sym`) rather than trusting the GUI dialog saved
   correctly.

3. Required attributes in the K{} block:
    type=subcircuit
    format="@name @pinlist @symname"
    template="name=x1"
    spice_sym_def=".include /full/correct/path/to/model.cir"

4. Check the .sym file for **duplicate/leftover attribute blocks**
   (K{} vs S{}). #bug hit today: an old S{} block with a stale path and a
   syntax error (missing closing quote) was left over from an earlier
   edit and coexisted with a correct K{} block. Only K{} should exist.
   If something looks inexplicably wrong after fixing the "obvious"
   issue, grep/cat the raw file for duplicate blocks before assuming a
   deeper problem.

5. "symbol and .subckt pins do not match, discard .subckt port order"
   warning: appears to be informational/cosmetic when the subcircuit uses
   numeric port names (e.g. "1 2 99 50 45") and the symbol uses
   descriptive pin names (e.g. "IN+ IN- V+ V- OUT"), name-based matching
   fails but sim_pinnumber-based ordering still works correctly. **Don't
   trust this by assumption though**, verify with a real discriminating
   test (see below), not just "it ran without error."

## Debugging workflow that actually worked

- When the GUI display doesn't match expectations (missing net, missing
  component, unclear warning), stop guessing through the GUI and read the
  actual generated files directly via terminal:
  `cat sim/xschem/simulations/*.spice` for the netlist,
  `cat sim/xschem/symbols/*.sym` for symbol definitions.
  This found both real bugs today (missing X-line, duplicate S{} block)
  far faster than clicking through GUI dialogs.

- For verifying a model is genuinely correct (not just "ran without
  error"): use a test that would visibly discriminate correct vs
  incorrect behavior. Unity-gain buffer test alone wasn't enough to prove
  pin order was right (symmetric enough to look right even if swapped).
  The polarity test (IN+ = 0V, IN- = -12V, open loop, expect output to
  saturate toward whichever rail matches sign of V+ minus V-) was the
  test that actually proved correctness.

## Net labeling

- A net label alone doesn't make a floating wire into a real netlist
  node. The wire needs an actual second connection point (another pin) to
  be netlisted as a meaningful node. An open-ended labeled wire with
  nothing else attached will not appear in the generated netlist.

## Result

ADA4522 model fully verified: loads cleanly in ngspice (no PSpice-specific
syntax, unlike BUF634A/INA240A3 which are expected to need real syntax
fixes next), symbol correctly wraps it, pin order confirmed correct via
polarity test.