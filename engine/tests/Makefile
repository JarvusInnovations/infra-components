TEST_SUITES   := $(wildcard suites/*)
LOCAL_ACTIONS := new-suite new-subject
SUITE_ACTIONS := $(filter-out $(LOCAL_ACTIONS),$(MAKECMDGOALS))
SUITE_STAGES  := setup cases teardown

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    run - execute all test suites                               '
	@echo '                                                                '
	@echo 'Actions:                                                        '
	@echo '                                                                '
	@echo '    new-suite   (SUITE=)                                        '
	@echo '    new-subject (SUITE=, STAGES=, SUBJECT=)                     '
	@echo

$(SUITE_ACTIONS) : $(TEST_SUITES)
$(TEST_SUITES)   :
	$(MAKE) -C $@ $(SUITE_ACTIONS)

STAGES            ?= $(SUITE_STAGES)
SUITE_DIR         := suites/$(SUITE)
SUITE_DIR_TARGET  := suite-dir-$(SUITE)
SUITE_MAKEFILE    := $(SUITE_DIR)/Makefile
SUBJECT_MAKEFILES := $(patsubst %,$(SUITE_DIR)/%/$(SUBJECT)/Makefile,$(STAGES))
SUBJECT_DIRS      := $(dir $(SUBJECT_MAKEFILES))
STAGE_MAKEFILES   := $(patsubst %,$(SUITE_DIR)/%/Makefile,$(SUITE_STAGES))
STAGE_DIRS        := $(dir $(STAGE_MAKEFILES))

new-suite:
ifdef SUITE

$(SUITE_DIR_TARGET):
	mkdir -p '$(SUITE_DIR)'

$(SUITE_MAKEFILE): $(STAGE_MAKEFILES) | $(SUITE_DIR_TARGET)
	echo 'include ../../content/mk/suite.mk' > '$@'

$(SUBJECT_DIRS): $(SUITE_MAKEFILE)
	mkdir -p '$@'

$(SUBJECT_MAKEFILES): $(SUITE_MAKEFILE) | $(SUBJECT_DIRS)
	echo 'include ../../../../../mk/subject.mk' > '$@'

$(STAGE_MAKEFILES): | $(STAGE_DIRS)
	echo 'include ../../../../mk/stage.mk' > '$@'

$(STAGE_DIRS):
	mkdir -p '$@'

new-suite: $(SUITE_MAKEFILE)
else
	$(error FATAL: SUITE= is required)
endif

new-subject:
ifdef SUITE
ifdef SUBJECT
new-subject: $(SUBJECT_MAKEFILES)
else
	$(error FATAL: SUBJECT= is required)
endif
else
	$(error FATAL: SUITE= is required)
endif

.PHONY: help
.PHONY: $(TEST_SUITES)
.PHONY: $(LOCAL_ACTIONS)
.PHONY: $(SUITE_ACTIONS)
.PHONY: $(SUITE_DIR_TARGET)
