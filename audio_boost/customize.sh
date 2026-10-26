SKIPUNZIP=0

ui_print " "
ui_print "    _   _ _____ ___    _   "
ui_print "   | \ | |___ // _ \  / \  "
ui_print "   |  \| | |_ \ | | |/ _ \ "
ui_print "   | |\  |___) | |_| / ___ \ "
ui_print "   |_| \_|____/\___//_/   \_\\"
ui_print " "
ui_print "  =================================="
ui_print "      Realme Narzo 30A (RMX3171)    "
ui_print "        Created by @omi4real        "
ui_print "  =================================="
ui_print "  -> N30A Ultimate Audio Boost v2.0 "
ui_print "  ----------------------------------"
ui_print "- Uncapping Speaker Analog Line-out (+8dB MAX)"
ui_print "- Boosting In-Call Earpiece Gain (+6dB)"
ui_print "- Unlocking Full Digital Dynamic Range (+8dB)"
ui_print "- Injecting Ringtone-Grade DRC Makeup Gain"
ui_print "- Expanding BesLoudness WideSound Filter (+8dB)"
ui_print "- Installing ALSA hardware mixer daemon..."

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/bin/tinymix 0 0 0755

ui_print "  ----------------------------------"
ui_print "- Done! Reboot to unleash full speaker volume."
