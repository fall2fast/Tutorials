# First Print with Eddy: What to Expect

## Pre-Print Checklist

### 1. Firmware Restart ✓
```
Upload printer.cfg → RESTART → Check for errors
```
**Expected:** No errors, "printer ready"

### 2. Probe Query ✓
```gcode
QUERY_PROBE
```
**Expected:** `probe: open`  
**Bad:** `probe: TRIGGERED` (means offset is wrong)

### 3. Z-Offset Calibration ⚠️ CRITICAL
```gcode
G28
Z_OFFSET_CALIBRATION
```
**What happens:**
- Printer homes XY, then Z
- Moves to bed center (175, 175)
- Probes to find bed surface
- **You adjust with paper test**
- Saves offset to config

**Expected time:** 3-5 minutes

### 4. Quad Gantry Level ✓
```gcode
G28
QUAD_GANTRY_LEVEL
```
**What happens:**
- Probes all 4 corners
- Adjusts Z motors to level gantry
- Should complete in ~2 minutes

**Expected:** `Quad gantry leveled`

### 5. Bed Mesh (The Big One!) 🔥
```gcode
G28
QUAD_GANTRY_LEVEL
BED_MESH_CALIBRATE
```

**What to expect:**
- **Time:** 5-6 minutes (was 2-3 with old 9x9)
- **Sound:** Continuous gentle scanning motion
- **Motion:** Printhead moves in smooth rows
- **Silence:** No clicking/tapping (Eddy doesn't touch!)

**Progress:**
```
Generating new points...
Mesh calibration started
Probing point 1/1681...
Probing point 50/1681...
Probing point 100/1681...
...
Probing point 1681/1681...
Mesh calibration completed
```

**Why so long?** 41×41 = 1,681 probe points vs old 9×9 = 81 points. That's **20× more data!**

---

## The First Print

### Startup Sequence Changes

#### OLD (Contact Probe):
```
1. Home (5 sec)
2. Heat bed (2-3 min)
3. QGL (2 min)
4. Heat nozzle (1-2 min)
5. Mesh (2 min @ 9x9)
6. Start print
Total: ~8 min
```

#### NEW (Eddy):
```
1. Home (5 sec)
2. Heat bed (2-3 min)
3. QGL (2 min)
4. Heat nozzle (1-2 min)
5. Mesh (5 min @ 41x41) ← Longer but worth it!
6. Start print
Total: ~11 min
```

**Yes, 3 extra minutes.** But you get **20× better bed mapping!**

---

## What You'll Notice

### 1. Silent Probing
**Before:** *click click click click* (mechanical probe tapping)  
**Now:** *swoooosh* (smooth scanning motion)

### 2. No "Pre-Contact" Movement
**Before:** Probe approaches bed → slows → *tap* → backs off  
**Now:** Probe glides smoothly at constant height (no touching!)

### 3. Consistent First Layer
**Before:** First layer varies slightly in adhesion/squish  
**Now:** First layer is **glassy smooth** across the entire bed

### 4. Better Large Prints
**Before:** 9×9 mesh misses small bed variations  
**Now:** 41×41 mesh catches every tiny warp/dip

### 5. No Nozzle Marks
**Before:** Occasionally left tiny witness marks where probe touched  
**Now:** Zero marks (non-contact!)

---

## Troubleshooting First Print

### Problem: "Nozzle Too Close"
**Symptoms:** Filament gets scraped off, elephant's foot, clicking extruder

**Fix:**
```gcode
Z_OFFSET_APPLY_PROBE             # Save current offset
SET_GCODE_OFFSET Z=+0.05         # Raise nozzle 0.05mm
# Print first layer
# If still too close, increase to +0.1
```

**Permanent fix:**
```gcode
Z_OFFSET_CALIBRATION             # Recalibrate from scratch
```

### Problem: "Nozzle Too Far"
**Symptoms:** Filament not sticking, gaps in first layer, spaghetti

**Fix:**
```gcode
Z_OFFSET_APPLY_PROBE
SET_GCODE_OFFSET Z=-0.05         # Lower nozzle 0.05mm
# Print first layer
# If still too far, decrease to -0.1
```

### Problem: "Mesh Looks Weird"
**Symptoms:** Visualization shows extreme highs/lows, unusual patterns

**Possible causes:**
1. **Dirty bed** - Clean with IPA
2. **Hot bed warped** - Let it heat soak 10 min before meshing
3. **Gantry not level** - Run QGL first, then mesh
4. **Eddy too close** - Increase `z_offset` in config

**Fix:**
```gcode
G28
QUAD_GANTRY_LEVEL
G28 Z
# Let bed heat to print temp for 10 min
BED_MESH_CALIBRATE
```

### Problem: "Probe Triggered Before Movement"
**Symptoms:** Print fails to start, Klipper throws error

**Cause:** Z-offset is too low (negative or near-zero)

**Fix:**
1. Check `z_offset` in `printer.cfg`
2. Should be ~2.0 to 4.0 (positive!)
3. Increase by 0.5mm increments
4. Recalibrate with paper test

---

## First Layer Expectations

### With Perfectly Calibrated Eddy:

**Top surface view:**
- Smooth, glassy finish
- No gaps between lines
- No excess squish/ridging
- Lines fuse together perfectly

**Side view:**
- Consistent height across bed
- No thick/thin variations
- Corners match center perfectly

**Feel:**
- Can't feel individual lines when rubbed
- Smooth as glass
- No rough patches

---

## First Print Recommendations

### Best First Print: Calibration Cube (20mm)
**Why?**
- Small → Fast
- Flat bottom → Tests first layer
- Sharp corners → Tests bed levelness
- Easy to measure accuracy

### DON'T Print First:
- ❌ Large bed-coverage prints (test calibration first!)
- ❌ Thin delicate parts (wait until dialed in)
- ❌ Multi-hour prints (verify short prints work first)

### DO Print First:
- ✅ 20mm calibration cube
- ✅ Benchy (classic test)
- ✅ Simple bed adhesion test square
- ✅ XYZ calibration cube

---

## Success Criteria

After first print with Eddy, you should see:

✅ **Mesh completed** without errors  
✅ **First layer** sticks perfectly  
✅ **No gaps** in first layer lines  
✅ **No elephant's foot** or excessive squish  
✅ **Consistent** first layer from corner to corner  
✅ **Print finished** successfully

If you see all these = **Eddy is dialed in!** 🎉

---

## Optimization After First Successful Print

Once you've proven Eddy works:

1. **Increase speed settings** (Eddy enables faster probing)
2. **Re-run input shaper** with new damping ratios
3. **Consider increasing acceleration** (better bed sensing = more confidence)
4. **Save your mesh** as default: `BED_MESH_PROFILE SAVE=default`

---

## When to Re-Mesh

You need a fresh mesh when:
- Bed temperature changes >10°C from last mesh
- You've adjusted gantry or bed screws
- You physically moved the printer
- It's been >1 week since last mesh
- First layer quality degrades

You DON'T need to re-mesh:
- Between prints at same temp
- Same day consecutive prints
- Same filament/material
- Minor Z-offset tweaks

---

## Final Tips

1. **Trust the Eddy** - It's more accurate than the old probe
2. **Be patient** - 41×41 mesh takes time but worth it
3. **Don't skip QGL** - Always run before meshing
4. **Heat soak the bed** - 10 min at print temp before meshing
5. **Clean the PEI** - Dirty bed = bad mesh data

Happy printing! The Eddy will change your 3D printing game. 🚀
