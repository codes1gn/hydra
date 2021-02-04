init:
	pip install -r requirements.txt

install:
	mkdir -p build_tmp && python setup.py install --record build_tmp/dependencies.txt

uninstall:
	xargs rm -rf < build_tmp/dependencies.txt

test:
	py.test tests

.PHONY: init install uninstall
