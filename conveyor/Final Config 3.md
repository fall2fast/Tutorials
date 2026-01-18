Final Config 3

Ah — **that changes everything**, and you’re right to call it out.

If those beams are **different poop drops**, then they will **never** be ON at the same time, so any “Beam A AND Beam B” logic will *never* fire.

What you actually want is:

* **P2S beam break → run Motor 1 for X seconds**
* **P1S beam break → run Motor 1 for X seconds**
* **Conveyor 1 Exit beam break → run Motor 2 for Y seconds**
* **Conveyor 2 Exit (Bin Drop) beam break → run Motor 2 for Y seconds** (optional but usually yes)

That’s “OR” logic, not “AND”.

Below is your full YAML rewritten correctly (safe copy/paste).

---

## Full YAML (correct for separate drops)

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
  - platform: ledc
    pin: GPIO18
    id: motor1_ena
    frequency: 500 Hz
    inverted: false

  - platform: ledc
    pin: GPIO23
    id: motor2_enb
    frequency: 500 Hz
    inverted: false

switch:
  - platform: gpio
    pin: GPIO19
    id: motor1_in1
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO21
    id: motor1_in2
    restore_mode: ALWAYS_OFF

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

  - platform: gpio
    pin: GPIO22
    id: motor2_in3
    restore_mode: ALWAYS_OFF

  - platform: gpio
    pin: GPIO17
    id: motor2_in4
    restore_mode: ALWAYS_OFF

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
# SCRIPTS (run motors for a short time)
# Adjust the delays here.
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
# BEAM SENSORS
# You confirmed: Beam broken shows ON.
# So these triggers fire correctly on a drop event.
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
      - script.execute: run_motor1_short

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
    on_press:
      - script.execute: run_motor2_short

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

### Why this will work

* Each beam is treated as its own “drop event”
* `on_press` triggers when the beam breaks (goes ON)
* The motor runs for 3 seconds, and `mode: restart` means if multiple drops happen close together, it just extends/refreshes the run

---

### Tiny optional improvement (prevents rapid re-triggers)

If a drop sometimes makes the beam flicker, add this to each beam under `filters:`:

```yaml
      - delayed_off: 150ms
```

But try it as-is first.

---

If you tell me how your conveyors are physically arranged (does Motor 2 *always* need to run after Motor 1, or only on exit/bin beams?), I can tighten the logic so it runs the minimum necessary every time.
