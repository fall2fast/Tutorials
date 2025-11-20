# 🧠 ASRock DeskMeet X600 — Proxmox Host Build

A compact, high-performance virtualization node built for low noise, low power, and full GPU passthrough support.  
This replaces my Minisforum NAB9 as the main Proxmox workstation host.

---

## ⚙️ Hardware Overview

| Component | Model | Notes |
|------------|--------|-------|
| **Chassis / Board** | ASRock **DeskMeet X600** (AM5 / B650-class barebone) | 8 L compact chassis, includes 500 W PSU, PCIe x16 slot |
| **CPU** | AMD **Ryzen 9 9950X** (Zen 5, 16 C / 32 T, 120 W TDP) | Max supported chip, excellent sustained VM performance |
| **Cooler** | **Noctua NH-L12S** | Low-profile (70 mm total height), quiet under full load |
| **Memory** | 64 GB (2 × 32 GB) DDR5-6000 CL36 | Supports up to 128 GB (4 × 32 GB) |
| **Storage #1** | 1 TB NVMe Gen 4 (boot + VMs) | Samsung 990 Pro / WD SN850X / Crucial P5 Plus |
| **Storage #2** | 2 TB NVMe Gen 4 (ZFS pool / backups) | Any high-endurance drive |
| **GPU** | NVIDIA RTX A2000 12 GB LP (70 W) | Ideal for transcoding & passthrough; fits chassis |
| **Network** | Intel X550-T2 10 GbE PCIe x4 | Connects to 10 GbE backbone / NAS |
| **Case Fan** | Noctua NF-P12 redux 120 mm PWM | Replaces stock fan, lowers noise |
| **PSU** | Included 500 W SFX 80+ Bronze | Sufficient for 9950X + A2000 GPU |

---

## 🔧 BIOS / Setup Notes

- **BIOS v1.30 or newer** → required for Ryzen 9000 support  
- Enable **SVM** (Virtualization) and **IOMMU** for VM passthrough  
- Set **Precision Boost Overdrive = ECO Mode 65 W** for quiet operation  
- Enable **Re-size BAR Support** for GPU passthrough  
- Disable **Secure Boot** for Proxmox installer  

---

## 🧮 Performance Summary

| Scenario | Power Draw | Cinebench R23 Multi | Notes |
|-----------|------------|--------------------:|-------|
| Idle (VMs running) | ~45 – 55 W | — | Whisper quiet |
| Typical VM Load | ~120 W | ~33 000 pts | 3× faster than NAB9 |
| Full CPU + GPU Load | ~260 – 280 W | — | Stable temps < 80 °C |

---

## 🖥️ Proxmox VE Configuration

- Proxmox VE 8.x (ZFS root on NVMe)
- VM Passthrough enabled for A2000 GPU  
- 10 GbE bonded interface → Trusted VLAN  
- Node monitored in Home Assistant via Proxmox API  

---

## 🧩 Optional Upgrades

| Option | Purpose |
|--------|----------|
| +64 GB RAM (total 128 GB) | For heavier VM clusters |
| Larger GPU (RTX 4060 LP) | For AI / rendering workloads |
| NVMe PCIe 5.0 | Slight IO boost for cache-heavy VMs |
| Custom SFX Platinum PSU | Quieter and more efficient |

---

## 📦 Total Build Cost (Oct 2025)

| Category | Cost (USD) |
|-----------|------------:|
| DeskMeet X600 barebone | $220 |
| Ryzen 9 9950X | $520 |
| NH-L12S cooler | $65 |
| 64 GB DDR5 6000 | $170 |
| NVMe drives (1 + 2 TB) | $220 |
| RTX A2000 GPU | $350 |
| Intel X550-T2 NIC | $120 |
| Misc (fan, paste, etc.) | $30 |
| **Total** | **≈ $1 695 USD** |

---

## 🧾 Notes

- Idle temps ≈ 38 °C CPU / 33 °C GPU.  
- Noise ≈ 24 dB at idle, 33 dB under load.  
- System sits in basement rack; fan curve set to “Quiet”.  
- Replaced NAB9 host for heavier VM workloads.  

---

**Created:** Oct 2025  
**Author:** Tony  
**Repo Path:** `/Tutorials/Proxmox/deskmeet-x600/README.md`  
