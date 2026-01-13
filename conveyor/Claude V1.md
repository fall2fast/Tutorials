Perfect! Here's your complete YAML configuration file with everything included:

**What's in this config:**

✅ **All 4 IR sensors** with your new names:
- P2S Drop (GPIO25)
- P1S Drop (GPIO26)
- C2 Entry (GPIO27)
- Bin Entry (GPIO14)

✅ **Ultrasonic bin level sensor** (GPIO32/33):
- Raw distance in cm
- Calculated fill percentage

✅ **Both motors** (Conveyor 1 & 2):
- Full speed control via L298N
- Runtime hour tracking

✅ **Poop counters** for each location:
- P2S count
- P1S count
- Transfer count (to conveyor 2)
- Bin count (final destination)

✅ **Reset button** to zero all counters

**To use it:**
1. Copy the entire contents
2. Paste it into your ESPHome device configuration (replacing what's there)
3. Save and install wirelessly

**Remember to calibrate the bin level sensor** by updating these two values after you mount it:
```yaml
float empty_distance = 50.0;  // Distance when bin is empty (cm)
float full_distance = 5.0;     // Distance when bin is full (cm)
```

Ready to flash the new ESP32 when you get it wired up safely? 🚀

### Complete ESPHome YAML Configuration

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

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: "Poop-Conveyor Fallback Hotspot"
    password: "ZKdTVtErUNSY"

captive_portal:

# Web server for debugging (optional but handy)
web_server:
  port: 80

# IR Beam Break Sensors
binary_sensor:
  # Conveyor 1 sensors
  - platform: gpio
    pin:
      number: GPIO25
      mode: INPUT_PULLUP
      inverted: true
    name: "P2S Drop"
    id: p2s_drop
    on_press:
      then:
        - lambda: |-
            id(poop_count_p2s) += 1;
    
  - platform: gpio
    pin:
      number: GPIO26
      mode: INPUT_PULLUP
      inverted: true
    name: "P1S Drop"
    id: p1s_drop
    on_press:
      then:
        - lambda: |-
            id(poop_count_p1s) += 1;
    
  - platform: gpio
    pin:
      number: GPIO27
      mode: INPUT_PULLUP
      inverted: true
    name: "C2 Entry"
    id: c2_entry
    on_press:
      then:
        - lambda: |-
            id(poop_count_transfer) += 1;
    
  # Conveyor 2 sensor
  - platform: gpio
    pin:
      number: GPIO14
      mode: INPUT_PULLUP
      inverted: true
    name: "Bin Entry"
    id: bin_entry
    on_press:
      then:
        - lambda: |-
            id(poop_count_bin) += 1;

# Sensors
sensor:
  # Ultrasonic sensor for bin level
  - platform: ultrasonic
    trigger_pin: GPIO32
    echo_pin: GPIO33
    name: "Poop Bin Level"
    id: bin_level
    update_interval: 10s
    unit_of_measurement: "cm"
    accuracy_decimals: 1
    filters:
      - sliding_window_moving_average:
          window_size: 5
          send_every: 1
    
  # Convert distance to percentage (adjust max_distance based on your bin depth)
  - platform: template
    name: "Poop Bin Fill Percentage"
    id: bin_fill_percent
    unit_of_measurement: "%"
    accuracy_decimals: 0
    lambda: |-
      // Adjust these values based on your bin dimensions
      float empty_distance = 50.0;  // Distance when bin is empty (cm)
      float full_distance = 5.0;     // Distance when bin is full (cm)
      float current = id(bin_level).state;
      
      if (current > empty_distance) current = empty_distance;
      if (current < full_distance) current = full_distance;
      
      float percentage = 100.0 * (empty_distance - current) / (empty_distance - full_distance);
      return percentage;
    update_interval: 10s
  
  # Poop counters for tracking
  - platform: template
    name: "P2S Poop Count"
    id: poop_count_p2s_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_p2s);
    update_interval: 2s
    
  - platform: template
    name: "P1S Poop Count"
    id: poop_count_p1s_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_p1s);
    update_interval: 2s
    
  - platform: template
    name: "Transfer Count"
    id: transfer_count_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_transfer);
    update_interval: 2s
    
  - platform: template
    name: "Bin Count"
    id: bin_count_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_bin);
    update_interval: 2s
  
  # Runtime tracking
  - platform: template
    name: "Conveyor 1 Runtime Hours"
    id: conv1_runtime_hours
    unit_of_measurement: "h"
    accuracy_decimals: 2
    lambda: |-
      return id(conv1_runtime_seconds) / 3600.0;
    update_interval: 60s
    
  - platform: template
    name: "Conveyor 2 Runtime Hours"
    id: conv2_runtime_hours
    unit_of_measurement: "h"
    accuracy_decimals: 2
    lambda: |-
      return id(conv2_runtime_seconds) / 3600.0;
    update_interval: 60s

