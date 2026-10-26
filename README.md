<div align="center">

# Realme Narzo 30A (RMX3171) - Magisk Addons Suite

[![Device](https://img.shields.io/badge/Device-Realme_Narzo_30A_(RMX3171)-blue?style=flat-square&logo=android)](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial)
[![SoC](https://img.shields.io/badge/SoC-MediaTek_Helio_G85-orange?style=flat-square)](https://www.mediatek.com)
[![Platform](https://img.shields.io/badge/Root-Magisk_/_KernelSU_/_APatch-brightgreen?style=flat-square)](https://github.com/topjohnwu/Magisk)
[![Companion ROM](https://img.shields.io/badge/ROM-%23keepQASSA-black?style=flat-square&logo=github)](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial)
[![Status](https://img.shields.io/badge/Status-Verified_/_Daily_Driver-success?style=flat-square)]()
[![Maintainer](https://img.shields.io/badge/Maintainer-omi4real-blueviolet?style=flat-square)](https://github.com/omi4real)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue?style=flat-square)](./LICENSE)

A curated suite of hardware-calibrated root modules built and tuned specifically for the **Realme Narzo 30A (`RMX3171`)** running Android 10 (#keepQASSA) or compatible AOSP custom ROMs.

Companion repository to the official [**Realme Narzo 30A #keepQASSA ROM Port**](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial).

[**Downloads**](#downloads) • [**Modules Overview**](#modules-overview) • [**Technical Architecture**](#technical-architecture) • [**Flashing Instructions**](#flashing-instructions) • [**Terminal Preview**](#terminal-preview) • [**Credits**](#credits)

</div>

---

> [!IMPORTANT]
> **Compatibility & Target Platform:** These modules are engineered and hardware-tested specifically for the **Realme Narzo 30A (`RMX3171`)** powered by the **MediaTek Helio G85 (`MT6769Z`)**. While designed for [#keepQASSA Android 10](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial), they are also compatible with other G85/MT6768 Android 10 custom ROMs and GSIs.

---

<a id="modules-overview"></a>
## 📦 Modules Overview

| Module Deliverable | Target Subsystems | Key Capabilities |
| :--- | :--- | :--- |
| **[🔊 1. Ultimate Audio Boost](#1-ultimate-audio-boost-v20)** | MediaTek MT6358 Codec & SIA8101 Amp | +15 dB analog line-out uncap, +6 dB earpiece boost, ringtone-grade DRC makeup gain, WideSound filter expansion, persistent ALSA mixer register lock. |
| **[⚡ 2. System & UI Enhancements](#2-system--ui-enhancements-v30)** | Framework, Settings, Launcher, Touch | Multi Audio Focus concurrent playback in Settings, responsive fast-motion launcher tap-drop fix, 180Hz gaming touch sampling rate, Schedutil/GED engine. |

---

<a id="technical-architecture"></a>
## 🔬 Technical Architecture & Deep Dive

### 1. Ultimate Audio Boost (v2.0)
* **Directory:** `audio_boost/`
* **Deliverable:** `N30A_AudioBoost_Magisk.zip`
* **Hardware Target:** MediaTek MT6769Z (Helio G85), MT6358 PMIC Codec, and SI-INTECH SIA8101 Class-D Speaker Amplifier.

#### Architectural Bottlenecks Solved
Stock Realme UI 1.0 clamped audio volume through multiple redundant software and hardware bottlenecks:
1. **Analog Codec Attenuation (`PlaybackVolAna_AudioParam.xml`):** Stock set `speaker_pga = 15` (-7 dB attenuation). Baseline vendor set `7` (+1 dB).
2. **Volume Curve Clamping (`VolumeGainMap_AudioParam.xml`):** `param_id="3"` (`SPK_LO`) hard-coded `dl_total_gain` and `dl_analog_gain` to `-1 dB` maximum across all 40 volume steps, overriding higher user settings.
3. **Music DRC Bypass (`PlaybackDRC_AudioParam.xml`):** Ringtones received full dynamic range compression (`DRC_Gn = 6144`), while music playback had zero dynamic makeup gain (`DRC_Gn = 0`), making media volume sound muffled compared to ringtones.
4. **Hardware Notch Filtering (`PlaybackACF_AudioParam.xml`):** An aggressive notch filter (`bes_loudness_L_bpf_gain = -1023`) heavily attenuated 300 Hz vocal frequencies, while WideSound gain was disabled (`WS_Gain_Max = 0x0`).
5. **Runtime Gain Reset:** During Android initialization, `AudioMTKGainController::setVoiceVolume` reset ALSA line-out gain registers to index `11` (-3 dB).

#### The 5-Pillar Calibration
* **Analog Line-Out Boost (+8 dB MAX):** Uncaps `speaker_pga` to index `0` (+8 dB analog headroom, a **+15 dB increase** over stock OEM).
* **In-Call Earpiece Boost (+6 dB):** Sets `receiver_pga` to index `2` for crystal-clear call audio.
* **VolumeGainMap Uncap:** Unlocks positive analog and total gain curves up to +8 dB in `SPK_LO`.
* **Digital Dynamic Range (+8 dB):** Unlocks positive digital gain steps up to +8 dB in `PlaybackVolDigi`.
* **Ringtone-Grade DRC Makeup:** Injects 6144 makeup gain and Sub-Band expansion into music playback.
* **Acoustic Filter Relaxation:** Removes the -1023 notch filter and enables `bes_loudness_WS_Gain_Max = 0x8` (+8 dB WideSound).
* **Late-Start Mixer Lock Daemon:** Bundles a static `tinymix` binary in `service.sh` that explicitly locks ALSA hardware registers (`Lineout_PGAL_GAIN = 0`, `ADDA_DL_GAIN = 65535`) after Android boot to prevent framework overrides.

---

### 2. System & UI Enhancements (v3.0)
* **Directory:** `system_enhancements/`
* **Deliverable:** `N30A_System_Enhancements_Magisk.zip`
* **Subsystems Patched:** `services.jar`, `Settings.apk`, `Launcher3QuickStep.apk`, `RealmeParts.apk`, Kernel sysfs.

#### Key Enhancements
* **🎵 Multi Audio Focus Framework (`services.jar`):**
  - Smali hook inside `com.android.server.audio.MediaFocusControl` skips `propagateFocusLossFromGain_syncAf` when `multi_audio_focus_enabled=1`.
  - Enables **simultaneous audio playback** across apps (e.g. YouTube app and Brave Browser playing together, podcast while navigating, or gaming with background music).
  - Priority protection preserved: incoming phone calls and alarms (`enteringRingOrCall`) immediately preempt background audio.
* **⚙️ KeepQassa Miscellaneous Toggle (`Settings.apk`):**
  - Injected `SystemSettingSwitchPreference` (`multi_audio_focus_enabled`) in `#keepQASSA -> Miscellaneous` directly below *"Show app volume"*.
  - Instant on-the-fly toggling between multi-audio and stock Android audio arbitration.
* **⚡ Responsive Fast-Motion Launcher (`Launcher3QuickStep.apk`):**
  - Bypasses `isFinishedSwitchingState()` in `ItemClickHandler.smali` to eliminate dropped/ignored app taps during homescreen transition animations.
  - Whitelists `android.permission.STOP_APP_SWITCHES` for instant zero-latency app launches.
* **🖐️ 180Hz Touch Sampling Suite (`RealmeParts.apk`):**
  - Provides a clean *"Smooth scrolling"* switch under `Realme Parts -> Display`.
  - Toggles `/proc/touchpanel/game_switch_enable` (180Hz high-frequency touch polling) and disables Oppo kernel touch throttling limits (`/proc/touchpanel/oppo_tp_limit_enable = 0`).
* **🚀 Kernel & Memory Performance Engine (`service.sh`):**
  - **Schedutil Frequency Latency:** Ramp-up latency lowered to `500μs` (instant core spin-up) and down-rate smoothed to `20000μs`.
  - **MediaTek GED GPU Governor:** Enables dynamic GPU boost on high-demand frame rendering.
  - **eMMC I/O Optimization:** Deadline scheduler with 512KB readahead for fast app startup.
  - **RAM Optimization:** `vm.swappiness = 80` for balanced ZRAM memory caching.

---

<a id="terminal-preview"></a>
## 📟 Terminal Flashing Preview

Both modules feature a clean, minimal ASCII art banner designed strictly under 38 columns to render without line-wrapping on any mobile terminal:

```text
    _   _ _____ ___    _   
   | \ | |___ // _ \  / \  
   |  \| | |_ \ | | |/ _ \ 
   | |\  |___) | |_| / ___ \ 
   |_| \_|____/\___//_/   \_\
 
  ==================================
      Realme Narzo 30A (RMX3171)    
        Created by @omi4real        
  ==================================
  -> N30A System & UI Enhancements  
  ----------------------------------
- Staging Multi Audio Focus (services.jar)
- Staging KeepQassa Misc Toggle (Settings.apk)
- Staging Responsive Launcher (Launcher3QuickStep.apk)
- Staging 180Hz Touch Suite (RealmeParts.apk)
- Applying kernel & schedutil governor engine
- Clearing stale ART runtime caches...
  ----------------------------------
- Done! Reboot to activate all enhancements.
```

---

<a id="downloads"></a>
## 📥 Downloads & Verified Checksums

| Module ZIP Package | File Size | MD5 Checksum | SHA-256 Checksum |
| :--- | :--- | :--- | :--- |
| **`N30A_AudioBoost_Magisk.zip`** | ~299 KB | `ca42cfa46518f99a12c3e31ef734c0fc` | `03ba5ee230e851caacae0f8b53b38f1f37adcd6a2261f09c79813e8a214b4c37` |
| **`N30A_System_Enhancements_Magisk.zip`** | ~38 MB | `4e7814dd9cce99a49511a7d159260556` | `011f3a87dff05bda98266235e2409b28fbfbbf6b0302f849472f02d9f8584ae0` |

---

<a id="flashing-instructions"></a>
## 📲 Installation Instructions

### Method 1: Via Magisk App (Recommended)
1. Download the desired module `.zip` to your device storage.
2. Open the **Magisk App** and navigate to the **Modules** tab.
3. Tap **Install from storage** and select the `.zip` file.
4. Verify the terminal flashing output and wait for the installer to finish.
5. Tap **Reboot**.

### Method 2: Via Custom Recovery (TWRP / OrangeFox)
1. Boot into recovery mode (`Power + Volume Down`).
2. Go to **Install** and select the `.zip` file from internal storage or SD card.
3. Swipe to confirm flash.
4. Reboot System.

---

<a id="credits"></a>
## 🌟 Credits & Acknowledgements

- **Lead Developer & Maintainer:** **[omi4real](https://github.com/omi4real)**
- **Hardware Target:** Realme Narzo 30A (`RMX3171`) / MediaTek Helio G85 (`MT6769Z`)
- **ROM Companion Base:** [#keepQASSA Android 10](https://github.com/omi4real/Realme-Narzo-30A-RMX3171-keepQASSA-Unofficial)
- **Root Framework:** [John Wu](https://github.com/topjohnwu) for Magisk

---

<div align="center">
Made with ❤️ for the Realme Narzo 30A Community.
</div>
