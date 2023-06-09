.PHONY: all clean dump
.DEFAULT_GOAL := all

SRC_DIR := src
MIRROR_DIR := $(SRC_DIR)/mirrors
TEMPLATE_FILE := $(SRC_DIR)/main.sh.template
MIRROR_FILES := $(wildcard $(MIRROR_DIR)/*)
OUT_DIR := output
OUT_FILE := $(OUT_DIR)/hust-mirror.sh
OUT_MIRROR_DIR := $(OUT_DIR)/mirrors
OUT_MIRROR_FILES := $(patsubst $(MIRROR_DIR)/%,$(OUT_MIRROR_DIR)/%,$(MIRROR_FILES))

all: $(OUT_FILE)
	@echo "Done, object script is $(OUT_FILE)."

$(OUT_FILE): $(MIRROR_DIR)
	@mkdir -p $(OUT_DIR)
	@cp $(TEMPLATE_FILE) $(OUT_FILE)

$(MIRROR_DIR): $(OUT_MIRROR_FILES)
	@:

$(OUT_MIRROR_FILES): $(OUT_MIRROR_DIR)/%: $(MIRROR_DIR)/%
	@echo "Process $<"
	@mkdir -p $(OUT_MIRROR_DIR)
	@cp $< $@

clean:
	@rm -rf $(OUT_DIR)
	@echo "Cleaned."

dump:
	$(foreach v, \
		$(shell echo "$(filter-out .VARIABLES,$(.VARIABLES))" | tr ' ' '\n' | sort), \
		$(info $(shell printf "%-20s" "$(v)")= $(value $(v))) \
	)

# vim: set noexpandtab ts=4 sw=4 ft=make:
