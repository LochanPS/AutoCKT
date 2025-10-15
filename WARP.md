# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project overview
- NL2EDA converts natural-language-like descriptions into EDA artifacts via a deterministic DSL → parsed AST → SKiDL netlist, with planned KiCad rendering and optional SPICE simulation. A minimal Streamlit UI is included for prototyping.

Common commands
- Environment (Windows PowerShell examples shown; adapt python invocation per OS):
  - Create venv (if needed):
    - python -m venv .venv
  - Upgrade pip (no activation required):
    - .\.venv\Scripts\python.exe -m pip install --upgrade pip
  - Editable install with dev tools:
    - .\.venv\Scripts\python.exe -m pip install -e .[dev]
- Tests (pytest configured in pyproject.toml):
  - Run all tests:
    - pytest
  - Run a single test:
    - pytest tests/test_parser.py::test_parse_simple_rc
- Formatting (Black, line length 100):
  - Auto-format:
    - black .
  - Check only (CI-style):
    - black --check .
- Launch prototype UI (Streamlit):
  - streamlit run ui/app_streamlit.py

Architecture and structure (big picture)
- DSL and parsing (dsl/)
  - grammar.lark defines a simple line-oriented grammar:
    - circuit: <name>
    - Free-form key:value parameters (e.g., vcc: 5V)
    - component: <ctype>: <space-separated key=value attrs>
  - parser.py loads the grammar (via importlib.resources), builds a Lark parser, and transforms the parse tree to a JSON-like AST with shape:
    - {
      circuit: <str>,
      params: [{key, value}, ...],
      components: [{ctype, attrs: {…}}, ...]
      }
- Netlist generation (nl2eda_skidl/)
- generator.py (in nl2eda_skidl) exposes ast_to_netlist(ast, out_path="circuit.net").
  - Currently resets SKiDL and emits an empty netlist stub via generate_netlist; it’s the extension point to map AST → Parts/Nets and connections.
- UI prototype (ui/)
  - app_streamlit.py wires parse(user_input) → st.json(ast) → ast_to_netlist(ast) and offers a download for circuit.net. This is the quickest manual loop for development.
- Planned integrations (placeholders)
  - KiCad (kicad/cli_integration.py): future CLI/API-based rendering of schematics from the netlist; currently NotImplemented.
  - SPICE (sim/pyspice_interface.py): future simulation-first validation; currently NotImplemented.
  - KiCad plugin skeleton (plugin/nl2eda_kicad_plugin/): placeholder package to host a KiCad Action plugin entry point.
- Tests (tests/)
  - pytest with testpaths=tests and addopts=-q configured in pyproject.toml.
  - Current coverage focuses on the DSL parser behavior (e.g., tests/test_parser.py).

Config highlights
- pyproject.toml
  - Python ≥ 3.10; build backend: setuptools.
  - Runtime deps: lark-parser, streamlit, skidl, PySpice.
  - [tool.black] line-length = 100.
  - [tool.pytest.ini_options] sets testpaths=["tests"], pythonpath=["."], and default -q.

Notes from README
- Quickstart (Windows): prefer invoking the venv interpreter directly (no activation) for pip and tooling.
- Prototype UI entry point: streamlit run ui/app_streamlit.py.
- KiCad v7+ recommended for Phase 2 (rendering) once implemented.

No project-scoped agent rule files (CLAUDE.md, .cursor/rules, Copilot instructions) were found at the time of writing.
