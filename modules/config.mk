CONFIG_HEADER = $(PROJECT_DIR)/inc/config.$(subst c,h,$(type))

CONFIG: $(CONFIG_HEADER)

$(CONFIG_HEADER):
	@echo "Creating $@"
	@echo "#pragma once" > $@
	@echo >> $@
