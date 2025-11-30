# Configuration Changes: Contact Probe → Eddy Sensor

## Summary
**ONE LINE FIXED** the error. The rest of the changes were already done correctly.

---

## The Fix (The Important Part!)

### ❌ OLD Config (Caused Error)
```yaml
[probe_eddy_current eddy]
sensor_type: ldc1612
z_offset: 3.1
i2c_mcu: extra_mcu
i2c_bus: i2c1                    # ❌ ERROR: Unknown i2c_bus 'i2c1_PB6_PB7'
x_offset: -16.43
y_offset: 10.22
vir_contact_speed: 2.8
```

### ✅ FIXED Config
```yaml
[probe_eddy_current eddy]
sensor_type: ldc1612
z_offset: 3.1
i2c_mcu: extra_mcu
i2c_bus: i2c1_PB6_PB7           # ✅ FIXED: Mainline Klipper needs full pin spec
x_offset: -16.43
y_offset: 10.22
vir_contact_speed: 2.8
```

**Why?** Mainline Klipper requires the actual hardware pins (PB6=SCL, PB7=SDA) instead of just "i2c1".

---

## Other Sections That Changed (Already Correct in Your Config)

### 1. Removed Old Contact Probe

#### ❌ OLD: Contact Probe Section (REMOVED)
```yaml
[probe]
pin: extra_mcu:PB6              # Old mechanical probe on PB6
x_offset: -17                  
y_offset: 10             
z_offset : 0
speed: 5.0
samples: 3
sample_retract_dist: 2.0
lift_speed: 50
samples_result: average
samples_tolerance: 0.016
samples_tolerance_retries: 2
```

#### ✅ NEW: Eddy Current Probe (KEPT)
```yaml
[probe_eddy_current eddy]       # Non-contact inductive sensor
sensor_type: ldc1612
z_offset: 3.1
i2c_mcu: extra_mcu
i2c_bus: i2c1_PB6_PB7          # Uses I2C, not GPIO pin
x_offset: -16.43
y_offset: 10.22
vir_contact_speed: 2.8
```

---

### 2. Updated Bed Mesh Settings

#### ❌ OLD: Basic 9x9 Mesh
```yaml
[bed_mesh]
speed: 500                   
horizontal_move_z: 5             # High for contact probe clearance
mesh_min: 10,10              
mesh_max: 333,340            
probe_count: 9,9                 # 81 points
algorithm: bicubic   
bicubic_tension: 0.4
split_delta_z: 0.016
mesh_pps:3,3
adaptive_margin: 5
fade_start: 1
fade_end: 10
fade_target: 0
```

#### ✅ NEW: High-Density 41x41 Mesh
```yaml
[bed_mesh]
speed: 400
horizontal_move_z: 1.5           # Lower - Eddy doesn't touch bed
algorithm: bicubic 
mesh_min: 13,15             
mesh_max: 333,340 
probe_count: 41,41               # 1681 points! 🔥
fade_start: 0                    # Removed fade_target
fade_end: 10
scan_overshoot: 4                # New for continuous scanning
```

**Why 41x41?** Eddy can scan continuously, so more points = better accuracy without significant time penalty.

---

### 3. Updated Z-Offset Calibration

#### ❌ OLD: Contact Probe Calibration
```yaml
[z_offset_calibration]
center_xy_position:191,165       # Where probe measures
endstop_xy_position:289,361      # Where physical endstop is
z_hop: 10                       
z_hop_speed: 15
```

#### ✅ NEW: Eddy Calibration
```yaml
[z_offset_calibration]
non_contact_probe:probe_eddy_current eddy  # Specifies Eddy for non-contact
contact_probe:probe_eddy_current eddy      # Eddy can also do contact mode
endstop_xy_position: 175,175               # Simplified - probe at bed center
z_hop: 5                                   # Lower hop (was 10)
z_hop_speed: 10
internal_endstop_offset: -0.26             # Internal calibration value
```

---

### 4. Updated Homing Override

#### Notable Changes:
```yaml
# OLD: Used probe for Z homing at center
G0  X191 Y165 F3600              # Old center position

# NEW: Uses Eddy at center  
G0  X191 Y165 F3600              # Still centers, but now with Eddy
```

No significant changes needed - homing logic stays the same, just uses Eddy instead of contact probe.

---

### 5. Printer Performance Settings

#### Performance Boost Opportunity
```yaml
[printer]
kinematics: corexy           
max_velocity: 700
max_accel: 40000                 # You had this reduced to 10000
max_accel_to_decel: 10000        # Was missing in old config   
max_z_velocity: 20           
max_z_accel: 500             
square_corner_velocity: 5.0
```

**Note:** With Eddy's consistent probing, you could potentially return to `max_accel: 40000` for faster prints, since Eddy eliminates the slight variations from physical probe contact.

---

### 6. Input Shaper (Interesting Change!)

#### ❌ OLD: Moderate Damping
```yaml
[input_shaper]
damping_ratio_x: .1
damping_ratio_y: .1
shaper_freq_x = 40.2
shaper_freq_y = 38.0
```

#### ✅ NEW: Minimal Damping
```yaml
[input_shaper]
damping_ratio_x: 0.001           # Nearly zero damping!
damping_ratio_y: 0.001
# Frequencies will be auto-populated after calibration
```

**Why?** This suggests you'll need to **re-run input shaper calibration** with the Eddy installed, as the different weight/resonance characteristics might affect the optimal shaper values.

---

## Files That DON'T Need Changes

✅ **Macro.cfg** - All your macros work fine
✅ **moonraker.conf** - No changes needed
✅ **mainsail.cfg** - No changes needed  
✅ **crowsnest.conf** - Camera config unaffected

---

## Post-Installation TODO

1. ✅ Upload fixed `printer.cfg`
2. ⚠️ **Z-offset calibration required** (current `3.1` is placeholder)
3. ⚠️ **Re-run input shaper** (damping ratios changed to 0.001)
4. ⚠️ **Capture new bed mesh** (41x41 points)
5. ⚠️ **Test print** to verify first layer
6. ✅ Save new defaults

---

## Key Takeaway

**The error was simple**: Mainline Klipper needs `i2c_bus: i2c1_PB6_PB7` instead of just `i2c1`.

Everything else was already configured correctly for the Eddy sensor. You just need to calibrate the Z-offset and capture a new mesh!
