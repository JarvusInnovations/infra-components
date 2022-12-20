TEST_SUITES   := $(wildcard suites/*)
LOCAL_ACTIONS := new-suite new-subject
SUITE_ACTIONS := $(filter-out $(LOCAL_ACTIONS),$(MAKECMDGOALS))
SUITE_STAGES  := setup cases teardown

help:
	@echo
	@echo 'Actions:                                                              '
	@echo '                                                                      '
	@echo '    run                                     - execute all test suites '
	@echo '    new-suite   (SUITE=)                    - create new test suite   '
	@echo '    new-subject (SUITE=, STAGES=, SUBJECT=) - create new test case    '
	@echo

$(SUITE_ACTIONS) : $(TEST_SUITES)
$(TEST_SUITES)   :
	$(MAKE) -C $@ $(SUITE_ACTIONS)

STAGES            ?= $(SUITE_STAGES)
SUITE_DIR         := $(if $(SUITE),suites/$(SUITE))
SUITE_DIR_TARGET  := $(if $(SUITE),suite-dir-$(SUITE))
SUITE_MAKEFILE    := $(if $(SUITE),$(SUITE_DIR)/Makefile)
STAGE_MAKEFILES   := $(if $(SUITE),$(patsubst %,$(SUITE_DIR)/%/Makefile,$(SUITE_STAGES)))
STAGE_DIRS        := $(if $(SUITE),$(dir $(STAGE_MAKEFILES)))
SUBJECT_MAKEFILES := $(if $(SUBJECT),$(patsubst %,$(SUITE_DIR)/%/$(SUBJECT)/Makefile,$(STAGES)))
SUBJECT_DIRS      := $(if $(SUBJECT),$(dir $(SUBJECT_MAKEFILES)))
ALL_DIRS          := $(SUBJECT_DIRS) $(STAGE_DIRS)

new-suite: $(STAGE_MAKEFILES)
ifndef SUITE
	$(error FATAL: SUITE= is required)
endif

new-subject: $(SUBJECT_MAKEFILES)
ifndef SUITE
	$(error FATAL: SUITE= is required)
endif
ifndef SUBJECT
	$(error FATAL: SUBJECT= is required)
endif

$(SUITE_MAKEFILE)    :                    | $(SUITE_DIR_TARGET)
$(STAGE_MAKEFILES)   : $(SUITE_MAKEFILE)  | $(STAGE_DIRS)
$(SUBJECT_MAKEFILES) : $(STAGE_MAKEFILES) | $(SUBJECT_DIRS)

$(SUITE_MAKEFILE):
	echo 'include ../../content/mk/suite.mk' > '$@'

$(STAGE_MAKEFILES):
	echo 'include ../../../../mk/stage.mk' > '$@'

$(SUBJECT_MAKEFILES):
	echo 'include ../../../../../mk/subject.mk' > '$@'

$(SUITE_DIR_TARGET):
ifeq ($(wildcard $(SUITE_DIR)),)
	mkdir -pv '$(SUITE_DIR)'
endif

$(ALL_DIRS):
	mkdir -pv '$@'

.PHONY: help
.PHONY: $(TEST_SUITES)
.PHONY: $(LOCAL_ACTIONS)
.PHONY: $(SUITE_ACTIONS)
.PHONY: $(SUITE_DIR_TARGET)
