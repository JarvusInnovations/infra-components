include ../../../../../mk/subject.mk

stage:
	$(if $(shell git -C '$(shell git rev-parse --show-toplevel)' grep relative -- mk/config.mk),$(error config.mk: relatve path resolution forbidden))
