Final config 2

Yep — here’s **your exact YAML rewritten** with the automation added, so you can copy/paste the whole thing and not touch individual blocks.

What it does (exactly as you asked):

* **Motor 1** runs **3 seconds** when **P2S AND P1S** are ON (beam broken)
* **Motor 2** runs **3 seconds** when **P1S AND Conveyor 1 Exit** are ON
* It triggers from **either beam in the pair**, so it works no matter which beam breaks first
* Uses `script` with `mode: restart` so repeated triggers just restart the timer (no stacking)

✅ Since you confirmed: **beam break shows ON**, this will work with your existing `inverted: true`.

---

```yaml
esphome:
  name: poop-conveyor
  friendly_name: poop-conveyor

esp32:
  board: esp32dev
  framework:
    type: esp-idf

logger:

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

# ------------------------------------------------------------
# MOTORS (L298N)
# Channel A (Motor 1): ENA / IN1 / IN2
# Channel B (Motor 2): ENB / IN3 / IN4
# NOTE: ENA/ENB jumpers MUST be removed on the L298N board.
# ------------------------------------------------------------

output:
  # Motor 1 enable (ENA)
  - platform: ledc
    pin: GPIO18
    id: motor1_ena
    frequency: 500 Hz
    inverted: false

  # Motor 2 enable (ENB)
  - platform: ledc
    pin: GPIO23
    id: motor2_enb
    frequency: 500 Hz
    inverted: false

switch:
  # Motor 1 direction pins
  - platform: gpio
    pin: GPIO19
    id: motor1_in1
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO21
    id: motor1_in2
    restore_mode: ALWAYS_OFF

  # Motor 1 main control
  - platform: output
    name: "Conveyor 1 Motor"
    id: motor1_switch
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

  # Motor 2 direction pins
  - platform: gpio
    pin: GPIO22
    id: motor2_in3
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO17
    id: motor2_in4
    restore_mode: ALWAYS_OFF

  # Motor 2 main control
  - platform: output
    name: "Conveyor 2 Motor"
    id: motor2_switch
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

# ------------------------------------------------------------
# AUTOMATION SCRIPTS
# Change the delay values if you want longer/shorter runs.
# ------------------------------------------------------------

script:
  - id: run_motor1_short
    mode: restart
    then:
      - switch.turn_on: motor1_switch
      - delay: 3s
      - switch.turn_off: motor1_switch

  - id: run_motor2_short
    mode: restart
    then:
      - switch.turn_on: motor2_switch
      - delay: 3s
      - switch.turn_off: motor2_switch

# ------------------------------------------------------------
# BEAM SENSORS (Break-beam receivers)
# Beam break shows ON (as you confirmed), so this logic is correct.
# Motor rules:
#  - Motor 1: P2S AND P1S must both be ON
#  - Motor 2: P1S AND Conveyor 1 Exit must both be ON
# ------------------------------------------------------------

binary_sensor:
  - platform: gpio
    name: "P2S"
    id: beam_p2s
    pin:
      number: GPIO25
      mode:
        input: true
        pullup: true
      inverted: true
    filters:
      - delayed_on: 10ms
      - delayed_off: 10ms
    on_press:
      - if:
          condition:
            binary_sensor.is_on: beam_p1s
          then:
            - script.execute: run_motor1_short

  - platform: gpio
    name: "P1S"
    id: beam_p1s
    pin:
      number: GPIO26
      mode:
        input: true
        pullup: true
      inverted: true
    filters:
      - delayed_on: 10ms
      - delayed_off: 10ms
    on_press:
      # Pair for Motor 1: P2S + P1S
      - if:
          condition:
            binary_sensor.is_on: beam_p2s
          then:
            - script.execute: run_motor1_short

      # Pair for Motor 2: P1S + Conveyor 1 Exit
      - if:
          condition:
            binary_sensor.is_on: beam_conveyor1_exit
          then:
            - script.execute: run_motor2_short

  - platform: gpio
    name: "Conveyor 1 Exit"
    id: beam_conveyor1_exit
    pin:
      number: GPIO27
      mode:
        input: true
        pullup: true
      inverted: true
    filters:
      - delayed_on: 10ms
      - delayed_off: 10ms
    on_press:
      - if:
          condition:
            binary_sensor.is_on: beam_p1s
          then:
            - script.execute: run_motor2_short

  - platform: gpio
    name: "Conveyor 2 Exit (Bin Drop)"
    id: beam_conveyor2_exit_bin_drop
    pin:
      number: GPIO16
      mode:
        input: true
        pullup: true
      inverted: true
    filters:
      - delayed_on: 10ms
      - delayed_off: 10ms

# ------------------------------------------------------------
# BIN LEVEL (Ultrasonic)
# ------------------------------------------------------------

sensor:
  - platform: ultrasonic
    trigger_pin: GPIO32
    echo_pin: GPIO33
    name: "Bin Distance"
    id: bin_distance
    update_interval: 1s
    timeout: 3m
    filters:
      - median:
          window_size: 5
          send_every: 1
          send_first_at: 1
```

---

### Quick heads-up (so you don’t get surprised)

If the beams stay broken for a long time (held ON), this only triggers when they **transition to ON** (“on_press”). That’s what you want for “poop fell through” events.

If later you decide you want “as long as beam is broken, keep running,” we’d switch to `on_state:` or use a loop. But for now, **short burst cleanup** is perfect.

If you tell me what run time you want for each motor (example: motor1 2s, motor2 4s), I’ll bake that into the scripts.
