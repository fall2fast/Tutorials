# Eddy Installation: 5-Minute Action Plan

## RIGHT NOW (At Your Computer)

### Step 1: Download Fixed Config (30 seconds)
1. Download `printer.cfg` from this conversation
2. ✅ That's the one with `i2c_bus: i2c1_PB6_PB7` fixed

### Step 2: Backup Current Config (30 seconds)
1. In Mainsail: Settings → Machine → `printer.cfg`
2. Click 💾 to download backup
3. Save as `printer.cfg.backup-before-eddy`

### Step 3: Upload New Config (1 minute)
1. In Mainsail: Settings → Machine
2. Click ✏️ on `printer.cfg`
3. Delete all content
4. Paste contents of fixed `printer.cfg`
5. Click **SAVE & RESTART**

### Step 4: Check for Errors (30 seconds)
Watch the console. Should say:
```
Klipper state: Ready
```

If error appears → **Stop and paste error in chat**

If "Ready" → Continue to Step 5 ✅

---

## AT THE PRINTER (Next 10 Minutes)

### Step 5: Verify Probe Connection (1 minute)
In Mainsail console:
```gcode
QUERY_PROBE
```

**Expected:** `probe: open`  
**If not:** Check Eddy cable connection

### Step 6: Calibrate Z-Offset (5 minutes)
```gcode
G28
Z_OFFSET_CALIBRATION
```

**Follow paper test prompts:**
- Paper between nozzle and bed
- Adjust until light drag
- Save when done

### Step 7: Level Gantry (2 minutes)
```gcode
G28
QUAD_GANTRY_LEVEL
G28 Z
```

Should complete without errors.

### Step 8: Capture Bed Mesh (5 minutes)
```gcode
BED_MESH_CALIBRATE
```

**Wait for completion** (41×41 = 1681 points)  
**Don't interrupt!**

When done:
```gcode
SAVE_CONFIG
```

---

## FIRST TEST PRINT (Next 30 Minutes)

### Step 9: Slice a Test Cube
- Use your normal profile
- 20mm calibration cube
- 0.2mm layer height
- Normal temps

### Step 10: Start Print
- Watch first layer closely
- Should be **glassy smooth**
- No gaps, no elephant's foot

### Step 11: Celebrate 🎉
If first layer is perfect → **Eddy is working!**

---

## IF SOMETHING GOES WRONG

### "Unknown i2c_bus" error
→ Double-check you used the **fixed** `printer.cfg` with `i2c_bus: i2c1_PB6_PB7`

### "probe: TRIGGERED" when it shouldn't be
→ Z-offset too low. Increase `z_offset` in config by 0.5mm

### "Failed to connect to probe"
→ Check physical cable connection on printhead

### First layer too close/too far
→ Adjust with:
```gcode
SET_GCODE_OFFSET Z=+0.05    # Raise
SET_GCODE_OFFSET Z=-0.05    # Lower
```

### Mesh takes forever
→ **Normal!** 41×41 = ~5 minutes. Be patient.

---

## TOTAL TIME ESTIMATE

- Config upload: **2 minutes**
- Calibration: **12 minutes**
- First print: **30 minutes**

**Total: ~45 minutes from start to first successful print**

---

## SUCCESS CHECKLIST

- [x] Config uploaded without errors
- [x] `QUERY_PROBE` returns "open"
- [x] Z-offset calibrated
- [x] QGL completed
- [x] 41×41 mesh captured
- [x] Test print first layer perfect
- [x] Test print completed successfully

**All checked?** → Eddy is fully operational! 🚀

---

## ONE-LINE SUMMARY

**The fix:** Change `i2c_bus: i2c1` to `i2c_bus: i2c1_PB6_PB7` → Then calibrate Z-offset → Done.

That's literally it. The rest was already correct! 🎯
