# 5-Gallon Water Jug (1:10) — Revolve Workflow

**Goal:** clean, symmetric bottle using revolve; separate cap; optional logo emboss.

## Dimensions (scaled)
- Real height ~520 mm → model 52 mm
- Neck OD ~55 mm → model 5.5 mm (adjust by eye)
- Two rib bands with slight radius bump for highlights

## Steps
1. Import side photo as reference canvas, centerline vertically.
2. Sketch half-profile: base fillet → lower band → mid wall → upper band → shoulder → neck → lip.
3. Add construction axis on centerline, **Revolve** 360°.
4. Add rib bands as separate torus/extruded rings (tiny +R for light catch).
5. Model cap as separate body (cyl + chamfer/knurl).
6. Export cap/bottle separately for easier printing.

## Printing
- Translucent PETG/PLA, 0.2 mm layers, 3 perims, 10–15% infill.
- Light sand + clear coat for gloss (optional).

## Logo (optional)
- Clean SVG in Inkscape: *Trace Bitmap → simplify → save plain SVG*.
- Emboss/engrave onto bottle or place as flat badge.
