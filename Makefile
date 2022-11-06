DESTINATION_DIR = ..

name = new_project
type = c

PROJECT_DIR = $(DESTINATION_DIR)/$(name)

help:
	@echo "Usage: make target [options]"
	@echo
	@echo "Targets information:"
	@echo "  help - show this message"
	@echo "  project - create project with given name and type"
	@echo "  delete - delete project folder with all content recursively"

project: create_project_structure create_files #launch_vscode

create_project_structure:
	$(shell [ ! -d "$(PROJECT_DIR)" ] && mkdir $(PROJECT_DIR))
	$(shell [ ! -d "$(PROJECT_DIR)/src" ] && mkdir $(PROJECT_DIR)/src)
	$(shell [ ! -d "$(PROJECT_DIR)/inc" ] && mkdir $(PROJECT_DIR)/inc)

create_files: MAKEFILE CONFIG INIT MAIN GITIGNORE

launch_vscode:
	@code $(PROJECT_DIR)/

delete:
	@rm -rf $(PROJECT_DIR)/

test:


include modules/config.mk
include modules/init.mk
include modules/main.mk
include modules/Makefile.mk
include modules/.gitignore.mk

.PHONY: help project create_project_structure \
	create_files launch_vscode delete test
