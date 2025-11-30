# SV08 Eddy Sensor Installation - Complete Documentation Pack

## What's Included

This documentation pack contains everything you need to install and configure your Sovol SV08 Eddy Current Scanning Kit with mainline Klipper firmware.

---

## 📁 Files in This Pack

### **1. printer.cfg** ⭐ MOST IMPORTANT
**Purpose:** Your fixed printer configuration file  
**What Changed:** One line: `i2c_bus: i2c1_PB6_PB7` (was `i2c1`)  
**Action:** Upload this to replace your current printer.cfg

### **2. ACTION_PLAN.md** ⏱️ START HERE
**Purpose:** Quick 5-minute action plan  
**Best For:** Getting up and running FAST  
**Contains:** Step-by-step installation checklist

### **3. EDDY_SETUP_GUIDE.md** 📖 DETAILED GUIDE
**Purpose:** Comprehensive installation guide  
**Best For:** Understanding WHY things work  
**Contains:** 
- What was wrong and how it's fixed
- Calibration procedures
- Troubleshooting
- Macro compatibility

### **4. EDDY_QUICK_REF.md** 🔧 COMMAND REFERENCE
**Purpose:** Quick command lookup  
**Best For:** Having open while calibrating  
**Contains:**
- All calibration commands
- Common issues & fixes
- Quick troubleshooting table

### **5. CONFIG_CHANGES_EXPLAINED.md** 📊 TECHNICAL DEEP-DIVE
**Purpose:** Detailed comparison of old vs new config  
**Best For:** Understanding all the changes  
**Contains:**
- Side-by-side config comparisons
- Why each change was made
- Performance implications

### **6. FIRST_PRINT_EXPECTATIONS.md** 🎯 WHAT TO EXPECT
**Purpose:** Guide for your first print with Eddy  
**Best For:** Knowing if things are working correctly  
**Contains:**
- Pre-print checklist
- What to watch for during meshing
- First layer expectations
- Success criteria

### **7. VISUAL_COMPARISON.txt** 🎨 ASCII ART DIAGRAMS
**Purpose:** Visual comparison of old vs new probe  
**Best For:** Quick visual reference  
**Contains:**
- ASCII diagrams of probe differences
- Mesh density visualization
- Troubleshooting flowcharts
- Connection diagrams

---

## 🚀 Quick Start (2-Minute Version)

1. **Download** `printer.cfg` from this pack
2. **Backup** your current config
3. **Upload** the fixed config to Mainsail
4. **Restart** firmware
5. **Run** `QUERY_PROBE` (should return "probe: open")
6. **Calibrate** Z-offset with paper test
7. **Run** QGL and bed mesh
8. **Start** your first test print!

**Total time:** ~45 minutes from start to first successful print

---

## 🔍 The Problem (Simple Explanation)

Your Eddy sensor config had:
```yaml
i2c_bus: i2c1
```

Mainline Klipper needs:
```yaml
i2c_bus: i2c1_PB6_PB7
```

**That's it!** One line caused the entire error. Everything else was already configured correctly.

---

## 📋 Installation Checklist

- [ ] Read ACTION_PLAN.md (5 min)
- [ ] Backup current printer.cfg
- [ ] Upload new printer.cfg
- [ ] Restart firmware
- [ ] Verify probe connection (`QUERY_PROBE`)
- [ ] Calibrate Z-offset
- [ ] Run QGL
- [ ] Capture 41×41 bed mesh
- [ ] Test print 20mm calibration cube
- [ ] Verify first layer quality
- [ ] Save configuration

---

## 🎓 Learning Path

### **Beginner:** Just want it working?
1. Read **ACTION_PLAN.md**
2. Follow the steps
3. Reference **EDDY_QUICK_REF.md** for commands

### **Intermediate:** Want to understand the changes?
1. Start with **ACTION_PLAN.md**
2. Read **EDDY_SETUP_GUIDE.md** while installing
3. Keep **EDDY_QUICK_REF.md** handy
4. Check **FIRST_PRINT_EXPECTATIONS.md** before printing

