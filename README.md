**NL2EDA** — Natural Language to EDA/KiCad


**Transparency Note**

This project — NL2EDA (Natural Language to Electronic Design Automation) — was created as a learning project to explore AI-assisted code generation and toolchain design in the context of circuit automation. The work combines deterministic DSL parsing, SKiDL-based netlist generation, and KiCad/SPICE integration.

**AI Assistance**:
AI tools such as Warp and Claude were used to:
Draft the initial repository structure, CI setup, and virtual environment configuration.
Generate starter code for the DSL grammar (Lark), parser module, and Streamlit prototype.
Produce reference examples for AST serialization, SKiDL netlist generation, and PySpice integration hooks.
Suggest documentation outlines, module naming conventions, and testing workflows.
Provide code reviews and refactoring suggestions for consistency and modularity.
All AI outputs were manually reviewed, modified, and integrated by me to ensure deterministic and explainable behavior.

**My Direct Contributions**:
Designed the end-to-end pipeline from natural language input → deterministic DSL → AST → SKiDL netlist → KiCad schematic → PySpice simulation.
Authored and refined the Lark grammar and AST schema to enforce explicit syntax and eliminate ambiguity.
Implemented and tested parser-to-netlist conversion logic in nl2eda_skidl/generator.py.
Created the Streamlit UI prototype to visualize the NL→DSL→netlist process.
Researched KiCad CLI automation and PySpice simulation bindings for future integration phases.
Documented all development and testing workflows in alignment with reproducible learning practices.

**What I Learned**:
Practical understanding of grammar-based parsing using Lark and AST construction in Python.
Internal structure of SKiDL and how to map DSL entities to electronic components and nets.
Basics of SPICE simulation setup and circuit validation using PySpice.
Workflow for integrating EDA tools (KiCad CLI) with custom Python-based automation.
The role of AI-assisted development in accelerating prototyping while maintaining human-directed logic design.

**Purpose**:
This repository is a learning artifact, not a production-ready EDA system.
It demonstrates how AI can augment the development of deterministic design tools, helping me learn EDA concepts, circuit representation, and toolchain integration while building a transparent record of my process.

**NL2EDA aims to convert human-friendly descriptions into concrete EDA artifacts: a deterministic DSL → SKiDL netlist → KiCad schematic, with optional SPICE simulation for early validation.**

Phases overview
- Phase 0 (this commit): Repo skeleton, virtualenv, CI
- Phase 1 (MVP): DSL grammar (Lark), parser → AST (JSON), Streamlit prototype, SKiDL netlist generation
- Phase 2: KiCad integration and schematic rendering
- Phase 3: PySpice simulation-first validation
- Phase 4+: UI polish, packaging, Docker, KiCad plugin, optional ML for NL→DSL

**We are at Phase 2 right now.**

Quickstart (Windows PowerShell)
1) Create venv and upgrade pip (already scaffolded by CI; local optional):
   - Prefer using the venv interpreter directly to avoid activation:
     .\.venv\Scripts\python.exe -m pip install --upgrade pip
   - If venv not yet created, see below in Dev environment.

2) Install dev tools (minimal):
   - pip install -e .[dev]

3) Run tests:
   - pytest -q

4) Launch the prototype UI:
   - streamlit run ui/app_streamlit.py

Dev environment
- Create the virtualenv:
  - python -m venv .venv
  - If python isn’t found, try: py -3 -m venv .venv
- Upgrade pip:
  - .\.venv\Scripts\python.exe -m pip install --upgrade pip

KiCad installation (Phase 2)
- Install KiCad (v7+ recommended). Ensure KiCad Python scripting and CLI (kicad-cli) are available. Platform-specific steps will be documented in docs/ later.

Repository layout
- dsl/grammar.lark — Lark grammar for the DSL
- dsl/parser.py — Parser that emits a stable JSON/AST
- nl2eda_skidl/generator.py — Convert AST → SKiDL netlist (circuit.net)
- ui/app_streamlit.py — Simple UI to input DSL and generate outputs
- kicad/cli_integration.py — Hooks to KiCad CLI/API (Phase 2)
- sim/pyspice_interface.py — SPICE simulation glue (Phase 3)
- plugin/nl2eda_kicad_plugin — KiCad plugin skeleton (Phase 5)
- model/trainingScripts — ML data & training scripts (Phase 6)

Notes
- Keep the DSL deterministic and explicit; any ambiguity should surface to the user.
- Fallbacks: always allow downloading the netlist and DSL for manual recovery.
- Windows users: KiCad + Python path setups can be tricky; we’ll document known-good setups.

DSL components and attributes (MVP)
- Passives (resistor/capacitor/inductor)
  - Keys: name, value, node1, node2 (aliases: a/b, pos/neg, p/n)
  - Examples:
    - resistor: name=R1 value=10k node1=VCC node2=OUT
    - capacitor: name=C1 value=1uF node1=OUT node2=GND

- Voltage sources (Simulation_SPICE)
  - Types: voltage_source/vsource/vdc → V, vsin → VSIN, vpulse → VPULSE, battery → V
  - Keys: name, value, pos, neg (node1/node2 also accepted)
  - Behavior: if symbol not available, nets still created; netlist generation continues.

- Power and ground (net-only)
  - power: name=VCC creates a named power net; gnd/ground canonicalizes to GND.
  - Common param keys also pre-create nets: vcc, vdd, vss, vin, vref, +5V, +12V.

- Op-amp (Amplifier_Operational)
  - Keys: in+/in_plus, in-/in_minus, out, vplus/v+, vminus/v-; optional model=OP07|TL081|AD797|LM358|UA741.
  - Default device: UA741 (deterministic single-op-amp pin map). Override with model=... if desired.
  - Pin mapping heuristic (single op-amp): IN-=2, IN+=3, OUT=6, V+=7, V-=4 (verify per symbol).

- Explicit nets
  - net: NAME declares a named net explicitly (useful for readability and future validation)

NL→DSL helper (deterministic)
- Limited patterns to assist authoring:
  - "connect R1 10k between VCC and OUT" → resistor: name=R1 value=10k node1=VCC node2=OUT
  - "voltage source V1 5V from VCC to GND" → voltage_source: name=V1 value=5V pos=VCC neg=GND
  - "opamp U1 in+ INP in- INM out OUT v+ VCC v- GND" → opamp: name=U1 ...
  - "make net OUT" → net: OUT
- In the prototype UI, click "Translate NL→DSL" to preview the translation; then "Parse & Generate".

Strict symbol mode (optional)
- Set NL2EDA_STRICT_SYMBOLS=1 to error if a requested library/device cannot be instantiated.
- Default is non-strict: missing symbols are skipped but nets are kept so the rest of the circuit netlists.

