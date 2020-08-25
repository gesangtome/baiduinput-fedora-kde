#
# Created by 弱弱的胖橘猫 <gesangtome@foxmail.com>
# Last update: 2020-08-25 15:50:19
#
INPUTMETHOD := fcitx-baidupinyin.deb

WORKSPACE := temp
CONTROL_DIR := control
CONTROL_FILE := $(CONTROL_DIR).tar.gz
DATA_DIR := data
DATA_FILE := $(DATA_DIR).tar.xz

AR_TOOLS := ar
TAR_TOOLS := tar
RM_TOOLS := rm
CP_TOOLS := cp
LINK_TOOLS := ln
SUDO_TOOLS := sudo
SED_TOOLS := sed
BASH_TOOLS := bash

PROFILE_DIR := /etc/profile.d/
PROFILE_FILE := fcitx.sh
FCITX_AUTO_START_DIR := /home/$$USER/.config/autostart
FCITX_AUTO_START_FILE := fcitx.desktop
XDG_AUTO_START_DIR := /etc/xdg/autostart
XDG_AUTO_START_FILE := fcitx-ui-baidu-qimpanel.desktop

USR_DIR := /usr
ICON_DIR := $(USR_DIR)/share/icons
LOCALE_DIR := $(USR_DIR)/share/locale
APP_DIR := $(USR_DIR)/share/applications

BIN_DIR := $(USR_DIR)/bin
LIB_DIR := $(USR_DIR)/lib
SYMBOL_DIR := $(LIB_DIR)/x86_64-linux-gnu/fcitx
WATCHING_DOG := $(BIN_DIR)/bd-qimpanel.watchdog.sh
LIB1 := fcitx-baidupinyin.so
LIB2 := libbaiduiptcore.so
LIB3 := libconfparsor.so
FIX_PATH_TOOLS := fix_file_path.sh

# POSTINSTALL := $(WORKSPACE)/$(CONTROL_DIR)/postinst

#.PHONY: init checkout

define install-baidu-inputmethod
	@echo "Installing Baidu input method"
	@$(SUDO_TOOLS) $(CP_TOOLS) -r $(WORKSPACE)/$(DATA_DIR)/usr/* $(USR_DIR)
	@$(SUDO_TOOLS) $(CP_TOOLS) -r $(WORKSPACE)/$(DATA_DIR)/opt/apps/com.baidu.fcitx-baidupinyin/files/* $(USR_DIR)
	@$(SUDO_TOOLS) $(CP_TOOLS) -r $(WORKSPACE)/$(DATA_DIR)/opt/apps/com.baidu.fcitx-baidupinyin/entries/icons/* $(ICON_DIR)
	@$(SUDO_TOOLS) $(CP_TOOLS) -r $(WORKSPACE)/$(DATA_DIR)/opt/apps/com.baidu.fcitx-baidupinyin/entries/locale/* $(LOCALE_DIR)
	@$(SUDO_TOOLS) $(CP_TOOLS) -r $(WORKSPACE)/$(DATA_DIR)/opt/apps/com.baidu.fcitx-baidupinyin/entries/applications/* $(APP_DIR)
endef

define install-fcitx-framework
	@echo "Installing $(PROFILE_FILE)"
	@$(SUDO_TOOLS) $(CP_TOOLS) $(PROFILE_FILE) $(PROFILE_DIR)
	@echo "Installing $(FCITX_AUTO_START_FILE)"
	@$(CP_TOOLS) $(FCITX_AUTO_START_FILE) $(FCITX_AUTO_START_DIR)/
endef

define fix-file-path
	@echo "Fix executable file path"
	@$(BASH_TOOLS) $(FIX_PATH_TOOLS) $(APP_DIR)/$(XDG_AUTO_START_FILE) $(WATCHING_DOG) $(SUDO_TOOLS) $(SED_TOOLS)
endef

define fix-symbol-link
	@echo "Fix symbolic links: $(XDG_AUTO_START_FILE)"
	@$(SUDO_TOOLS) $(LINK_TOOLS) -sf $(APP_DIR)/$(XDG_AUTO_START_FILE) $(XDG_AUTO_START_DIR)/$(XDG_AUTO_START_FILE)
	@echo "Fix symbolic links: $(LIB1)"
	@$(SUDO_TOOLS) $(LINK_TOOLS) -sf $(LIB_DIR)/$(LIB1) $(SYMBOL_DIR)/$(LIB1)
	@echo "Fix symbolic links: $(LIB2)"
	@$(SUDO_TOOLS) $(LINK_TOOLS) -sf $(LIB_DIR)/$(LIB2) $(SYMBOL_DIR)/../$(LIB2)
	@echo "Fix symbolic links: $(LIB3)"
	@$(SUDO_TOOLS) $(LINK_TOOLS) -sf $(LIB_DIR)/$(LIB3) $(SYMBOL_DIR)/../$(LIB3)
endef

define cleanup-temporary-directory
	@echo "Cleaning up temporary directory: $(WORKSPACE)"
	@rm -rf $(WORKSPACE)
endef

all: init checkout extract filter install cleanup

init:
	@echo "Create directory: $(WORKSPACE)"
	@mkdir -p $(WORKSPACE) $(WORKSPACE)/$(CONTROL_DIR) $(WORKSPACE)/$(DATA_DIR)

checkout:
	@echo "Checkout file: $(CONTROL_FILE)"
	@$(AR_TOOLS) p \
			$(INPUTMETHOD) $(CONTROL_FILE) \
					> $(WORKSPACE)/$(CONTROL_FILE)

	@echo "Checkout file: $(DATA_FILE)"
	@$(AR_TOOLS) p \
			$(INPUTMETHOD) $(DATA_FILE) \
					> $(WORKSPACE)/$(DATA_FILE)

extract:
	@echo "Extract control scripts from $(CONTROL_FILE)"
	@$(TAR_TOOLS) -C \
			$(WORKSPACE)/$(CONTROL_DIR) \
					-zxf $(WORKSPACE)/$(CONTROL_FILE)

	@echo "Extract inputmethod data from $(DATA_FILE)"
	@$(TAR_TOOLS) -C \
			$(WORKSPACE)/$(DATA_DIR) \
					-xf $(WORKSPACE)/$(DATA_FILE)

filter:
	@echo "Filter duplicate files from $(DATA_FILE)"
	@$(RM_TOOLS) -rf \
			$(WORKSPACE)/$(DATA_DIR)/$(INPUTMETHOD)

install:
	$(call install-fcitx-framework)
	$(call install-baidu-inputmethod)
	$(call fix-symbol-link)
	$(call fix-file-path)
cleanup:
	@echo "Cleanup $(WORKSPACE)"
	@$(RM_TOOLS) -rf $(WORKSPACE)
