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
ui_print "  -> N30A Performance Engine v1.0   "
ui_print "  ----------------------------------"
ui_print "- Schedutil Latency Tuning (500us)"
ui_print "- MediaTek GED GPU Smart Boost Active"
ui_print "- eMMC 5.1 Deadline I/O & 512KB Cache"
ui_print "- ZRAM Thrashing Reduction (Swappiness 80)"
ui_print "- Realme 180Hz Touch Polling Engine"
ui_print "- MediaTek PPM Deep Sleep Profile"

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print "  ----------------------------------"
ui_print "- Done! Performance engine installed."
