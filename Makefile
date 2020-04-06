ARCHS = arm64 arm64e
<<<<<<< HEAD
=======

>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PasteAndGo2

PasteAndGo2_FILES = Tweak.x
PasteAndGo2_CFLAGS = -fobjc-arc
<<<<<<< HEAD
=======

>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
PasteAndGo2_PRIVATE_FRAMEWORKS = BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	mkdir -p "$(THEOS_STAGING_DIR)/Library/Application Support/PasteAndGo2.bundle"
	cp -R Resources/* "$(THEOS_STAGING_DIR)/Library/Application Support/PasteAndGo2.bundle/"

after-install::
<<<<<<< HEAD
	install.exec "killall -9 SpringBoard"
=======
	install.exec "killall -9 SpringBoard"
	
include $(THEOS_MAKE_PATH)/aggregate.mk
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
