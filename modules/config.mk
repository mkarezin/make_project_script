CONFIG_HEADER = $(PROJECT_DIR)/inc/config.$(subst c,h,$(type))

CONFIG: $(CONFIG_HEADER)

$(CONFIG_HEADER):
	@echo "Creating $@"
	@echo "#ifndef _CONFIG_H_" > $@
	@echo "#define _CONFIG_H_" >> $@
	@echo >> $@
	@echo >> $@
	@echo >> $@
	@echo "#endif // _CONFIG_H_" >> $@
