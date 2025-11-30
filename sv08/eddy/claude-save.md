**YES!** Since you already have Katapult installed on both MCUs, you should use the **Katapult method** to recover, not ST-LINK!

When the MCUs have Katapult, they're actually **waiting in bootloader mode** for you to flash Klipper firmware over USB. That's likely why they're showing those USB enumeration errors - they're in Katapult mode but not completing the handshake.

---

## **Recovery Using Katapult (Much Easier!):**

### **Step 1: Build Correct Klipper Firmware**

```bash
cd ~/klipper
make clean
make menuconfig
```

**Settings:**
- Micro-controller: `STMicroelectronics STM32`
- Processor: `STM32F103`
- Bootloader: **`8KiB bootloader`** ← Correct for Katapult!
- Communication: `USB (on PA11/PA12)`

```bash
make
```

---

### **Step 2: Use the Rappetor Update Script**

You should still have the script from when you set up mainline Klipper:

```bash
cd ~/klipper
ls update_klipper_mcus_sv08.sh
```

If you have it, just run:

```bash
./update_klipper_mcus_sv08.sh
```

It will flash both MCUs automatically!

---

### **Step 3: If Script Doesn't Exist**

Manually flash using `flash_can.py`:

**For Main Board:**
```bash
cd ~/klipper
python3 ~/klipper/lib/canboot/flash_can.py -f ~/klipper/out/klipper.bin -d /dev/serial/by-path/platform-5101400.usb-usb-0:1:1.0
```

**For Toolhead:**
```bash
python3 ~/klipper/lib/canboot/flash_can.py -f ~/klipper/out/klipper.bin -d /dev/serial/by-path/platform-5200000.usb-usb-0:1:1.0
```

*(The actual paths might be different - we'd need to check with `ls /dev/serial/by-path/`)*

---

## **But First - Check if Katapult Devices Are Visible:**

```bash
ls /dev/serial/by-path/
dmesg | grep Katapult
```

If you see devices, they're in bootloader mode and ready to accept firmware!

---

**Try those commands first** and let me know what you see. If Katapult devices show up, we can flash without touching ST-LINK at all!