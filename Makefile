ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PasteAndGo2

PasteAndGo2_FILES = Tweak.x
PasteAndGo2_CFLAGS = -fobjc-arc

PasteAndGo2_PRIVATE_FRAMEWORKS = BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	mkdir -p "$(THEOS_STAGING_DIR)/Library/Application Support/PasteAndGo2.bundle"
	cp -R Resources/* "$(THEOS_STAGING_DIR)/Library/Application Support/PasteAndGo2.bundle/"

after-install::
	install.exec "killall -9 SpringBoard"
	
include $(THEOS_MAKE_PATH)/aggregate.mk
