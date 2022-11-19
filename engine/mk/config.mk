GIT     ?= git

ifeq ($(GIT_DIR),)
GIT_DIR := $(shell $(GIT) rev-parse --absolute-git-dir)
endif

LIFECYCLE_CONFS := $(wildcard $(LIFECYCLE_DIR)/*.conf)
SUBJECT_CONFS   := $(wildcard *.conf)
ENV_CONFS       := $(wildcard $(ENGINE_ENV_DIR)/*.conf)

ifneq ($(LIFECYCLE_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(LIFECYCLE_CONFS))
endif

ifneq ($(SUBJECT_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(SUBJECT_CONFS))
endif

ifneq ($(ENV_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(ENV_CONFS))
endif

GIT_CONFIG := $(GIT) config -f /dev/null

# call signature : $(call config,{subject|env},<varname>,<git-config-opts>,<git-config-value-pattern>)
# expands to     : git config <git-config-opts> {subject|env}.<{lifecycle-name/subject-name|env-name}>.<varname> <git-config-value-pattern>
config = $(shell $(GIT) config $(3) $(1).$(or $(if $(findstring subject,$(1)),$(LIFECYCLE_NAME)/$(SUBJECT_NAME)),$(if $(findstring env,$(1)),$(ENGINE_ENV))).$(2) $(4))
