include ../../../../content/mk/case.mk

assert-portable-usage:
	$(call assert_noopt,realpath)
	$(call assert_noopt,basename)
	$(call assert_noopt,dirname)
	$(call run_step,assert-no-shell-local-vars)

assert-no-deferred-context:
	# Enforce simple expansion of context variables (require assignment using :=).
	# The nuances of recursive expansion can cause bugs which are quite difficult
	# to diagnose when it occurs within an including Makefile.
	if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E '^[A-Z0-9_]+[[:space:]]*\??=' -- '*.mk'; then false; else true; fi

assert-no-shell-local-vars:
	# The use of the "local" directive in shell scripts is supported by dash (the
	# shell used to test scripts) but is not POSIX compliant. This linter enforces
	# the absence of such declarations.
	if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E '[[:space:]]*local[[:space:]]+[[:alnum:]_]+=' -- '*.sh'; then false; else true; fi

assert_noopt = if git -C '$(ENGINE_SYSTEM_DIR)' grep -n -E -- '$(1)[[:space:]]+-' $(2); then exit 1; else true; fi \# MUST NOT use options with $(1)

subject : assert-portable-usage
subject : assert-no-deferred-context
.PHONY  : assert-portable-usage
.PHONY  : assert-no-deferred-context
