# Realme Narzo 30A (RMX3171) - Magisk & Zygisk Addons Suite

[![Device](https://img.shields.io/badge/Device-Realme_Narzo_30A_(RMX3171)-blue?style=flat-square)](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial)
[![SoC](https://img.shields.io/badge/SoC-MediaTek_Helio_G85-orange?style=flat-square)](https://www.mediatek.com)
[![Platform](https://img.shields.io/badge/Root-Magisk_/_KernelSU_/_APatch-brightgreen?style=flat-square)](https://github.com/topjohnwu/Magisk)
[![License](https://img.shields.io/badge/License-Apache_2.0-blueviolet?style=flat-square)](./LICENSE)

A curated suite of high-performance root modules and Zygisk addons built and tuned specifically for the **Realme Narzo 30A (`RMX3171`)** running Android 10 (#keepQASSA) or compatible AOSP custom ROMs.

Companion repository to the official [**Realme Narzo 30A #keepQASSA ROM Port**](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial).

---

## 📦 Included Modules

```text
Realme-Narzo-30A-Magisk-Addons/
├── game_unlocker/             # Native Zygisk per-app device spoofing engine
│   ├── gu_controller_arm64    # Native daemon IPC controller
│   ├── zygisk/                # Pre-specialization PLT hook libraries (arm64 & v7a)
│   ├── webroot/               # Local WebUI dashboard for game management
│   └── common/                # Per-package spoof config and dynamic thermal rules
└── audio_boost/               # MediaTek loudspeaker acoustic gain booster
    ├── customize.sh           # Magisk module installation logic
    ├── service.sh             # Late-start HAL reload & bind mount daemon
    ├── system/vendor/etc/     # Magisk overlay for MTK ALSA audio parameters
    └── audio_param_reference/ # Raw OEM and calibrated audio tuning XML tables
```

---

## 🎮 1. Game Unlocker (Zygisk High-FPS & Thermal Spoof)

* **Directory:** `game_unlocker/`
* **Package:** `Infinix_GT50Pro_S25Ultra_GameUnlocker.zip`
* **Target:** PUBG Mobile / BGMI, Call of Duty Mobile, Free Fire Max, Farlight 84, Genshin Impact

### Architectural Overview
Game Unlocker intercepts system property reads and patches `android.os.Build` fields (`MANUFACTURER`, `MODEL`, `FINGERPRINT`) natively inside the Zygote fork lifecycle (`preAppSpecialize`) before the target game initializes. This tricks server-side whitelists into recognizing the Narzo 30A as a flagship device (such as the Infinix GT 50 Pro or Samsung Galaxy S25 Ultra), unlocking 60 FPS, 90 FPS, and 120 FPS graphics settings.

* **Native Hooking:** Injects hooks via PLT hooking (`bytehook`) at the native libc level, remaining invisible to user-space anti-cheat engines.
* **Per-Package Isolation:** Device spoofing is strictly scoped to designated game package names (`common/config.json`). It will never leak spoofed fingerprints to banking or wallet apps.
* **Integrated WebUI:** Built-in web dashboard accessible from Magisk or browser to toggle spoof profiles and add custom game packages without rebooting.

---

## 🔊 2. Audio Boost (MediaTek Speaker Gain Fix)

* **Directory:** `audio_boost/`
* **Package:** `N30A_AudioBoost_Magisk.zip`
* **Target:** MediaTek MT6769 / MT6768 Internal Codec & Line-out Amplifier

### Architectural Overview
On the Helio G85 platform, loudspeaker pathing is managed by `/vendor/etc/audio_param/oppo6769_206AC_533/PlaybackVolAna_AudioParam.xml`. When using the `int_lo_buf` (internal line-out buffer) path, stock firmware attenuates analog speaker levels.

This module applies hardware-calibrated analog PGA gain tables and overlay mounting at boot:
* **Analog Speaker Boost (+4dB):** Corrects `speaker_pga` index to boost analog acoustic loudspeaker volume cleanly without amplifier clipping or distortion.
* **Earpiece Boost (+6dB):** Adjusts `receiver_pga` index to improve in-call audio clarity.
* **Non-Destructive Magisk Overlay:** Replaces parameters cleanly via Magisk magic mount and live HAL restart, returning to stock upon module removal.

---

## 📥 Downloads & Verified Checksums

All ready-to-flash flashable ZIPs are available on the [**Releases**](https://github.com/omi4real/Realme-Narzo-30A-Magisk-Addons/releases) page:

| Module Deliverable | File & MD5 Checksum |
| :--- | :--- |
| **Game Unlocker (Zygisk)**<br><sub>Per-app FPS whitelist & flagship device spoofer (~4.4 MB)</sub> | **File:** `Infinix_GT50Pro_S25Ultra_GameUnlocker.zip`<br>**MD5:** `4e31d218a1858317375261548705c8ab` |
| **Audio Boost (Magisk)**<br><sub>Hardware-calibrated MediaTek speaker acoustic gain (~5.4 KB)</sub> | **File:** `N30A_AudioBoost_Magisk.zip`<br>**MD5:** `bedf0e69d2a69aa2e1836b2ca42abd97` |

---

## 🛠️ Installation Instructions

### Prerequisites
1. An unlocked bootloader on the **Realme Narzo 30A (`RMX3171`)**.
2. Root solution installed:
   * **Magisk:** v24.0 or newer (v30.7 recommended) with **Zygisk enabled** in Magisk settings (required for Game Unlocker).
   * **KernelSU:** With ZygiskNext module installed.
   * **APatch:** With ZygiskNext module installed.

### Flashing via Root Manager
1. Download the target `.zip` module from [**Releases**](https://github.com/omi4real/Realme-Narzo-30A-Magisk-Addons/releases).
2. Open **Magisk** (or KernelSU / APatch).
3. Navigate to the **Modules** tab.
4. Select **Install from storage** and choose the downloaded ZIP.
5. Wait for the installation script to complete.
6. **Reboot** your device.

---

## 📄 License & Credits

* **License:** Apache License 2.0 (see [LICENSE](./LICENSE)).
* **Game Unlocker Upstream Engine:** Original Zygisk core architecture by @yadavnikhil03. Custom profiles, thermal rules, and Narzo 30A adaptations maintained by omi4real.
* **Narzo 30A Port Project:** [Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial).
