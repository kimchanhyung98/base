PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
SPECKIT_VERSION ?=
SPECKIT_BIN := $(VENV)/bin/speckit
SPECKIT_SPEC := speckit

ifneq ($(strip $(SPECKIT_VERSION)),)
# Require a simple semver-like value (e.g., 1.2.3 or 1.2.3-rc.1)
ifneq ($(shell echo "$(SPECKIT_VERSION)" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+([A-Za-z0-9-]*)?$$' >/dev/null && echo valid),valid)
$(error SPECKIT_VERSION must look like 0.2.0 or 1.2.3-rc1)
endif
SPECKIT_SPEC := speckit==$(SPECKIT_VERSION)
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
