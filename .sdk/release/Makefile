C ?=

release:
	$(if $(C),,$(error C= is required))
	rev=`git -C ../.. subtree split -P $(C)` && git update-ref refs/heads/channels/$(C)/dev $$rev

help:
	@echo
	@echo 'Actions:                                                                  '
	@echo '                                                                          '
	@echo '    release - publish a component locally to a channels/{part}/dev branch '
	@echo '                                                                          '
	@echo 'Inputs:                                                                   '
	@echo '                                                                          '
	@echo '    C = component to publish (path relative to project root)              '
	@echo
