
ifeq ($(GIT_WORKDIR),)
GIT_WORKDIR := $(call opt_pipeline_var,gitWorkDir)
endif

ifeq ($(GIT),)
GIT := git $(if $(GIT_WORKDIR),-C '$(GIT_WORKDIR)')
endif
