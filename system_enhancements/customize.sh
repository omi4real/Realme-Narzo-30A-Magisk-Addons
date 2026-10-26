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
ui_print "  -> N30A System & UI Enhancements  "
ui_print "  ----------------------------------"
ui_print "- Staging Multi Audio Focus (services.jar)"
ui_print "- Staging KeepQassa Misc Toggle (Settings.apk)"
ui_print "- Staging Responsive Launcher (Launcher3QuickStep.apk)"
ui_print "- Staging 180Hz Touch Suite (RealmeParts.apk)"
ui_print "- Applying kernel & schedutil governor engine"

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

# Invalidate stale dalvik-cache for cleanly staged system packages
ui_print "- Clearing stale ART runtime caches..."
rm -rf /data/dalvik-cache/arm64/system@framework@services.jar@*
rm -rf /data/dalvik-cache/arm64/system@priv-app@RealmeParts@*
rm -rf /data/dalvik-cache/arm64/system@product@priv-app@Settings@*
rm -rf /data/dalvik-cache/arm64/system@product@priv-app@Launcher3QuickStep@*

ui_print "  ----------------------------------"
ui_print "- Done! Reboot to activate all enhancements."
