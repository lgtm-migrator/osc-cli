all: help

.PHONY: help
help:
	@echo "Available targets:"
	@echo "- build: python package building"
	@echo "- package: package osc-cli for various platforms"
	@echo "- test: run all tests"
	@echo "- test-pre-commit: run pre-commit tests"
	@echo "- test-pylint: check code with pylint"
	@echo "- test-bandit: security check with bandit"
	@echo "- test-mypy: run typing tests"
	@echo "- test-int: run integration tests"
	@echo "- test-pytest: run unit-tests"
	@echo "- pypi-upload: upload package to pypi (be careful)"
	@echo "- clean: clean temp files, venv, etc"

.PHONY: package
package:
	cd pkg && ./configure --wget-json-search && make

.PHONY: test
test: clean test-pre-commit test-pylint test-bandit test-mypy test-int test-pytest build
	@echo "All tests OK"

.PHONY: test-pre-commit
test-pre-commit:
	pre-commit run --all-files

.PHONY: test-pylint
test-pylint: .venv/ok
	@./tests/test_pylint.sh

.PHONY: test-bandit
test-bandit: .venv/ok
	@./tests/test_bandit.sh

.PHONY: test-mypy
test-mypy:
	./tests/test_mypy.sh

.PHONY: test-int
test-int: .venv/ok
	./tests/test_int.sh

.PHONY: test-pytest
test-pytest: .venv/ok
	./tests/test_pytest.sh

.PHONY: build
build: .venv/ok
	@./tests/build.sh

.PHONY: pypi-upload
pypi-upload: .venv/ok
	. .venv/bin/activate && twine upload dist/*

pkg/osc-cli-completion.bash:
	make -C pkg/ osc-cli-completion.bash

osc_sdk/osc-cli-completion.bash: pkg/osc-cli-completion.bash
	cp pkg/osc-cli-completion.bash osc_sdk/

.venv/ok:
	@./tests/setup_venv.sh

.PHONY: clean
clean:
	rm -rf .venv osc_sdk.egg-info dist
