Perfect — let’s build you a **clean, professional DeskMeet X600 build list** formatted for your GitHub repo.
I’ll make it structured, readable, and easy to update later.

This will go in your repo at:

```
/Tutorials/Proxmox/deskmeet-x600/build-list.md
```

Here’s the full Markdown file, ready to paste:

---

# 🧩 **DeskMeet X600 – Proxmox Host Build List**

A compact high-performance virtualization node designed for GPU passthrough, low power consumption, and strong multi-VM performance.
This build replaces or supplements the Minisforum NAB9 with significantly higher sustained compute capability.

---

## 🖥️ **Core Components**

| Component            | Model                       | Notes                                                                               |
| -------------------- | --------------------------- | ----------------------------------------------------------------------------------- |
| **CPU**              | **AMD Ryzen 9 9950X**       | Zen 5, 16 cores / 32 threads, 120W TDP. Excellent for multi-VM workloads.           |
| **Barebone Chassis** | **ASRock DeskMeet X600W**   | Includes B650-class motherboard + 500W SFX PSU. Compact 8L workstation form factor. |
| **CPU Cooler**       | **Noctua NH-L12S**          | Best low-profile cooler for DeskMeet. Quiet and fits height limits.                 |
| **Memory**           | **(To be purchased later)** | Currently on hold due to price spike. Target: 64–128GB DDR5 (2×32GB → 4×32GB).      |
| **Primary NVMe**     | 4TB Gen4 NVMe               | For Proxmox + VM pool. (Samsung 990 Pro, WD SN850X, Crucial P5 Plus, or similar.)   |
| **Secondary NVMe**   | Optional 2–4TB Gen4 NVMe    | For ZFS pool, backups, or LXC containers.                                           |
| **GPU**              | Existing GPU                | Use whatever GPU you own for passthrough. (RTX A2000, 3050/3060 short card, etc.)   |

---

## 🔌 **Networking**

| Component                | Model          | Notes                                                              |
| ------------------------ | -------------- | ------------------------------------------------------------------ |
| **10GbE NIC (Optional)** | Intel X550-T2  | PCIe x4 card for faster VM/NAS throughput. DeskMeet supports it.   |
| **Onboard LAN**          | Realtek 2.5GbE | Default interface; fine for normal management and VM connectivity. |

---

## 🧊 **Cooling Upgrades**

| Component         | Model                      | Notes                                                      |
| ----------------- | -------------------------- | ---------------------------------------------------------- |
| **Case Fan**      | Noctua NF-P12 Redux 120mm  | Replaces stock fan for quieter operation + better airflow. |
| **Thermal Paste** | Noctua NT-H1 / Arctic MX-6 | Use good paste for the 9950X heat density.                 |

---

## 🔋 **Power Supply**

| Component                | Model                          | Notes                                                  |
| ------------------------ | ------------------------------ | ------------------------------------------------------ |
| **Included PSU**         | 500W SFX (80+ Bronze)          | Comes with DeskMeet. Enough for 9950X + low-power GPU. |
| **Optional PSU Upgrade** | Corsair SF600 / SF750 Platinum | For quieter operation and high-efficiency loads.       |

---

## 📝 **Build Notes**

* BIOS must be **v1.30+** to support the 9950X.
* Enable **SVM** + **IOMMU** for virtualization and GPU passthrough.
* Enable **Re-Size BAR** for GPU passthrough performance.
* Run CPU in **ECO Mode (65W)** for quieter, cooler operation — still extremely fast.
* Start with **64GB RAM** when prices normalize; add to 128GB later.
* Use NVMe Gen 4 drives for fastest VM IO.

---

## 📦 **Planned but Deferred Purchases**

Due to temporary DDR5 price spike, these components will be purchased later:

| Component        | Target Spec                       | Reason                                    |
| ---------------- | --------------------------------- | ----------------------------------------- |
| **Memory Kit 1** | 64GB (2×32GB) DDR5-6000 CL36 EXPO | Prices recently doubled; wait for drop.   |
| **Memory Kit 2** | Another 64GB to reach 128GB       | Add later when pricing returns to normal. |

---

## 📊 **Estimated Build Cost (Current Market)**

| Part           | Estimated Cost                                                     |
| -------------- | ------------------------------------------------------------------ |
| Ryzen 9 9950X  | Already purchased                                                  |
| DeskMeet X600W | ~$200–$240                                                         |
| NH-L12S cooler | ~$60–$70                                                           |
| 4TB NVMe       | ~$180–$260                                                         |
| Case Fan       | ~$12–$15                                                           |
| Memory         | **Deferred** (current $400–$450 per 64GB kit; wait for ~$200–$250) |

---

## 📁 **Repo Path**

```
/Tutorials/Proxmox/deskmeet-x600/build-list.md
```

---

If you want, I can also generate:

✅ a matching **hardware-inventory.yaml**
✅ a **price-tracking table** for RAM
✅ a **changelog file** to log upgrades over time
✅ a **Proxmox setup checklist** tailored to the DeskMeet

Just say the word.
