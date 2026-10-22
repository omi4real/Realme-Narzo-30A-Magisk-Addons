# Realme Narzo 30A (RMX3171) - Magisk Addons Suite

[![Device](https://img.shields.io/badge/Device-Realme_Narzo_30A_(RMX3171)-blue?style=flat-square)](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial)
[![SoC](https://img.shields.io/badge/SoC-MediaTek_Helio_G85-orange?style=flat-square)](https://www.mediatek.com)
[![Platform](https://img.shields.io/badge/Root-Magisk_/_KernelSU_/_APatch-brightgreen?style=flat-square)](https://github.com/topjohnwu/Magisk)
[![License](https://img.shields.io/badge/License-Apache_2.0-blueviolet?style=flat-square)](./LICENSE)

A curated suite of hardware-calibrated root modules built and tuned specifically for the **Realme Narzo 30A (`RMX3171`)** running Android 10 (#keepQASSA) or compatible AOSP custom ROMs.

Companion repository to the official [**Realme Narzo 30A #keepQASSA ROM Port**](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial).

---

## 📦 Repository Structure

```text
Realme-Narzo-30A-Magisk-Addons/
└── audio_boost/               # MediaTek loudspeaker acoustic gain booster
    ├── bin/tinymix            # Static aarch64 ALSA hardware mixer override tool
    ├── customize.sh           # Magisk module installation logic
    ├── service.sh             # Late-start HAL reload & hardware register lock daemon
    ├── system/vendor/etc/     # Complete 5-pillar MTK audio parameter overlays
    └── audio_param_reference/ # Raw OEM and calibrated audio tuning XML tables
```

---

## 🔊 1. Ultimate Audio Boost (MediaTek MT6769 / MT6358 5-Pillar Architecture)

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
| **Audio Boost (Magisk)**<br><sub>Hardware-calibrated MediaTek 5-pillar audio booster (~299 KB)</sub> | **File:** `N30A_AudioBoost_Magisk.zip`<br>**MD5:** `e38bee98a88d33c3dadfb38c4656d0ce`<br>**SHA-256:** `dd55fdfe8c561a2b28b330b067f125a5d41731e3d3111f05b64ffc4d38984bc6` |

---

## 🛠️ Installation Instructions

### Prerequisites
1. An unlocked bootloader on the **Realme Narzo 30A (`RMX3171`)**.
2. Root solution installed:
   * **Magisk:** v24.0 or newer (v30.7 recommended).
   * **KernelSU:** v0.6.0 or newer.
   * **APatch:** v10.7 or newer.

### Flashing via Root Manager
1. Download `N30A_AudioBoost_Magisk.zip` from [**Releases**](https://github.com/omi4real/Realme-Narzo-30A-Magisk-Addons/releases).
2. Open **Magisk** (or KernelSU / APatch).
3. Navigate to the **Modules** tab.
4. Select **Install from storage** and choose the downloaded ZIP.
5. Wait for the installation script to complete.
6. **Reboot** your device.

---

## 📄 License & Credits

* **License:** Apache License 2.0 (see [LICENSE](./LICENSE)).
* **Narzo 30A Port Project:** [Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial).
* **Hardware Research & Engineering:** omi4real.
