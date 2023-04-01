ARCHS ?= armv7 armv7s arm64 arm64e
TARGET ?= iphone:clang:14.5:8.0

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = RootBridge

RootBridge_FILES = RootBridge.m
RootBridge_INSTALL_PATH = /Library/Frameworks
RootBridge_CFLAGS = -fobjc-arc -IHeaders
RootBridge_LDFLAGS = -install_name @rpath/RootBridge.framework/RootBridge
RootBridge_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/framework.mk
