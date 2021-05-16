.PHONY: create-env

REPO=$(shell basename $(CURDIR))

create-env:
	python3 -m venv .$(REPO);
		. .$(REPO)/bin/activate;
		python -m ipykernel install --user --name=$(REPO);