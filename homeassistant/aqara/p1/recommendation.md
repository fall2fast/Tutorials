That’s a perfect use-case for a **smart presence + light-aware sensor** — exactly the kind of automation that feels natural once it’s dialed in.
You want something that:

1. Detects motion or presence instantly when someone starts down the stairs,
2. Doesn’t false-trigger from pets or ambient noise,
3. Checks current brightness (so it *only* turns on when it’s actually dim), and
4. Works reliably with **Home Assistant + Zigbee2MQTT** or ZHA.

Here’s the no-BS rundown of what works best for *your* setup:

---

## 🥇 **Aqara FP300** *(new model)*

You already mentioned this one — and honestly, it’s **tailor-made** for stair lighting.

* **Pros:**

  * Dual mmWave + PIR means instant motion trigger *and* fine presence sensing.
  * Has a built-in **lux (light) sensor**, so you can automate:
    `if presence == true and illuminance < 40 lx → turn on lights`.
  * Zigbee and Thread options — will talk directly to your SLZB-06M.
  * Battery-powered → easy ceiling or wall mount at top or bottom of the stairs.
* **Con:** New and a bit pricey, but rock-solid once paired.

> 💡 Ideal automation in Home Assistant:
>
> ```yaml
> trigger:
>   - platform: state
>     entity_id: sensor.stairs_fp300_presence
>     to: "on"
> condition:
>   - condition: numeric_state
>     entity_id: sensor.stairs_fp300_illuminance
>     below: 40
> action:
>   - service: light.turn_on
>     entity_id: light.basement_stairs
> ```
>
> Add an automation to turn the light off after 1–2 min of `presence == off`.

---

## 🥈 **Aqara P1 Motion Sensor**

If you want something simpler and cheaper:

* Zigbee, battery lasts ~5 years.
* Includes **lux sensor** (unlike many cheap motion sensors).
* Extremely reliable with Z2M.
* Range easily covers a stairway when mounted ~7 ft high.

> ⚙️ Same type of Home Assistant automation — just use its motion + illuminance values.

---

## 🥉 **Philips Hue Motion Sensor**

* Excellent response time and ambient-light sensing.
* Works over Zigbee directly (you don’t need a Hue Bridge).
* Runs for years on AAA batteries.
* Integrates cleanly with HA via ZHA or Z2M.

> Slightly higher cost but dead-simple to mount and tune.

---

### 🚫 What not to use

* Generic PIR sensors *without* a light sensor — they’ll turn the lights on even when it’s bright.
* Wi-Fi presence sensors — slower to trigger and more prone to lag compared to Zigbee.

---

### 🧭 Recommendation for You

Given your environment:

* **Basement stairs** = quick trigger, low light, needs consistent response
* **Already Zigbee** = use your SLZB-06M

👉 **Go with the Aqara P1** for a cheap, flawless start,
or **wait for the FP300 sale** and use that if you want presence + lux in one tidy device.

---

If you want, I can mock up a full Home Assistant YAML automation that handles:

* turning on when dark & movement detected,
* adaptive brightness,
* graceful fade-off when the stairs clear.
  Want me to generate that next?
