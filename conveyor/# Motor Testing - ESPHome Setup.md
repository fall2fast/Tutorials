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

# Motor speed control (PWM)
output:
  - platform: ledc
    pin: GPIO13
    id: motor1_speed
    frequency: 1000 Hz

# Motor direction and control
switch:
  # Motor 1 main control
  - platform: template
    name: "Test Motor"
    id: motor1_switch
    turn_on_action:
      - output.turn_on: motor1_speed
      - output.set_level:
          id: motor1_speed
          level: 100%
      - switch.turn_on: motor1_in1
      - switch.turn_off: motor1_in2
    turn_off_action:
      - output.turn_off: motor1_speed
      - switch.turn_off: motor1_in1
      - switch.turn_off: motor1_in2
  
  # Motor 1 direction pins
  - platform: gpio
    pin: GPIO12
    id: motor1_in1
    internal: true
    
  - platform: gpio
    pin: GPIO15
    id: motor1_in2
    internal: true
```


**Then once Motor 1 is confirmed working, add Motor 2 testing:**

```yaml
# Add this to your existing test config

# Motor 2 speed control
output:
  - platform: ledc
    pin: GPIO13
    id: motor1_speed
    frequency: 1000 Hz
    
  - platform: ledc
    pin: GPIO23
    id: motor2_speed
    frequency: 1000 Hz

# Motor controls
switch:
  # Motor 1 (keep what you have)
  - platform: template
    name: "Test Motor 1"
    id: motor1_switch
    turn_on_action:
      - output.turn_on: motor1_speed
      - output.set_level:
          id: motor1_speed
          level: 100%
      - switch.turn_on: motor1_in1
      - switch.turn_off: motor1_in2
    turn_off_action:
      - output.turn_off: motor1_speed
      - switch.turn_off: motor1_in1
      - switch.turn_off: motor1_in2
  
  - platform: gpio
    pin: GPIO12
    id: motor1_in1
    internal: true
    
  - platform: gpio
    pin: GPIO15
    id: motor1_in2
    internal: true
  
  # Motor 2 (add this)
  - platform: template
    name: "Test Motor 2"
    id: motor2_switch
    turn_on_action:
      - output.turn_on: motor2_speed
      - output.set_level:
          id: motor2_speed
          level: 100%
      - switch.turn_on: motor2_in3
      - switch.turn_off: motor2_in4
    turn_off_action:
      - output.turn_off: motor2_speed
      - switch.turn_off: motor2_in3
      - switch.turn_off: motor2_in4
  
  - platform: gpio
    pin: GPIO22
    id: motor2_in3
    internal: true
    
  - platform: gpio
    pin: GPIO21
    id: motor2_in4
    internal: true
```

**My recommendation:** 
- Start with your simple config for Motor 1
- Test it thoroughly
- Once you're confident, upgrade to the full config with all sensors

This way if something goes wrong, you know exactly where the problem is!
