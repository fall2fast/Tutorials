# Motor Testing - ESPHome Setup

## Project Overview

Yeah, that test config is still perfectly fine for testing just Motor 1! It's actually better to start simple like this.

**For your first test with the new ESP32, I'd recommend:**

Keep using this simple test config to verify:
1. The new ESP32 works
2. Motor 1 spins properly
3. All your wiring is solid and safe

**Motor 1 Test Config:**

```yaml
esphome:
  name: poop-conveyor
  friendly_name: poop-conveyor

esp32:
  board: esp32dev
  framework:
    type: esp-idf

# Enable logging
logger:

# Enable Home Assistant API
api:
  encryption:
    key: "4kJlwdtyw63DFfIaE76x8UGKPyFNgt4v7U8qw2WuxpA="

ota:
  - platform: esphome
    password: "d9a0121e0d8d5c4c7cb123cfdc0c3231"

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  ap:
    ssid: "Poop-Conveyor Fallback Hotspot"
    password: "ZKdTVtErUNSY"

captive_portal:

web_server:
  port: 80

## Motor 1 control
output:
  - platform: ledc
    pin: GPIO18
    id: motor1_ena
    frequency: 500 Hz
    inverted: false

switch:
  # Direction pins
  - platform: gpio
    pin: GPIO19
    id: motor1_in1
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO21
    id: motor1_in2
    restore_mode: ALWAYS_OFF

  # Motor enable (THIS is the important change)
  - platform: output
    name: "Test Motor"
    output: motor1_ena
    restore_mode: ALWAYS_OFF
    on_turn_on:
      - switch.turn_on: motor1_in1
      - switch.turn_off: motor1_in2
      - output.set_level:
          id: motor1_ena
          level: 1.0
    on_turn_off:
      - output.set_level:
          id: motor1_ena
          level: 0.0
      - switch.turn_off: motor1_in1
      - switch.turn_off: motor1_in2

```


**Then once Motor 1 is confirmed working, add Motor 2 testing:**

```yaml
# Add this to your existing test config

# Motor 2 speed control
output:
  - platform: ledc
    pin: GPIO23
    id: motor2_enb
    frequency: 500 Hz
    inverted: false

switch:
  - platform: gpio
    pin: GPIO22
    id: motor2_in3
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO17
    id: motor2_in4
    restore_mode: ALWAYS_OFF

  - platform: output
    name: "Test Motor 2"
    output: motor2_enb
    restore_mode: ALWAYS_OFF
    on_turn_on:
      - switch.turn_on: motor2_in3
      - switch.turn_off: motor2_in4
      - output.set_level:
          id: motor2_enb
          level: 1.0
    on_turn_off:
      - output.set_level:
          id: motor2_enb
          level: 0.0
      - switch.turn_off: motor2_in3
      - switch.turn_off: motor2_in4

```

**My recommendation:** 
- Start with your simple config for Motor 1
- Test it thoroughly
- Once you're confident, upgrade to the full config with all sensors

This way if something goes wrong, you know exactly where the problem is!
