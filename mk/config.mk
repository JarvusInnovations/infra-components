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

# call signature : $(call subject_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> subject.<lifecycle-name/subject-name>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
subject_config  = $(shell $(GIT) config $(2) subject.$(LIFECYCLE_NAME)/$(SUBJECT_NAME).$(1))

# call signature : $(call env_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> env.<engine-env>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
env_config      = $(shell $(GIT) config $(2) env.$(ENGINE_ENV).$(1))

# call signature : $(call env_config_path,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> env.<engine-env>.<varname> [git-config-value-pattern]
# returns        : <engine-env-dir>/<varname-value>
env_config_path = $(patsubst %,$(shell realpath --relative-to=. '$(ENGINE_ENV_DIR)')/%,$(shell $(GIT) config $(2) env.$(ENGINE_ENV).$(1)))
