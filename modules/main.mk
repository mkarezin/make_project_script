MAIN_SOURCE = $(PROJECT_DIR)/src/main.$(type)
MAIN_HEADER = $(PROJECT_DIR)/inc/main.$(subst c,h,$(type))

MAIN: $(MAIN_SOURCE) $(MAIN_HEADER)

$(MAIN_SOURCE):
	@echo "Creating $@"
	@echo "#include \"main.$(subst c,h,$(type))\"" > $@
	@echo "#include \"config.$(subst c,h,$(type))\"" >> $@
	@echo "#include \"init.$(subst c,h,$(type))\"" >> $@
	@echo >> $@
	@if [ $(type) = c ]; then \
		echo "int main(void)" >> $@; \
	elif [ $(type) = cpp ]; then \
		echo "int main()" >> $@; \
	fi
	@echo "{" >> $@
	@echo "\tmcuInit();" >> $@
	@echo >> $@
	@echo "\tfor (;;)" >> $@
	@echo "\t{" >> $@
	@echo "\t\t_NOP();" >> $@
	@echo "\t}" >> $@
	@echo "}" >> $@

$(MAIN_HEADER):
	@echo "Creating $@"
	@echo "#ifndef _MAIN_H_" > $@
	@echo "#define _MAIN_H_" >> $@
	@echo >> $@
	@echo >> $@
	@echo >> $@
	@echo "#endif // _MAIN_H_" >> $@
