include ../../../../content/mk/case.mk

assert-portable-usage:
	$(call assert_noopt,realpath)
	$(call assert_noopt,basename)
	$(call assert_noopt,dirname)

assert-no-deferred-context:
	# Enforce simple expansion of context variables (require assignment using :=).
	# The nuances of recursive expansion can cause bugs which are quite difficult
	# to diagnose when it occurs within an including Makefile.
	if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E '^[A-Z0-9_]+[[:space:]]*\??=' -- '*.mk'; then false; else true; fi

assert_noopt = if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E -- '$(1)[[:space:]]+-' $(2); then exit 1; else true; fi \# MUST NOT use options with $(1)

subject : assert-portable-usage
subject : assert-no-deferred-context
.PHONY  : assert-portable-usage
.PHONY  : assert-no-deferred-context
