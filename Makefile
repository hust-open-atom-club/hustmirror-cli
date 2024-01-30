.PHONY: all clean dump test
.DEFAULT_GOAL := all

SRC_DIR := src
INCLUDE_FILES := $(wildcard $(SRC_DIR)/*.sh)
MIRROR_DIR := $(SRC_DIR)/mirrors
TEMPLATE_FILE := $(SRC_DIR)/main.sh
MIRROR_FILES := $(wildcard $(MIRROR_DIR)/*)
OTHER_FILES := $(SRC_DIR)/config.cfg
OUT_DIR := output
OUT_FILE := $(OUT_DIR)/hustmirror-cli
OUT_MIRROR_DIR := $(OUT_DIR)/mirrors
OUT_MIRROR_FILES := $(patsubst $(MIRROR_DIR)/%,$(OUT_MIRROR_DIR)/%,$(MIRROR_FILES))
INSTALL_DIR := /usr/local/bin/

all: $(OUT_FILE)
	@echo "Done, object script is $(OUT_FILE)."

test: $(OUT_FILE)
	@tests/test.sh

install: $(OUT_FILE)
	@cp $(OUT_FILE) $(INSTALL_DIR)

$(OUT_FILE): $(TEMPLATE_FILE) $(OUT_MIRROR_FILES) $(INCLUDE_FILES) $(OTHER_FILES)
	@mkdir -p $(OUT_DIR)
	@echo "Process $<"
	@scripts/template-instantiate.py $< > $@.tmp
	@grep -E -v "vim:.+:" $@.tmp > $@
	@rm $@.tmp
	@chmod +x $@

$(OUT_MIRROR_FILES): $(OUT_MIRROR_DIR)/%: $(MIRROR_DIR)/%
	@echo "Process $<"
	@mkdir -p $(OUT_MIRROR_DIR)
	@scripts/gen-mirror.py $< > $@.tmp
	@mv $@.tmp $@

clean:
	@rm -rf $(OUT_DIR)
	@echo "Cleaned."

clean-test-log:
	@rm -rf tests/log
	@echo "Cleaned."

# used for debug Makefile
dump:
	$(foreach v, \
		$(shell echo "$(filter-out .VARIABLES,$(.VARIABLES))" | tr ' ' '\n' | sort), \
		$(info $(shell printf "%-20s" "$(v)")= $(value $(v))) \
	)

# vim: set noexpandtab ts=4 sw=4 ft=make:
