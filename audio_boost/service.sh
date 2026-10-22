#!/system/bin/sh
MODDIR=${0%/*}

# Wait for boot completion
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

# Ensure all 5 audio parameter overlays are cleanly mounted over vendor
VDIR="/vendor/etc/audio_param/oppo6769_206AC_533"
SDIR="$MODDIR/system/vendor/etc/audio_param/oppo6769_206AC_533"

for xml in PlaybackVolAna_AudioParam.xml PlaybackVolDigi_AudioParam.xml VolumeGainMap_AudioParam.xml PlaybackDRC_AudioParam.xml PlaybackACF_AudioParam.xml; do
    if [ -f "$VDIR/$xml" ] && [ -f "$SDIR/$xml" ]; then
        mount --bind "$SDIR/$xml" "$VDIR/$xml"
    fi
done

# Reload HAL to digest new XML parameters
setprop ctl.restart vendor.audio-hal-2-0
setprop ctl.restart audioserver

# Give HAL a moment to initialize
sleep 2

# Explicitly lock hardware ALSA mixer registers via bundled static tinymix
if [ -x "$MODDIR/bin/tinymix" ]; then
    "$MODDIR/bin/tinymix" Lineout_PGAL_GAIN 0 2>/dev/null || true
    "$MODDIR/bin/tinymix" Lineout_PGAR_GAIN 0 2>/dev/null || true
    "$MODDIR/bin/tinymix" Headset_PGAL_GAIN 0 2>/dev/null || true
    "$MODDIR/bin/tinymix" Headset_PGAR_GAIN 0 2>/dev/null || true
    "$MODDIR/bin/tinymix" ADDA_DL_GAIN 65535 2>/dev/null || true
fi
