init:
	pip install -r requirements.txt

install:
	python setup.py install

test:
	py.test tests

.PHONY: init install
