# 🧠 Fusion 360 Tutorial – Embossing Logos on Cylindrical Objects

This guide documents the steps used to emboss a logo (like "Magnetic Springs") onto a water bottle model in Fusion 360. Written for personal reference — simplified, no extra fluff.

---

## 🧰 Project Context

- **File:** `text-and-logo/`
- **Imported SVG:** Cleaned logo from Tinkercad
- **Bottle model:** Custom-built in Fusion 360
- **Goal:** Emboss the logo onto the curved side of a bottle, keeping walls thin

---

## 🔧 Step-by-Step: Emboss a Logo

### 1. Prep the Bottle Model
- Open your bottle project
- Make sure the **bottle is a solid body**
- Save before messing with anything

### 2. Import the Logo (SVG)
- `Insert` → `Insert SVG`
- Pick a clean vertical plane (usually a right or front face)
- Resize **immediately** if needed using the blue handles
- **Position it** roughly where you want it
- Click `Finish Sketch`

### 3. Move the Sketch (if needed)
- In the Browser, expand `Sketches`
- Right-click the sketch → `Edit Sketch`
- Use the `Move` tool (hotkey: **M**) to reposition

> 💡 Use `Sketch > Point` if you want to move it based on a reference location.

### 4. Emboss the Logo
- Go to `Create` → `Emboss`
- Select the sketch
- Select the cylindrical face on the bottle
- Pick **Emboss Type: Emboss (not Deboss)**
- Pick an appropriate height (e.g. 0.8 mm)
- Press OK

> 🧱 Make sure the **logo is in contact** with the face. If it floats, go back and reposition the sketch.

---

## 💾 Exporting

To export just the final bottle:

1. In the **Browser**, **hide** any extra bodies you don’t want exported
2. Go to `File` → `Export`
3. Choose STL or 3MF
4. Make sure **“Selected Bodies”** is checked and your bottle body is the one selected

---

## 🧩 Other Notes

- If the bottle appears in multiple bodies:
    - Try `Modify > Combine` → set one as **Target**, others as **Tool Bodies**
    - Turn off **Keep Tools**
    - If it fails, run `Inspect > Interference` to see problem spots

- If the top is broken or junked after emboss:
    - Just model a new top separately and join it later
    - You can even cheat it with a cylinder + fillet

---

## 🔗 Related Assets

- `assets/logo.svg` → Source file for emboss
- `text-and-logo/v1/` → First successful print
- `text-and-logo/v2-large-bottle/` → Thinner wall model in progress

---

## ✅ To Do (Later)
- [ ] Add screenshots
- [ ] Record screen capture of steps
- [ ] Save separate versions with different wall thickness
