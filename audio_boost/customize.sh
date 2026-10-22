SKIPUNZIP=0

ui_print "************************************************"
ui_print "       N30A Audio Boost Addon (RMX3171)         "
ui_print "            #keepQASSA Android 10               "
ui_print "************************************************"
ui_print "- Boosting Speaker Analog Gain (+4dB)"
ui_print "- Boosting Earpiece Gain (+6dB)"
ui_print "- Installing audio parameter overlays..."

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print "- Done! Reboot to apply hardware audio boost."
