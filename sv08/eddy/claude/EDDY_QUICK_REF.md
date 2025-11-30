# Eddy Sensor Quick Reference

## Quick Calibration Commands

### 1. Initial Setup (After Installing Config)
```gcode
RESTART                          # Restart Klipper firmware
QUERY_PROBE                      # Should return "probe: open"
```

### 2. Z-Offset Calibration
```gcode
G28                              # Home all axes
Z_OFFSET_CALIBRATION            # Auto calibration routine
```

**OR Manual Method:**
```gcode
G28
G1 X175 Y175 F9000              # Move to bed center
PROBE_CALIBRATE
TESTZ Z=-0.1                    # Move down 0.1mm
TESTZ Z=+0.05                   # Move up 0.05mm
ACCEPT                           # When paper drag feels right
SAVE_CONFIG                      # Save the offset
```

### 3. Gantry Leveling
```gcode
G28                              # Home first
QUAD_GANTRY_LEVEL               # Level gantry
G28 Z                            # Re-home Z after QGL
```

### 4. Bed Mesh (41x41 points)
```gcode
G28
QUAD_GANTRY_LEVEL               # Always QGL before meshing
BED_MESH_CALIBRATE              # Full 41x41 mesh (~5 min)
SAVE_CONFIG                      # Save the mesh
```

### 5. Quick Check
```gcode
QUERY_PROBE                      # Should be "open" when not triggered
G28 Z                            # Should home smoothly
```

---

## Common Issues & Quick Fixes

| Problem | Quick Fix |
|---------|-----------|
| "Unknown i2c_bus" | Use `i2c_bus: i2c1_PB6_PB7` not just `i2c1` |
| "probe: TRIGGERED" | Z-offset too low, increase by 0.5mm |
| "Failed to connect" | Check Eddy cable connection on printhead |
| Mesh takes forever | 41x41 = 1681 points, it's normal! (~5 min) |
| Inconsistent probing | Recalibrate: `LDC_CALIBRATE_DRIVE_CURRENT CHIP=eddy` |

---

## Config Line to Change

**ONLY ONE LINE NEEDED TO BE CHANGED:**

```yaml
# OLD (caused error):
i2c_bus: i2c1

# NEW (fixed):
i2c_bus: i2c1_PB6_PB7
```

That's it! Everything else in your Eddy config was correct.

---

## Mesh Settings Comparison

| Setting | Old Contact | New Eddy |
|---------|------------|----------|
| Points | 9x9 (81) | 41x41 (1681) |
| Speed | 5 mm/s | 400 mm/s |
| Z-height | 5mm | 1.5mm |
| Time | ~2 min | ~5 min |

---

## After Calibration Test

```gcode
G28
QUAD_GANTRY_LEVEL
BED_MESH_CALIBRATE
G28 Z
G1 Z5 F600
G1 X175 Y175 F9000
```

If all commands complete without errors = **You're good to print!** ✅
