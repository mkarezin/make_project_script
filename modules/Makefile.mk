MAKEFILE_FILE = $(PROJECT_DIR)/Makefile

MAKEFILE: $(MAKEFILE_FILE)

$(MAKEFILE_FILE):
	@echo "Creating $@"
	@echo "FIRMWARE = \$$(notdir \$$(CURDIR))" > $@
	@echo "VERSION = " >> $@
	@echo >> $@
	@echo "MCU = " >> $@
	@echo "PACKAGE = " >> $@
	@echo "F_CPU = " >> $@
	@echo >> $@
	@echo "#Output format. (can be srec, ihex, binary)" >> $@
	@echo "FORMAT = ihex" >> $@
	@echo >> $@
	@echo "BUILD_DIR = ./build" >> $@
	@echo >> $@
	@echo "SRC_DIR = ./src" >> $@
	@echo "SRC = \$$(shell find \$$(SRC_DIR) -name '*.$(type)' -type f)" >> $@
	@echo >> $@
	@echo "INC_DIR = ./inc" >> $@
	@if [ $(arch) = arm ]; then \
		echo >> $@; \
		echo "CCOMPILER_DIR = " >> $@; \
	fi
	@echo >> $@
	@echo "VERSION_HEADER = \$$(INC_DIR)/version.$(subst c,h,$(type))" >> $@
	@echo "VERSION_STRING = \$$(SRC_DIR)/version.$(type)" >> $@
	@echo >> $@
	@echo "OBJECTS := \$$(addprefix \$$(BUILD_DIR)/, \$$(SRC))" >> $@
	@echo "OBJECTS := \$$(OBJECTS:.c=.o)" >> $@
	@echo >> $@
	@echo "DEFINES = -DF_CPU=\$$(F_CPU)UL" >> $@
	@if [ $(arch) = avr ]; then \
		echo "DEFINES += -D__AVR_ATmega8__" >> $@; \
	fi
	@echo "DEFINES += " >> $@
	@echo >> $@
	@echo "CFLAGS = -O1 -g" >> $@
	@echo "CFLAGS += \$$(addprefix -I, \$$(INC_DIR))" >> $@
	@echo "CFLAGS += -mmcu=\$$(MCU)" >> $@
	@echo "CFLAGS += -fpack-struct" >> $@
	@echo "CFLAGS += -Wall" >> $@
	@echo "CFLAGS += -Wa,-adhlns=\$$(<:%.c=\$$(BUILD_DIR)/%.lst)" >> $@
	@echo "CFLAGS += \$$(DEFINES)" >> $@
	@echo >> $@
	@echo "LDFLAGS = -Wl,-Map=\$$(BUILD_DIR)/\$$(FIRMWARE).map,--cref" >> $@
	@echo "LDFLAGS += -Wl,--gc-sections" >> $@
	@echo >> $@
	@if [ $(type) = c ]; then \
		if [ $(arch) = avr ]; then \
			echo "CCOMPILER = avr-gcc" >> $@; \
		elif [ $(arch) = arm ]; then \
			echo "CCOMPILER = \$$(CCOMPILER_DIR)/armclang" >> $@; \
		else \
			echo "CCOMPILER = " >> $@; \
		fi; \
	elif [ $(type) = cpp ]; then \
		if [ $(arch) = avr ]; then \
			echo "CCOMPILER = avr-g++" >> $@; \
		else \
			echo "CCOMPILER = " >> $@; \
		fi; \
	fi
	@if [ $(arch) = avr ]; then \
		echo "SIZE = avr-size" >> $@; \
		echo "OBJCOPY = avr-objcopy" >> $@; \
		echo "OBJDUMP = avr-objdump" >> $@; \
		echo "AR = avr-ar rcs" >> $@; \
		echo "NM = avr-nm" >> $@; \
	elif [ $(arch) = arm ]; then \
		echo "SIZE = " >> $@; \
		echo "OBJCOPY = fromelf" >> $@; \
		echo "OBJDUMP = " >> $@; \
		echo "AR = armar" >> $@; \
		echo "NM = " >> $@; \
	fi
	@echo "REMOVE = rm -f" >> $@
	@echo "REMOVEDIR = rm -rf" >> $@
	@echo >> $@
	@if [ $(arch) = arm ]; then \
		echo "PROGRAMMER = " >> $@; \
	else \
		echo "PROGRAMMER = minipro" >> $@; \
		echo "PROGRAMMER_FLAGS = -p \$$(MCU)@\$$(PACKAGE)" >> $@; \
	fi
	@echo >> $@
	@echo "#----------- Debugging Options ------------" >> $@
	@echo "DEBUG_MFREQ = \$$(F_CPU)" >> $@
	@echo "#DEBUG_UI = gdb" >> $@
	@echo "DEBUG_UI = insight" >> $@
	@echo "DEBUG_BACKEND = avarice" >> $@
	@echo "#DEBUG_BACKEND = simulavr" >> $@
	@echo "GDBINIT_FILE = __avr_gdbinit" >> $@
	@echo "JTAG_DEV = /dev/com1" >> $@
	@echo "DEBUG_PORT = 4242" >> $@
	@echo "DEBUG_HOST = localhost" >> $@
	@echo >> $@
	@echo "GIT_BRANCH = \$$(shell git rev-parse --abbrev-ref HEAD)" >> $@
	@echo "GIT_HASH = \$$(shell git rev-parse HEAD)" >> $@
	@echo "GIT_HASH_SHORT = \$$(shell git rev-parse --short HEAD)" >> $@
	@echo "GIT_DATE = \$$(shell git show -s --format=%cD)" >> $@
	@echo >> $@
	@echo "MESSAGE_ERRORS_NONE = Errors: none" >> $@
	@echo "MESSAGE_BEGIN = -------- begin --------" >> $@
	@echo "MESSAGE_END = --------  end  --------" >> $@
	@echo "MESSAGE_SIZE_BEFORE = Size before:" >> $@
	@echo "MESSAGE_SIZE_AFTER = Size after:" >> $@
	@echo "MESSAGE_COFF = Converting to AVR COFF:" >> $@
	@echo "MESSAGE_ENTENDED_COFF = Converting to AVR Extended COFF:" >> $@
	@echo "MESSAGE_FLASH = Creating load file for Flash:" >> $@
	@echo "MESSAGE_EEPROM = Creting load file for EEPROM:" >> $@
	@echo "MESSAGE_EXTENDED_LISTING = Creating Extended Listing:" >> $@
	@echo "MESSAGE_SYMBOL_TABLE = Creating Symbol Table:" >> $@
	@echo "MESSAGE_LINKING = Linking:" >> $@
	@if [ $(type) = c ]; then \
		echo "MESSAGE_COMPILING_C = Compiling C:" >> $@; \
	elif [ $(type) = cpp ]; then \
		echo "MESSAGE_COMPILING_CPP = Compiling C++:" >> $@; \
	fi
	@echo "MESSAGE_ASSEMBLING = Assembling:" >> $@
	@echo "MESSAGE_CLEANING = Cleaning project:" >> $@
	@echo "MESSAGE_CREATING_LIBRARY = Creating library:" >> $@
	@echo "MESSAGE_FUSE = Creating Fuse file:" >> $@
	@echo >> $@
	@echo "define _create_fuses_file_script" >> $@
	@echo "cat <<'EOF' > \$$@" >> $@
	@echo "lfuse = 0x\$$(shell \$$(OBJDUMP) -j .fuse -s \$$(BUILD_DIR)/\$$(FIRMWARE).elf | grep \"^\\s\" | cut -d\" \" -f3 | cut -c1-2)" >> $@
	@echo "hfuse = 0x\$$(shell \$$(OBJDUMP) -j .fuse -s \$$(BUILD_DIR)/\$$(FIRMWARE).elf | grep \"^\\s\" | cut -d\" \" -f3 | cut -c3-4)" >> $@
	@echo "lock = 0x\$$(shell \$$(OBJDUMP) -j .lock -s \$$(BUILD_DIR)/\$$(FIRMWARE).elf | grep \"^\\s\" | cut -d\" \" -f3 | cut -c1-2)" >> $@
	@echo >> $@
	@echo "EOF" >> $@
	@echo "endef" >> $@
	@echo >> $@
	@echo "all: begin gccversion sizebefore build sizeafter end" >> $@
	@echo >> $@
	@echo "begin:" >> $@
	@echo "\t@echo \$$(MESSAGE_BEGIN)" >> $@
	@echo "\t@echo \"Source files: \$$(SRC)\"" >> $@
	@echo "\t@echo \"Object files: \$$(OBJECTS)\"" >> $@
	@echo >> $@
	@echo "gccversion:" >> $@
	@echo "\t@\$$(CCOMPILER) --version" >> $@
	@echo >> $@
	@echo "HEXSIZE = \$$(SIZE) --target=\$$(FORMAT) \$$(BUILD_DIR)/\$$(FIRMWARE).hex" >> $@
	@echo "ELFSIZE = \$$(SIZE) --mcu=\$$(MCU) --format=avr \$$(BUILD_DIR)/\$$(FIRMWARE).elf" >> $@
	@echo >> $@
	@echo "sizebefore:" >> $@
	@echo "\t@if test -f \$$(BUILD_DIR)/\$$(FIRMWARE).elf; then echo; \\" >> $@
	@echo "\techo \$$(MESSAGE_SIZE_BEFORE); \$$(ELFSIZE); \\" >> $@
	@echo "\t2>/dev/null; fi" >> $@
	@echo >> $@
	@echo "build: elf hex eep lss sym fuse" >> $@
	@echo >> $@
	@echo "elf: \$$(BUILD_DIR)/\$$(FIRMWARE).elf" >> $@
	@echo "hex: \$$(BUILD_DIR)/\$$(FIRMWARE).hex" >> $@
	@echo "eep: \$$(BUILD_DIR)/\$$(FIRMWARE).eep" >> $@
	@echo "lss: \$$(BUILD_DIR)/\$$(FIRMWARE).lss" >> $@
	@echo "sym: \$$(BUILD_DIR)/\$$(FIRMWARE).sym" >> $@
	@echo "fuse: \$$(BUILD_DIR)/\$$(FIRMWARE).fuse" >> $@
	@echo >> $@
	@echo "sizeafter:" >> $@
	@echo "\t@if test -f \$$(BUILD_DIR)/\$$(FIRMWARE).elf; then echo; \\" >> $@
	@echo "\techo \$$(MESSAGE_SIZE_AFTER); \$$(ELFSIZE); \\" >> $@
	@echo "\t2>/dev/null; fi" >> $@
	@echo >> $@
	@echo "end:" >> $@
	@echo "\t@echo \$$(MESSAGE_END)" >> $@
	@echo >> $@
	@echo "program: \$$(BUILD_DIR)/\$$(FIRMWARE).hex \$$(BUILD_DIR)/\$$(FIRMWARE).eep \$$(BUILD_DIR)/\$$(FIRMWARE).fuse" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -w \$$(BUILD_DIR)/\$$(FIRMWARE).hex -c code" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -w \$$(BUILD_DIR)/\$$(FIRMWARE).eep -c data -e" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -w \$$(BUILD_DIR)/\$$(FIRMWARE).fuse -c config" >> $@
	@echo >> $@
	@echo "verify:" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -m \$$(BUILD_DIR)/\$$(FIRMWARE).hex -c code" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -m \$$(BUILD_DIR)/\$$(FIRMWARE).eep -c data" >> $@
	@echo "\t\$$(PROGRAMMER) \$$(PROGRAMMER_FLAGS) -m \$$(BUILD_DIR)/\$$(FIRMWARE).fuse -c config" >> $@
	@echo >> $@
	@echo ".SECONDARY: \$$(BUILD_DIR)/\$$(FIRMWARE).elf" >> $@
	@echo ".PRECIOUS: \$$(OBJECTS)" >> $@
	@echo "%.elf: \$$(VERSION_STRING) \$$(OBJECTS)" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_LINKING) \$$@" >> $@
	@echo "\t@\$$(CCOMPILER) \$$(CFLAGS) \$$^ -o \$$@ \$$(LDFLAGS)" >> $@
	@echo >> $@
	@echo "%.hex: %.elf" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_FLASH) \$$@" >> $@
	@echo "\t@\$$(OBJCOPY) -O \$$(FORMAT) -R .eeprom -R .fuse -R .lock -R .signature \$$< \$$@" >> $@
	@echo >> $@
	@echo "%.eep: %.elf" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_EEPROM) \$$@" >> $@
	@echo "\t@-\$$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom=\"alloc,load\" --change-section-lma .eeprom=0 --no-change-warnings -O \$$(FORMAT) \$$< \$$@ || exit 0" >> $@
	@echo >> $@
	@echo ".ONESHELL:" >> $@
	@echo "%.fuse: %.elf" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_FUSE) \$$@" >> $@
	@echo "\t\$$(_create_fuse_file_script)" >> $@
	@echo >> $@
	@echo "%.lss: %.elf" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_EXTENDED_LISTING) \$$@" >> $@
	@echo "\t@\$$(OBJDUMP) -h -S -z \$$< > \$$@" >> $@
	@echo >> $@
	@echo "%.sym: %.elf" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_SYMBOL_TABLE) \$$@" >> $@
	@echo "\t@\$$(OBJDUMP) -h -S -z \$$< > \$$@" >> $@
	@echo >> $@
	@echo "\$$(BUILD_DIR)/%.o: %.c ./inc/config.$(subst c,h,$(type))" >> $@
	@echo "\t@\$$(shell [ ! -d \"\$$(BUILD_DIR)\" ] && mkdir \$$(BUILD_DIR))" >> $@
	@echo "\t@\$$(shell [ ! -d \"\$$(BUILD_DIR)/\$$(dir \$$<)\" ] && mkdir \$$(BUILD_DIR)/\$$(dir \$$<))" >> $@
	@echo "\t@echo" >> $@
	@if [ $(type) = c ]; then \
		echo "\t@echo \$$(MESSAGE_COMPILING_C) \$$<" >> $@; \
	elif [ $(type) = cpp ]; then \
		echo "\t@echo \$$(MESSAGE_COMPILING_CPP) \$$<" >> $@; \
	fi
	@echo "\t@\$$(CCOMPILER) -c \$$(CFLAGS) \$$< -o \$$@" >> $@
	@echo "\t@\$$(CCOMPILER) -MM \$$(CFLAGS) \$$< > \$$(BUILD_DIR)/\$$*.d" >> $@
	@echo >> $@
	@echo "\$$(BUILD_DIR)/%.s: %.c" >> $@
	@echo "\t@\$$(shell [ ! -d \"\$$(BUILD_DIR)\" ] && mkdir -p \$$(BUILD_DIR))" >> $@
	@echo "\t@\$$(shell [ ! -d \"\$$(BUILD_DIR)/\$$(dir \$$<)\" ] && mkdir -p \$$(BUILD_DIR)/\$$(dir \$$<))" >> $@
	@echo "\t@\$$(CCOMPILER) -S \$$(CFLAGS) \$$< -o \$$@" >> $@
	@echo >> $@
	@echo "\$$(VERSION_HEADER):" >> $@
	@echo "\t@echo \"Creating \$$@\"" >> $@
	@echo "\t@echo \"/*\" > \$$@" >> $@
	@echo "\t@echo \" * This file is automatically generated. Do not edit.\" >> \$$@" >> $@
	@echo "\t@echo \" */\" >> \$$@" >> $@
	@echo "\t@echo >> \$$@" >> $@
	@echo "\t@echo \"#define VERSION \\\"\$$(VERSION)\\\"\" >> \$$@" >> $@
	@echo "\t@echo \"#define GIT_BRANCH \\\"\$$(GIT_BRANCH)\\\"\" >> \$$@" >> $@
	@echo "\t@echo \"#define GIT_HASH \\\"\$$(GIT_HASH)\\\"\" >> \$$@" >> $@
	@echo "\t@echo \"#define GIT_HASH_SHORT \\\"\$$(GIT_HASH_SHORT)\\\"\" >> \$$@" >> $@
	@echo "\t@echo \"#define GIT_DATE \\\"\$$(GIT_DATE)\\\"\" >> \$$@" >> $@
	@echo "\t@echo >> \$$@" >> $@
	@echo >> $@
	@echo "\$$(VERSION_STRING): \$$(VERSION_HEADER)" >> $@
	@echo "\t@echo \"Creating \$$@\"" >> $@
	@echo "\t@echo \"/*\" > \$$@" >> $@
	@echo "\t@echo \" * This file is automatically generated. Do not edit.\" >> \$$@" >> $@
	@echo "\t@echo \" */\" >> \$$@" >> $@
	@echo "\t@echo >> \$$@" >> $@
	@echo "\t@echo \"#include \\\"version.$(subst c,h,$(type))\\\"\" >> \$$@" >> $@
	@echo "\t@echo >> \$$@" >> $@
	@echo >> $@
	@echo "clean: begin clean_list end" >> $@
	@echo >> $@
	@echo "clean_list:" >> $@
	@echo "\t@echo" >> $@
	@echo "\t@echo \$$(MESSAGE_CLEANING)" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).hex" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).eep" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).cof" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).elf" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).map" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).sym" >> $@
	@echo "\t\$$(REMOVE) \$$(BUILD_DIR)/\$$(FIRMWARE).lss" >> $@
	@echo "\t\$$(REMOVE) \$$(VERSION_HEADER)" >> $@
	@echo "\t\$$(REMOVE) \$$(VERSION_STRING)" >> $@
	@echo "\t\$$(REMOVE) \$$(OBJECTS)" >> $@
	@echo "\t\$$(REMOVE) \$$(OBJECTS:%.o=%.lst)" >> $@
	@echo "\t\$$(REMOVEDIR) \$$(BUILD_DIR)" >> $@
	@echo >> $@
	@echo "test:" >> $@
	@echo "\techo \$$(PROGRAMMER_FLAGS)" >> $@
	@echo >> $@
	@echo "-include \$$(OBJECTS:.o=.d)" >> $@
	@echo >> $@
	@echo ".PHONY: all begin gccversion sizebefore build \\" >> $@
	@echo "\telf hex eep lss sym fuse sizeafter end programm \\" >> $@
	@echo "\tverify clean clean_list test" >> $@
