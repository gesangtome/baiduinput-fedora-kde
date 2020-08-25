#
# Created by 弱弱的胖橘猫 <gesangtome@foxmail.com>
# Last update: 2020-08-25 01:14:33
#

WORKSPACE := temp
INPUTMETHOD := fcitx-baidupinyin.deb
CONTROL_DIR := control
CONTROL_FILE := $(CONTROL_DIR).tar.gz
DATA_DIR := inputmethod
DATA_FILE := data.tar.xz
AR_TOOLS := ar
TAR_TOOLS := tar
RM_TOOLS := rm

#.PHONY: init checkout

all: init checkout extract filter

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