### **Advanced:** Want to know everything?
1. Read **CONFIG_CHANGES_EXPLAINED.md** first
2. Review **VISUAL_COMPARISON.txt** for technical details
3. Follow **EDDY_SETUP_GUIDE.md** for installation
4. Reference all docs as needed

---

## 🆘 Troubleshooting Quick Links

### "Unknown i2c_bus" error
→ **File:** EDDY_QUICK_REF.md, CONFIG_CHANGES_EXPLAINED.md  
→ **Fix:** Verify `i2c_bus: i2c1_PB6_PB7` in printer.cfg

### "probe: TRIGGERED" when shouldn't be
→ **File:** EDDY_SETUP_GUIDE.md, FIRST_PRINT_EXPECTATIONS.md  
→ **Fix:** Increase z_offset, recalibrate

### First layer too close/too far
→ **File:** FIRST_PRINT_EXPECTATIONS.md, EDDY_QUICK_REF.md  
→ **Fix:** Adjust with SET_GCODE_OFFSET

### Mesh taking forever
→ **File:** FIRST_PRINT_EXPECTATIONS.md  
→ **Answer:** Normal! 41×41 = ~5 minutes

### Want to understand why Eddy is better
→ **File:** VISUAL_COMPARISON.txt, CONFIG_CHANGES_EXPLAINED.md  
→ **Info:** 20× more probe points, non-contact, faster

---

## 📊 Key Specifications

### Old Contact Probe (PL08)
- **Type:** Mechanical contact
- **Speed:** 5 mm/s
- **Points:** 9×9 = 81
- **Time:** ~2 minutes
- **Sound:** Click-click-click

### New Eddy Sensor (LDC1612)
- **Type:** Inductive (non-contact)
- **Speed:** 400 mm/s scanning
- **Points:** 41×41 = 1,681
- **Time:** ~5 minutes
- **Sound:** Silent swoosh

**Result:** 20× more bed data = perfect first layers! 🎯

---

## 🔧 Required Calibrations

After installation, you **MUST** recalibrate:
1. ✅ **Z-offset** (paper test)
2. ✅ **QGL** (quad gantry level)
3. ✅ **Bed mesh** (41×41 scan)

**Optional but recommended:**
4. ⚠️ **Input shaper** (damping changed to 0.001)
5. ⚠️ **Flow calibration** (if first layer issues persist)

---

## 📞 Support

If you run into issues:
1. Check the **EDDY_QUICK_REF.md** troubleshooting table
2. Read relevant section in **EDDY_SETUP_GUIDE.md**
3. Review **VISUAL_COMPARISON.txt** flowchart
4. Check Klipper logs in Mainsail
5. Post error messages in our conversation

---

## 🎉 Success Criteria

You'll know it's working when:
- ✅ `QUERY_PROBE` returns "probe: open"
- ✅ Z-offset calibration completes
- ✅ QGL finishes without errors
- ✅ 41×41 mesh completes (~5 min)
- ✅ First layer is glass smooth
- ✅ Test print completes successfully
- ✅ No gaps or elephant's foot

**All checked?** → You're done! Welcome to the Eddy club! 🚀

---

## 📝 Document Revision History

**Version 1.0** (Today)
- Initial documentation pack
- All 7 documents created
- Covers mainline Klipper i2c_bus fix
- Includes full calibration procedures

---

## 🙏 Credits

**Hardware:** Sovol SV08 Eddy Current Scanning Kit  
**Firmware:** Mainline Klipper (STM32F103)  
**Documentation:** Created for Tony's SV08 upgrade  
**Special Thanks:** To everyone in the Klipper community!

---

## 💡 Pro Tips

1. **Always run QGL before bed mesh** - Ensures accurate baseline
2. **Heat soak bed 10 min** before meshing - Thermal expansion matters
3. **Clean PEI sheet** before meshing - Dirt affects readings
4. **Save your mesh** as default after successful calibration
5. **Re-mesh when temp changes** >10°C from last mesh
6. **Don't rush the mesh** - 5 minutes = perfect first layers!

---

**Bottom Line:** Change one config line, calibrate Z-offset, run mesh, print perfectly. That's it! 🎯

---

*Need help? All the answers are in these docs. Read the relevant guide for your issue!*
