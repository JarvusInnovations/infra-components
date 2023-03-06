include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(DO_SUBJECTS),)
DO_SUBJECTS  := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

SUBJECT_TARGET_NAMES := $(foreach name,$(DO_SUBJECTS),subject-$(name))
SUBJECT_TARGET_GOALS := $(filter-out stage,$(MAKECMDGOALS))

subject_exists = $(shell find . -mindepth 1 -maxdepth 1 -type d -name $(1) 2>/dev/null)

ifeq ($(SUBJECT_TARGET_GOALS),)
SUBJECT_TARGET_GOALS := subject
endif

stage                   : $(SUBJECT_TARGET_NAMES)
$(SUBJECT_TARGET_GOALS) : $(SUBJECT_TARGET_NAMES)

subject-%:
	$(if $(call subject_exists,$*),$(MAKE) -C '$*' $(SUBJECT_TARGET_GOALS))

.PHONY: $(MAKECMDGOALS)
