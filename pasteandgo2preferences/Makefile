include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PasteAndGo2Preferences

PasteAndGo2Preferences_FILES = PAGRootListController.m
PasteAndGo2Preferences_INSTALL_PATH = /Library/PreferenceBundles
PasteAndGo2Preferences_FRAMEWORKS = UIKit
PasteAndGo2Preferences_PRIVATE_FRAMEWORKS = Preferences
PasteAndGo2Preferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PasteAndGo2Preferences.plist$(ECHO_END)
