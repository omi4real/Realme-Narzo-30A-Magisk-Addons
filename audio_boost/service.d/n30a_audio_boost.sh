#!/system/bin/sh
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
TARGET=/vendor/etc/audio_param/oppo6769_206AC_533/PlaybackVolAna_AudioParam.xml
if [ -f "$TARGET" ] && [ -f "$MODDIR/PlaybackVolAna_AudioParam.xml" ]; then
    mount --bind "$MODDIR/PlaybackVolAna_AudioParam.xml" "$TARGET"
    setprop ctl.restart audioserver
    setprop ctl.restart vendor.audio-hal-2-0
fi
