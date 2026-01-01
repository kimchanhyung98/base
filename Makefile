PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
SPECKIT_VERSION ?=
SPECKIT_BIN := $(VENV)/bin/speckit
SPECKIT_SPEC := speckit
# Semver-like: major.minor.patch with optional dot-separated pre-release identifiers (numeric identifiers are allowed).
SPECKIT_SEMVER_REGEX := ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9]+(\.[A-Za-z0-9]+)*)?$$
SPECKIT_VERSION_CLEAN := $(strip $(SPECKIT_VERSION))
SPECKIT_VERSION_VALID := $(if $(SPECKIT_VERSION_CLEAN),$(shell echo "$(SPECKIT_VERSION_CLEAN)" | grep -E '$(SPECKIT_SEMVER_REGEX)' >/dev/null && echo valid),valid)

ifneq ($(SPECKIT_VERSION_CLEAN),)
# Require a semver-like value; optional suffix is dot-separated alphanumeric identifiers.
ifneq ($(findstring ..,$(SPECKIT_VERSION_CLEAN)),)
$(error SPECKIT_VERSION cannot contain consecutive dots)
endif
ifneq ($(SPECKIT_VERSION_VALID),valid)
$(error SPECKIT_VERSION must be semver-like (e.g., 0.2.0 or 1.2.3-rc.1; suffix is dot-separated alphanumeric identifiers))
endif
SPECKIT_SPEC := speckit==$(SPECKIT_VERSION_CLEAN)
endif

.PHONY: speckit-install speckit-init speckit-check speckit-clean

$(VENV)/bin/python:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip setuptools wheel

$(SPECKIT_BIN): $(VENV)/bin/python
	$(PIP) install $(SPECKIT_SPEC)

speckit-install: $(SPECKIT_BIN)

speckit-init: $(SPECKIT_BIN)
	$(SPECKIT_BIN) init

speckit-check: $(SPECKIT_BIN)
	$(SPECKIT_BIN) check

speckit-clean:
	rm -rf $(VENV)
