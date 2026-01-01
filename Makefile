PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
SPECKIT_VERSION ?=
SPECKIT_BIN := $(VENV)/bin/speckit
SPECKIT_SPEC := speckit

ifneq ($(strip $(SPECKIT_VERSION)),)
ifneq ($(shell echo "$(SPECKIT_VERSION)" | grep -E '^[0-9A-Za-z_.+-]+$$' >/dev/null && echo valid),valid)
$(error SPECKIT_VERSION must match ^[0-9A-Za-z_.+-]+$$ (example: 0.2.0))
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
