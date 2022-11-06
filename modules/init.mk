INIT_SOURCE = $(PROJECT_DIR)/src/init.$(type)
INIT_HEADER = $(PROJECT_DIR)/inc/init.$(subst c,h,$(type))

INIT: $(INIT_SOURCE) $(INIT_HEADER)

$(INIT_SOURCE):
	@echo "Creating $@"
	@echo "#include \"init.$(subst c,h,$(type))\"" > $@
	@echo >> $@
	@if [ $(type) = c ]; then \
		echo "void mcuInit(void)" >> $@; \
	elif [ $(type) = cpp ]; then \
		echo "void mcuInit()" >> $@; \
	fi
	@echo "{" >> $@
	@echo "\treturn;" >> $@
	@echo "}" >> $@
	@echo >> $@

$(INIT_HEADER):
	@echo "Creating $@"
	@echo "#pragma once" > $@
	@echo >> $@
	@if [ $(type) = c ]; then \
		echo "void mcuInit(void);" >> $@; \
	elif [ $(type) = cpp ]; then \
		echo "void mcuInit();" >> $@; \
	fi
	@echo >> $@
