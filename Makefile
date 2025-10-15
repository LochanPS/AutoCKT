SHELL := /bin/bash

.PHONY: run test lint build-image run-image install dev-install clean help

install:
	pip install -e .

dev-install:
	pip install -e .[dev]

run:
	python -m streamlit run ui/app_streamlit.py --server.headless true --server.port 8501

run-local:
	python -m streamlit run ui/app_streamlit.py

test:
	python -m pytest tests/ -v

test-quick:
	python -m pytest tests/ -q

lint:
	python -m black --check .

format:
	python -m black .

build-image:
	docker build -t nl2eda:latest .

run-image:
	docker run --rm -p 8501:8501 nl2eda:latest

clean:
	find . -type d -name '__pycache__' -exec rm -rf {} +
	find . -type f -name '*.pyc' -delete
	rm -rf .pytest_cache/
	rm -rf build/ dist/ *.egg-info/

help:
	@echo "Available commands:"
	@echo "  install     - Install package"
	@echo "  dev-install - Install package with dev dependencies"
	@echo "  run         - Run Streamlit app (headless)"
	@echo "  run-local   - Run Streamlit app (with browser)"
	@echo "  test        - Run all tests (verbose)"
	@echo "  test-quick  - Run all tests (quiet)"
	@echo "  lint        - Check code formatting"
	@echo "  format      - Format code with black"
	@echo "  build-image - Build Docker image"
	@echo "  run-image   - Run Docker container"
	@echo "  clean       - Clean up build artifacts"
	@echo "  help        - Show this help"
