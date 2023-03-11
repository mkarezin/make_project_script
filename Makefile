UPPER_DIR = ..

name = new_project
type = c
launch_vscode = yes
arch = arm

PROJECT_DIR = $(UPPER_DIR)/$(name)

help:
	@echo "Usage: make target [options]"
	@echo
	@echo "Targets information:"
	@echo "  help - show this message"
	@echo "  project - create a project"
	@echo "  delete - recursively remove the project directory"
	@echo
	@echo "Options information:"
	@echo "  name - project name (\"new_project\" - by default)"
	@echo "  type - project type (can be c or cpp, \"c\" - by default)"
	@echo "  launch_vscode - determines whether to launch the vscode (can be yes or no, \"yes\" - by default)"
	@echo "  arch - MCU architecture (can be arm, avr, pic, \"arm\" - by default)"

project: create_project_structure create_files launch_vscode

create_project_structure:
	$(shell [ ! -d "$(PROJECT_DIR)" ] && mkdir $(PROJECT_DIR))
	$(shell [ ! -d "$(PROJECT_DIR)/src" ] && mkdir $(PROJECT_DIR)/src)
	$(shell [ ! -d "$(PROJECT_DIR)/inc" ] && mkdir $(PROJECT_DIR)/inc)

create_files: MAKEFILE CONFIG INIT MAIN GITIGNORE

launch_vscode:
	@if [ $(launch_vscode) = yes ]; then \
		code $(PROJECT_DIR)/; \
	fi

delete:
	rm -rf $(PROJECT_DIR)/

test:


include modules/config.mk
include modules/init.mk
include modules/main.mk
include modules/Makefile.mk
include modules/.gitignore.mk

.PHONY: help project create_project_structure \
	create_files launch_vscode delete test
