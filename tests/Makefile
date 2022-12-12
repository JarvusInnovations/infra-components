TEST_SUITES := $(wildcard suites/*)

help:
	@echo
	@echo 'Orchestrations:                                                 '
	@echo '                                                                '
	@echo '    run - execute all test suites                               '
	@echo

$(MAKECMDGOALS) : $(TEST_SUITES)
$(TEST_SUITES)  :
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: help
.PHONY: $(TEST_SUITES)
.PHONY: $(MAKECMDGOALS)
