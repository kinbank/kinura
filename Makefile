# define version:
GLOTTOLOG=v4.4
CONCEPTICON=v2.5.0

.PHONY: help clean update test

help:
	@echo "1. Run 'make install' to install the python requirements"
	@echo "2. Run 'make update' to update to latest versions of Glottolog, Concepticon, and CLDF libraries."
	@echo "3. Run 'make backfill' to fill in subordinate kinterms"
	@echo "4. Run 'make cldf' to generate a CLDF dataset"

# install python venv and install python libraries
env:
	python3 -m venv env
	./env/bin/python3 ./env/bin/pip3 install -r requirements.txt
	./env/bin/cldfbench catconfig

update: env
	./env/bin/python3 ./env/bin/pip3 install --upgrade -r requirements.txt
	./env/bin/cldfbench catupdate

# Install kinbank into venv
install: env
	cd kinbank && ../env/bin/python3 setup.py develop && cd ..

backfill: env
	Rscript ./kinbank/fill_subordinates.R

# generate CLDF
cldf: env ./kinbank/raw/
	./env/bin/python3 ./env/bin/cldfbench lexibank.makecldf --glottolog-version $(GLOTTOLOG) --concepticon-version $(CONCEPTICON) kinbank

test: env
	cd kinbank && pytest
