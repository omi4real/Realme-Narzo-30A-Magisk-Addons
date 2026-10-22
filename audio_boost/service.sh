#!/system/bin/sh
MODDIR=${0%/*}

# Wait for boot completion
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

TARGET="/vendor/etc/audio_param/oppo6769_206AC_533/PlaybackVolAna_AudioParam.xml"
SOURCE="$MODDIR/system/vendor/etc/audio_param/oppo6769_206AC_533/PlaybackVolAna_AudioParam.xml"

if [ -f "$TARGET" ] && [ -f "$SOURCE" ]; then
    mount --bind "$SOURCE" "$TARGET"
    setprop ctl.restart audioserver
    setprop ctl.restart vendor.audio-hal-2-0
fi
