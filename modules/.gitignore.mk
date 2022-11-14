GITIGNORE_FILE = $(PROJECT_DIR)/.gitignore

GITIGNORE: $(GITIGNORE_FILE)

$(GITIGNORE_FILE):
	@echo "Creating $@"
	@echo ".vscode" > $@
	@echo "build" >> $@
	@echo "*/version.*" >> $@
