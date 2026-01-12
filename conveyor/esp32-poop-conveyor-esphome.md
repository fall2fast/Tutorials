# ESP32 Poop Conveyor - ESPHome Setup

## Project Overview

Automated filament waste conveyor system for 3D printers. Uses dual conveyors with IR beam break sensors to move filament purge/waste from the printer to a collection bin, with ultrasonic bin level monitoring.

## Hardware Components

- ESP32 DevKit board (ESP32-WROOM)
- L298N dual motor driver
- 2x 12V DC gear motors
- 4x IR beam break sensors
- 1x HC-SR04 ultrasonic distance sensor
- Buck converter (12V to 5V for ESP32)
- 12V power supply

## Wiring Diagram

![Wiring Diagram](../../path/to/your/wiring-diagram.png)

*Note: Update the image path to match your repo structure*

## GPIO Pin Assignments

### IR Beam Break Sensors
- **Sensor 1** (Conveyor 1 entrance): GPIO 25
- **Sensor 2** (Conveyor 1 exit): GPIO 26
- **Sensor 3** (Conveyor 2 entrance): GPIO 27
- **Sensor 4** (Conveyor 2 exit): GPIO 14

### Ultrasonic Sensor (Bin Level)
- **Trigger**: GPIO 32
- **Echo**: GPIO 33

### Motor 1 (L298N side A)
- **ENA** (speed control): GPIO 13
- **IN1** (direction bit 1): GPIO 12
- **IN2** (direction bit 2): GPIO 15

### Motor 2 (L298N side B)
- **ENB** (speed control): GPIO 23
- **IN3** (direction bit 1): GPIO 22
- **IN4** (direction bit 2): GPIO 21

## ESPHome Configuration

### Prerequisites
- Home Assistant with ESPHome add-on installed
- WiFi credentials configured in ESPHome secrets

### Initial Setup

1. Connect ESP32 to computer via USB
2. In Home Assistant, navigate to ESPHome
3. Click "+ NEW DEVICE"
4. Name it `poop-conveyor`
5. Select ESP32 > ESP32-WROOM
6. Click "INSTALL" > "Plug into this computer"
7. Select USB port and flash

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
    key: !secret esphome_api_key

ota:
  - platform: esphome
    password: !secret esphome_ota_password

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
  - platform: gpio
    pin:
      number: GPIO25
      mode: INPUT_PULLUP
      inverted: true
    name: "Conveyor 1 Entrance Sensor"
    id: beam_conv1_entrance
    on_press:
      then:
        - lambda: |-
            id(poop_count_conv1) += 1;
    
  - platform: gpio
    pin:
      number: GPIO26
      mode: INPUT_PULLUP
      inverted: true
    name: "Conveyor 1 Exit Sensor"
    id: beam_conv1_exit
    
  - platform: gpio
    pin:
      number: GPIO27
      mode: INPUT_PULLUP
      inverted: true
    name: "Conveyor 2 Entrance Sensor"
    id: beam_conv2_entrance
    on_press:
      then:
        - lambda: |-
            id(poop_count_conv2) += 1;
    
  - platform: gpio
    pin:
      number: GPIO14
      mode: INPUT_PULLUP
      inverted: true
    name: "Conveyor 2 Exit Sensor"
    id: beam_conv2_exit

# Ultrasonic sensor for bin level
sensor:
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
    name: "Conveyor 1 Poop Count"
    id: poop_count_conv1_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_conv1);
    update_interval: 2s
    
  - platform: template
    name: "Conveyor 2 Poop Count"
    id: poop_count_conv2_sensor
    accuracy_decimals: 0
    lambda: |-
      return id(poop_count_conv2);
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
  - id: poop_count_conv1
    type: int
    restore_value: yes
    initial_value: '0'
    
  - id: poop_count_conv2
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
          id(poop_count_conv1) = 0;
          id(poop_count_conv2) = 0;
```

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
