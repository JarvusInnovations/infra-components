include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(DO_SUBJECTS),)
DO_SUBJECTS  := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

DEFAULT_TARGET  := stage
EXTRA_TARGETS   := $(filter-out stage,$(MAKECMDGOALS))
SUBJECT_TARGETS := $(patsubst %,subject-%,$(DO_SUBJECTS))

subject_exists = $(shell find . -mindepth 1 -maxdepth 1 -type d -name $(1) 2>/dev/null)

# this ensures that if no other targets are passed, "stage" will run
$(DEFAULT_TARGET) $(EXTRA_TARGETS): $(SUBJECT_TARGETS)

subject-%:
	$(if $(call subject_exists,$*),$(MAKE) -C '$*' $(MAKECMDGOALS))

.PHONY: $(MAKECMDGOALS)
