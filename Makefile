PYTHON ?= python3
VENV ?= .venv
PIP := $(VENV)/bin/pip
SPECKIT_VERSION ?=
SPECKIT_BIN := $(VENV)/bin/speckit

.PHONY: speckit-install speckit-init speckit-check speckit-clean

$(VENV)/bin/python:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip setuptools wheel

$(SPECKIT_BIN): $(VENV)/bin/python
	$(PIP) install speckit$(if $(SPECKIT_VERSION),==$(SPECKIT_VERSION),)

speckit-install: $(SPECKIT_BIN)

speckit-init: $(SPECKIT_BIN)
	$(SPECKIT_BIN) init

speckit-check: $(SPECKIT_BIN)
	$(SPECKIT_BIN) check

speckit-clean:
	rm -rf $(VENV)
