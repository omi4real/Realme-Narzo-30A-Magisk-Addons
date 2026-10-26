#!/system/bin/sh
# Narzo 30A (RMX3171) Butter & Fluidity Performance Engine
# Optimizes CPU/GPU frequency scaling, memory/ZRAM retention, I/O latency, touch polling, and battery sleep.

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# 1. CPU Schedutil Responsiveness (Reduce frequency ramping latency from 10ms to 0.5ms)
echo 500 > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us 2>/dev/null
echo 20000 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us 2>/dev/null

# 2. MediaTek Graphics Environment Daemon (GED) Smart Boost & GPU Responsiveness
echo 1 > /sys/module/ged/parameters/ged_smart_boost 2>/dev/null
echo 1 > /sys/module/ged/parameters/boost_gpu_enable 2>/dev/null
echo 1 > /sys/module/ged/parameters/enable_gpu_boost 2>/dev/null
echo 1 > /sys/module/ged/parameters/enable_cpu_boost 2>/dev/null

# 3. Flash Storage I/O Optimization (eMMC 5.1 Deadline scheduler & 512KB burst read-ahead)
echo deadline > /sys/block/mmcblk0/queue/scheduler 2>/dev/null
echo 512 > /sys/block/mmcblk0/queue/read_ahead_kb 2>/dev/null

# 4. RAM Management & ZRAM Thrashing Reduction
echo 80 > /proc/sys/vm/swappiness 2>/dev/null
echo 50 > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
echo 5 > /proc/sys/vm/dirty_background_ratio 2>/dev/null
echo 15 > /proc/sys/vm/dirty_ratio 2>/dev/null

# 5. MediaTek Power Policy Manager (PPM) Display-Off Ultra-Low Power Sleep Policy
echo 9 1 > /proc/ppm/policy_status 2>/dev/null

# 6. Battery Saving: Radio & Scan Optimization
settings put global wifi_scan_throttle_enabled 1 2>/dev/null
settings put global mobile_data_always_on 0 2>/dev/null

# 7. Animation Fluidity & High-Speed Pacing (0.75x)
settings put global window_animation_scale 0.75 2>/dev/null
settings put global transition_animation_scale 0.75 2>/dev/null
settings put global animator_duration_scale 0.75 2>/dev/null

# 8. Realme Smooth Scrolling & High-Rate Touch Engine (180Hz Polling & Zero-Drag Limit)
echo 1 > /proc/touchpanel/game_switch_enable 2>/dev/null
echo 0 > /proc/touchpanel/oppo_tp_limit_enable 2>/dev/null
echo 1 > /proc/touchpanel/oppo_tp_direction 2>/dev/null

# 9. Force Disable Legacy AbsListView Drawing Cache for Pure GPU-Accelerated Scrolling
setprop persist.sys.scrollingcache 3 2>/dev/null
