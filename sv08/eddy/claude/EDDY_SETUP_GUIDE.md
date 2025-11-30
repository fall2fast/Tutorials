# SV08 Eddy Current Sensor Installation Guide

## What Was Wrong

Your config had:
```yaml
i2c_bus: i2c1
```

But mainline Klipper needs the **full pin specification**:
```yaml
i2c_bus: i2c1_PB6_PB7
```

This is because mainline Klipper explicitly requires the SCL and SDA pins to be specified, while Sovol's fork used a simplified naming scheme.

---

## Configuration Changes Made

### 1. Fixed I2C Bus Declaration

**In `[probe_eddy_current eddy]` section:**

```yaml
[probe_eddy_current eddy]
sensor_type: ldc1612
z_offset: 3.1                    # This will need calibration!
i2c_mcu: extra_mcu
i2c_bus: i2c1_PB6_PB7           # ✅ FIXED - was just "i2c1"
x_offset: -16.43
y_offset: 10.22
vir_contact_speed: 2.8
```

**Why these pins?**
- PB6 = I2C1_SCL (clock line)
- PB7 = I2C1_SDA (data line)
- These are the hardware I2C1 pins on the STM32F103 printhead board

---

## Installation Steps

### Step 1: Upload the Fixed Config

1. **Backup your current config** (you already have `original-printer.cfg`)
2. Download the fixed `printer.cfg` from this conversation
3. Upload it to replace your current `/home/biqu/printer_data/config/printer.cfg`
4. In Mainsail, click **"RESTART FIRMWARE"**

### Step 2: Verify Connection

In the Mainsail console, run:
```gcode
QUERY_PROBE
```

**Expected output:**
```
probe: open
```

If you get an error about I2C communication, check:
- Eddy sensor cable is fully seated in the printhead connector
- Printhead board ribbon cable is secure
- No physical damage to cables

---

## Calibration Required After Installation

### 1. Z-Offset Calibration

The `z_offset: 3.1` in your config is just a starting point. You **MUST** recalibrate:

```gcode
G28                              # Home all axes
Z_OFFSET_CALIBRATION            # Start calibration routine
```

**Or manually:**
```gcode
G28                              # Home
G1 Z10 F600                     # Raise nozzle
G1 X175 Y175 F9000              # Move to center
PROBE_CALIBRATE                  # Start manual calibration
```

Then use paper test to dial in the offset:
- `TESTZ Z=-0.1` to move down
- `TESTZ Z=+0.1` to move up
- When paper has slight drag: `ACCEPT` then `SAVE_CONFIG`

### 2. Bed Mesh

Your new mesh settings are **already optimized for Eddy**:

```yaml
[bed_mesh]
speed: 400
horizontal_move_z: 1.5          # Much lower than contact probe!
mesh_min: 13,15             
mesh_max: 333,340 
probe_count: 41,41              # 🔥 1681 points! Super detailed mesh
fade_start: 0
fade_end: 10
scan_overshoot: 4
```

After Z-offset calibration, run:
```gcode
G28
BED_MESH_CALIBRATE
```

This will take **longer than your old 9x9 mesh** (41x41 = 1681 points) but will be MUCH more accurate.

### 3. QGL (Quad Gantry Level)

Run QGL to ensure gantry is level before meshing:
```gcode
G28
QUAD_GANTRY_LEVEL
G28 Z
```

---

## Key Differences: Eddy vs Contact Probe

| Feature | Old Contact Probe | New Eddy Sensor |
|---------|------------------|-----------------|
| **Speed** | 5 mm/s | Much faster (~400mm/s) |
| **Z height** | 5mm | 1.5mm (non-contact) |
| **Mesh density** | 9x9 (81 points) | 41x41 (1681 points) |
| **Accuracy** | ±0.016mm | Higher precision |
| **Temperature drift** | Some drift | Minimal |
| **Scanning** | Point-by-point | Continuous scanning |

---

## Startup Sequence Changes

### Old (Contact Probe) Sequence:
```
Home → QGL → Bed Mesh (9x9) → Heat nozzle → Print
```

### New (Eddy) Sequence:
```
Home → QGL → Detailed Mesh (41x41) → Heat nozzle → Print
```

**Time comparison:**
- Old 9x9 mesh: ~2-3 minutes
- New 41x41 mesh: ~4-6 minutes (but MUCH better quality)

---

## Your START_PRINT Macro

Your `START_PRINT` macro in `Macro.cfg` **should work fine** with Eddy. It already includes:

```python
{% if printer.quad_gantry_level.applied|lower != 'true' %}
    QUAD_GANTRY_LEVEL
{% endif %}
BED_MESH_CALIBRATE ADAPTIVE=1
```

The adaptive meshing will work great with Eddy's fast scanning!

---

## Troubleshooting

### Error: "probe: TRIGGERED"

If `QUERY_PROBE` shows "triggered" when the probe is NOT touching:

1. Check the `z_offset` is positive (it should be ~2-4mm)
2. Verify sensor is getting power (small LED on sensor board)
3. Check I2C communication: `LDC_CALIBRATE_DRIVE_CURRENT CHIP=eddy`

### Error: "Failed to connect to probe"

- Check `i2c_bus: i2c1_PB6_PB7` is correct in config
- Verify printhead cable is fully seated
- Ensure Eddy sensor cable is connected to correct port on printhead

### Error: "Probe triggered prior to movement"

- Z-offset is too low
- Increase `z_offset` by 0.5mm increments
- Recalibrate with paper test

---

## After Installation Checklist

- [ ] Config uploaded and firmware restarted
- [ ] `QUERY_PROBE` returns "probe: open"
- [ ] Z-offset calibrated with paper test
- [ ] QGL completed successfully
- [ ] First bed mesh captured (41x41)
- [ ] Test print started and first layer looks good
- [ ] Save new mesh with `BED_MESH_PROFILE SAVE=default`

---

## Macro.cfg Compatibility

Your `CLEAN_NOZZLE` macro **still works** - it's independent of the probe system.

Your `START_PRINT` macro is **already compatible** - no changes needed!

---

## Final Notes

The Eddy sensor is a **huge upgrade** from the contact probe:
- **Faster probing** (400mm/s vs 5mm/s)
- **More accurate** (41x41 vs 9x9 mesh)
- **No physical contact** (less wear, no nozzle deflection)
- **Better first layers** due to detailed mesh

After calibration, you should see noticeably better first layer consistency, especially on large prints!

---

## Need Help?

If you run into issues:
1. Check Klipper logs in Mainsail (⚙️ → System → Download Logs)
2. Post error messages in our conversation
3. Double-check cable connections
4. Verify the Eddy sensor LED is lit when homed

Happy printing! 🎉
