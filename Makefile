init:
	pip install -r requirements.txt

install:
	python setup.py install

uninstall:
	pip uninstall hydra

test:
	py.test tests

.PHONY: init install uninstall