# Global variables for counters
globals:
  - id: poop_count_p2s
    type: int
    restore_value: yes
    initial_value: '0'
    
  - id: poop_count_p1s
    type: int
    restore_value: yes
    initial_value: '0'
    
  - id: poop_count_transfer
    type: int
    restore_value: yes
    initial_value: '0'
    
  - id: poop_count_bin
    type: int
    restore_value: yes
    initial_value: '0'
    
  - id: conv1_runtime_seconds
    type: float
    restore_value: yes
    initial_value: '0.0'
    
  - id: conv2_runtime_seconds
    type: float
    restore_value: yes
    initial_value: '0.0'

# Interval to track runtime when motors are on
interval:
  - interval: 1s
    then:
      - lambda: |-
          if (id(motor1_switch).state) {
            id(conv1_runtime_seconds) += 1.0;
          }
          if (id(motor2_switch).state) {
            id(conv2_runtime_seconds) += 1.0;
          }

# Motor speed control (PWM)
output:
  - platform: ledc
    pin: GPIO13
    id: motor1_speed
    frequency: 1000 Hz
    
  - platform: ledc
    pin: GPIO23
    id: motor2_speed
    frequency: 1000 Hz

# Motor direction and control
switch:
  # Motor 1 main control
  - platform: template
    name: "Conveyor 1 Motor"
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
  
  # Motor 2 main control
  - platform: template
    name: "Conveyor 2 Motor"
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
  
  # Motor 2 direction pins  
  - platform: gpio
    pin: GPIO22
    id: motor2_in3
    internal: true
    
  - platform: gpio
    pin: GPIO21
    id: motor2_in4
    internal: true

# Reset counters button
button:
  - platform: template
    name: "Reset Poop Counters"
    on_press:
      - lambda: |-
          id(poop_count_p2s) = 0;
          id(poop_count_p1s) = 0;
          id(poop_count_transfer) = 0;
          id(poop_count_bin) = 0;
```

Ready to flash the new ESP32 when you get it wired up safely? 🚀

## Configuration Notes

### Bin Level Calibration

The ultrasonic sensor needs to be calibrated for your specific bin:

```yaml
float empty_distance = 50.0;  // Distance when bin is empty (cm)
float full_distance = 5.0;     // Distance when bin is full (cm)
```

**To calibrate:**
1. Measure distance from sensor to bottom of empty bin
2. Update `empty_distance` value
3. Measure distance from sensor when bin is "full"
4. Update `full_distance` value

### IR Sensor Configuration

The beam break sensors use `INPUT_PULLUP` mode with `inverted: true`. This works with most standard IR break beam sensors that pull the pin LOW when the beam is broken.

If your sensors work differently, you may need to adjust:
- Remove `inverted: true` if sensor goes HIGH when beam is broken
- Change to `INPUT_PULLDOWN` if your sensors require it

## Features

### Metrics Tracked
- Poop count per conveyor
- Conveyor runtime hours
- Bin fill level (cm and percentage)
- Individual sensor states

### Home Assistant Integration
All sensors and controls automatically appear in Home Assistant and can be:
- Added to dashboards
- Used in automations
- Exported to Prometheus/Grafana for historical tracking

### Counter Persistence
Poop counts and runtime hours are saved to flash memory and persist through reboots and power cycles.

## Troubleshooting

### Device Shows Offline
1. Check WiFi credentials in secrets
2. Ensure ESP32 is powered adequately (5V 2A minimum)
3. Verify WiFi is 2.4GHz (ESP32 doesn't support 5GHz)
4. Try power cycling the device
5. Check ESPHome logs for connection errors

### Motors Not Running
1. Verify L298N power connections (12V supply connected)
2. Check motor power supply is adequate (recommend 12V 3A+)
3. Test motors directly with L298N to verify wiring
4. Check GPIO pin connections match config

### Sensors Not Triggering
1. Test sensors with multimeter (should go LOW when triggered)
2. Verify 5V power to sensors
3. Try toggling `inverted: true` setting
4. Check wire connections for loose contacts

### Ultrasonic Sensor Reading Errors
1. Ensure sensor has clear line of sight
2. Check trigger and echo pins aren't swapped
3. Verify sensor is powered with 5V
4. Objects need to be within sensor range (2cm - 400cm typically)

## Future Enhancements

- [ ] Add Prometheus exporter configuration
- [ ] Create Grafana dashboard examples
- [ ] Implement automatic bin full alerts
- [ ] Add conveyor speed control
- [ ] Create Home Assistant automation examples

## License

MIT License - Feel free to use and modify for your own projects!

## Contributing

Pull requests welcome! If you make improvements or find bugs, please share them.
