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
    ├── bin/tinymix            # Static aarch64 ALSA hardware mixer override tool
    ├── customize.sh           # Magisk module installation logic
    ├── service.sh             # Late-start HAL reload & hardware register lock daemon
    ├── system/vendor/etc/     # Complete 5-pillar MTK audio parameter overlays
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

## 🔊 2. Ultimate Audio Boost (MediaTek MT6769 / MT6358 5-Pillar Architecture)

* **Directory:** `audio_boost/`
* **Package:** `N30A_AudioBoost_Magisk.zip`
* **Target:** MediaTek MT6769Z (Helio G85) MT6358 Codec & SI-INTECH SIA8101 Speaker Amp

### Architectural Overview & Technical Findings
On the Realme Narzo 30A (`RMX3171`), loudspeaker audio is routed through the MediaTek MT6358 Codec line-out buffer (`int_lo_buf`) feeding a dedicated SI-INTECH SIA8101 Class-D external amplifier via ALSA mixer controls `Lineout_PGAL_GAIN` and `Lineout_PGAR_GAIN`.

Stock Realme UI 1.0 firmware clamped audio volume through multiple redundant software and hardware bottlenecks:
1. **Analog Codec Attenuation (`PlaybackVolAna_AudioParam.xml`):** Stock set `speaker_pga = 15` (-7 dB attenuation). Baseline vendor set `7` (+1 dB).
2. **Volume Curve Clamping (`VolumeGainMap_AudioParam.xml`):** `param_id="3"` (`SPK_LO`) hard-coded `dl_total_gain` and `dl_analog_gain` to `-1 dB` maximum across all 40 volume steps, overriding higher user settings.
3. **Music DRC Bypass (`PlaybackDRC_AudioParam.xml`):** Ringtones received full dynamic range compression (`DRC_Gn = 6144`), while music playback had zero dynamic makeup gain (`DRC_Gn = 0`), making media volume sound muffled compared to ringtones.
4. **Hardware Notch Filtering (`PlaybackACF_AudioParam.xml`):** An aggressive notch filter (`bes_loudness_L_bpf_gain = -1023`) heavily attenuated 300 Hz vocal frequencies, while WideSound gain was disabled (`WS_Gain_Max = 0x0`).
5. **Runtime Gain Reset:** During Android initialization, `AudioMTKGainController::setVoiceVolume` reset ALSA line-out gain registers to index `11` (-3 dB).

### Full 5-Pillar Calibration Applied
This module combines XML parameter overlays with a late-start ALSA hardware daemon:
* **Analog Line-Out Boost (+8 dB MAX):** Uncaps `speaker_pga` to index `0` (+8 dB analog headroom, a **+15 dB increase** over stock OEM).
* **In-Call Earpiece Boost (+6 dB):** Sets `receiver_pga` to index `2` for crystal-clear call audio.
* **VolumeGainMap Uncap:** Unlocks positive analog/total gain curves up to +8 dB in `SPK_LO`.
* **Digital Dynamic Range (+8 dB):** Unlocks positive digital gain steps up to +8 dB in `PlaybackVolDigi`.
* **Ringtone-Grade DRC Makeup:** Injects 6144 makeup gain and Sub-Band expansion into music playback.
* **Acoustic Filter Relaxation:** Removes the -1023 notch filter and enables `bes_loudness_WS_Gain_Max = 0x8` (+8 dB WideSound).
* **Late-Start Mixer Lock Daemon:** Bundles a static `tinymix` binary in `service.sh` that explicitly locks ALSA hardware registers (`Lineout_PGAL_GAIN = 0`, `ADDA_DL_GAIN = 65535`) after Android boot to prevent framework overrides.

---

## 📥 Downloads & Verified Checksums

All ready-to-flash flashable ZIPs are available on the [**Releases**](https://github.com/omi4real/Realme-Narzo-30A-Magisk-Addons/releases) page:

| Module Deliverable | File & MD5 Checksum |
| :--- | :--- |
| **Game Unlocker (Zygisk)**<br><sub>Per-app FPS whitelist & flagship device spoofer (~4.4 MB)</sub> | **File:** `Infinix_GT50Pro_S25Ultra_GameUnlocker.zip`<br>**MD5:** `4e31d218a1858317375261548705c8ab` |
| **Audio Boost (Magisk)**<br><sub>Hardware-calibrated MediaTek 5-pillar audio booster (~299 KB)</sub> | **File:** `N30A_AudioBoost_Magisk.zip`<br>**MD5:** `e38bee98a88d33c3dadfb38c4656d0ce` |

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
