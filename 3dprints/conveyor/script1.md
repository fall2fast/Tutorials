This is something I wanted to save, this is not the final version. I just do not want to lose track of the project.

---

## 🐍 Part 1: Python Script (Poop Detector v0.1)

This script is designed to:

* Monitor an **IR sensor** for poop detection
* Trigger a **motor** via GPIO pin
* Run it for a set duration, then stop
* Optional: add second sensor for confirmation or a lockout period

```python
# poop_detector.py
import RPi.GPIO as GPIO
import time

# === CONFIGURATION ===
SENSOR_PIN = 17      # IR sensor input (e.g., TCRT5000 OUT)
MOTOR_PIN = 18       # Output to relay or MOSFET
RUN_TIME = 4         # Motor run time in seconds
DEBOUNCE_DELAY = 1   # Minimum delay between triggers

# === SETUP ===
GPIO.setmode(GPIO.BCM)
GPIO.setup(SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(MOTOR_PIN, GPIO.OUT)
GPIO.output(MOTOR_PIN, GPIO.LOW)

print("Poop detection system armed...")

try:
    while True:
        if GPIO.input(SENSOR_PIN) == 0:  # Beam broken
            print("💩 Poop detected - running motor")
            GPIO.output(MOTOR_PIN, GPIO.HIGH)
            time.sleep(RUN_TIME)
            GPIO.output(MOTOR_PIN, GPIO.LOW)
            print("Motor stopped. Waiting for next detection...")
            time.sleep(DEBOUNCE_DELAY)  # Prevent rapid retrigger
        time.sleep(0.1)  # Polling delay

except KeyboardInterrupt:
    print("Shutting down...")
    GPIO.cleanup()
```

🔧 You can test this with just an LED or multimeter on the motor output if the conveyor isn’t wired yet.

---

## 🔌 Part 2: Wiring Diagram (Text-based until I render a visual)

```
      Raspberry Pi 4 (GPIO view)
     +-------------------------+
     | 3.3V       (1) (2)  5V  |
     | GPIO2/SDA  (3) (4)  5V  |
     | GPIO3/SCL  (5) (6)  GND |
     | GPIO4      (7) (8)  TXD |
     | GND        (9) (10) RXD|
     | GPIO17 <-- IR sensor   |
     | GPIO18 --> Relay / MOSFET (motor control) |
     +-------------------------+

 IR Sensor:
   - VCC → Pi 3.3V or 5V
   - GND → Pi GND
   - OUT → Pi GPIO17

 Relay:
   - IN → Pi GPIO18
   - VCC → Pi 5V
   - GND → Pi GND
   - COM → 12V PSU (+) to motor
   - NO → motor +
   - motor – → 12V PSU (–)
```

Or if you're using a logic-level MOSFET instead of relay:

* GPIO18 → 220Ω resistor → MOSFET gate
* Source → GND
* Drain → Motor –
* Motor + → 12V +
* Add **1N4007 diode** across motor (band toward +)

---

### 🔁 Next Steps:

* Want me to draw a proper circuit diagram (PNG or SVG)?
* Should we add a second IR sensor now or later?
* Want to include optional LED status indicator (on = poop running)?

Let’s keep it moving — this is going to be a sweet setup.
