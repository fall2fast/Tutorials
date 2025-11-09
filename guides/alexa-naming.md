# Alexa Device Naming – Clean Pattern

## Rules
- Use **room-centric** names; avoid duplicates.
- Keep **short nouns** Alexa understands: `ceiling`, `desk`, `lamp`, `fan`.
- Group per room; assign the **Echo in that room** to the same group.

## Pattern
**Group name** = Room (e.g., `Bedroom`)
**Devices inside group**:
- `ceiling`  → the main light(s)
- `headboard`
- `desk`
- `fan`
- `strip` (LEDs)

> Then “Alexa, turn on *ceiling*” works **only** for the room you’re in.

## Examples
### Bedroom
- Group: `Bedroom`
- Echo: Bedroom Echo
- Devices: `ceiling`, `headboard`, `fan`

### Office
- Group: `Office`
- Devices: `ceiling` (2 bulbs linked), `desk`, `strip`

## Tips
- Avoid filler words: “the”, “light”, “lamp” unless needed.
- Use **routines** for scenes: `movie`, `work`, `night`.
- If two Echos hear you, add `Device Location` to that Echo so it prefers its room.
