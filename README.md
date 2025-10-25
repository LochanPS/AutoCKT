#  NL2EDA — Natural Language to Electronic Design Automation

##  Transparency Note

** This project is an experimental learning exercise exploring AI-assisted toolchain design for circuit automation.** NL2EDA (Natural Language to Electronic Design Automation) was created to understand how deterministic parsing, netlist generation, and EDA tool integration can work together to automate circuit design workflows.

### AI Assistance Disclosure

AI tools (Warp Terminal AI, Claude) were used to accelerate development in the following areas:

**What AI Helped With:**
- Initial repository structure and CI/CD pipeline setup
- Virtual environment configuration and dependency management
- Starter code for DSL grammar (Lark parser) and AST generation
- Streamlit UI prototype scaffolding
- Reference examples for SKiDL netlist generation and PySpice integration
- Documentation outlines and module naming conventions
- Code review suggestions for consistency and modularity

**All AI-generated outputs were manually reviewed, modified, tested, and integrated to ensure deterministic and explainable behavior.**

### My Direct Contributions

I personally designed and implemented:
- **End-to-end pipeline architecture**: Natural language → DSL → AST → SKiDL netlist → KiCad schematic → SPICE simulation
- **Grammar design**: Authored and refined the Lark grammar and AST schema to enforce explicit syntax and eliminate ambiguity
- **Parser-to-netlist logic**: Implemented and tested conversion in `nl2eda_skidl/generator.py`
- **UI prototype**: Created the Streamlit interface to visualize the NL→DSL→netlist transformation process
- **Tool integration research**: Investigated KiCad CLI automation and PySpice simulation bindings
- **Documentation**: All development workflows documented for reproducibility and transparency

### What I Learned

Through building this project, I gained practical understanding of:
- ✅ Grammar-based parsing using Lark and AST construction in Python
- ✅ Internal structure of SKiDL and mapping DSL entities to electronic components
- ✅ SPICE simulation basics and circuit validation using PySpice
- ✅ Workflow for integrating EDA tools (KiCad CLI) with custom Python automation
- ✅ The role of AI-assisted development in accelerating prototyping while maintaining human-directed logic design
- ✅ Challenges in creating deterministic, reproducible design tools

**Important**: This repository is a **learning artifact**, not a production-ready EDA system. It demonstrates how AI can augment the development of deterministic design tools while building a transparent record of the learning process.


## 🎯 Project Overview

NL2EDA bridges the gap between human-readable circuit descriptions and concrete Electronic Design Automation (EDA) artifacts. The goal is to convert friendly descriptions into actionable design files that can be opened in professional tools like KiCad.

### Pipeline Flow

```
Natural Language Input
    ↓
Deterministic DSL (Domain-Specific Language)
    ↓
Abstract Syntax Tree (AST/JSON)
    ↓
SKiDL Netlist Generation
    ↓
KiCad Schematic (.kicad_sch)
    ↓
Optional: PySpice Simulation
```

### Key Features

- **Deterministic DSL**: Explicit, unambiguous syntax that eliminates guesswork
- **Grammar-Based Parsing**: Uses Lark parser for robust AST generation
- **SKiDL Integration**: Converts AST to industry-standard netlists
- **KiCad Automation**: Generates schematics that open directly in KiCad
- **SPICE Simulation**: Optional circuit validation before hardware prototyping
- **Interactive UI**: Streamlit-based prototype for real-time visualization
- **Fallback Safety**: Always downloadable netlist and DSL for manual recovery


## 🛠️ Technologies Used

### Core Stack
- **Python 3.8+** - Primary development language
- **Lark** - Grammar-based parser for DSL
- **SKiDL** - Python-based netlist generation (schematic-as-code)

### EDA Integration
- **KiCad 7+** - Professional PCB design suite
- **PySpice** - Python wrapper for circuit simulation (ngspice)

### Development Tools
- **Streamlit** - Interactive web UI prototype
- **pytest** - Testing framework
- **CI/CD** - Automated testing pipeline


## 🗺️ Development Phases

### ✅ Phase 0: Foundation (Complete)
- Repository skeleton and structure
- Virtual environment setup
- CI/CD pipeline configuration

### ✅ Phase 1: MVP (Complete)
- DSL grammar definition (Lark)
- Parser → AST (JSON output)
- Streamlit UI prototype
- SKiDL netlist generation

### 🔄 Phase 2: KiCad Integration (Current)
- KiCad CLI automation hooks
- Schematic file generation (.kicad_sch)
- Symbol library mapping
- Platform-specific setup documentation

### 📋 Phase 3: Simulation (Planned)
- PySpice simulation interface
- Pre-fabrication circuit validation
- Component value verification
- Operating point analysis

### 🚀 Phase 4+: Polish & Distribution (Future)
- UI improvements and UX refinement
- Docker containerization
- KiCad plugin for in-editor access
- Optional ML model for NL→DSL translation
- Package distribution (PyPI)


## 🚀 Quick Start

### Prerequisites

```bash
# Python 3.8 or higher
python --version

# Git for cloning
git --version
```

### Installation (Windows PowerShell)

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/nl2eda.git
cd nl2eda

# 2. Create virtual environment
python -m venv .venv
# If python isn't found, try: py -3 -m venv .venv

# 3. Upgrade pip (avoid activation issues)
.\.venv\Scripts\python.exe -m pip install --upgrade pip

# 4. Install development dependencies
pip install -e .[dev]

# 5. Verify installation
pytest -q
```

### Installation (Linux/macOS)

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/nl2eda.git
cd nl2eda

# 2. Create virtual environment
python3 -m venv .venv

# 3. Activate environment
source .venv/bin/activate

# 4. Upgrade pip
pip install --upgrade pip

# 5. Install development dependencies
pip install -e .[dev]

# 6. Verify installation
pytest -q
```

### Launch the UI

```bash
# Start the Streamlit interface
streamlit run ui/app_streamlit.py
```

The UI will open in your browser at `http://localhost:8501`


## 📊 DSL Syntax Reference

### Passive Components

Resistors, capacitors, and inductors with two-terminal connections:

```dsl
# Resistor
resistor: name=R1 value=10k node1=VCC node2=OUT

# Capacitor
capacitor: name=C1 value=1uF node1=OUT node2=GND
capacitor: name=C2 value=100nF pos=VDD neg=GND  # Alternative syntax

# Inductor
inductor: name=L1 value=10mH a=IN b=OUT
```

**Supported node aliases**: `node1/node2`, `a/b`, `pos/neg`, `p/n`

### Voltage Sources

SPICE-compatible voltage sources for simulation:

```dsl
# DC voltage source
voltage_source: name=V1 value=5V pos=VCC neg=GND
vsource: name=VBAT value=3.3V node1=VBAT node2=GND  # Alias

# Battery (same as DC source)
battery: name=BAT1 value=9V pos=VCC neg=GND

# Sinusoidal source
vsin: name=VAC value=1V pos=INPUT neg=GND

# Pulse source
vpulse: name=VPULSE value=5V pos=CLK neg=GND
```

**Types**: `voltage_source`, `vsource`, `vdc` → V | `vsin` → VSIN | `vpulse` → VPULSE | `battery` → V

**Note**: If symbol not available in library, nets are still created and netlist generation continues.

### Power and Ground Nets

Special net declarations for power distribution:

```dsl
# Power rail
power: name=VCC

# Ground (canonicalizes to GND)
gnd: name=GND
ground: name=GND  # Alias

# Common power nets auto-created from parameters
# Using vcc=VCC in any component creates VCC net
# Common names: vcc, vdd, vss, vin, vref, +5V, +12V
```

### Operational Amplifiers

Op-amp with configurable model and pin mapping:

```dsl
# Basic op-amp
opamp: name=U1 in+=INP in-=INM out=OUT v+=VCC v-=GND

# With specific model
opamp: name=U2 in_plus=IN1 in_minus=IN2 out=VOUT vplus=+12V vminus=-12V model=TL081

# Supported models: OP07, TL081, AD797, LM358, UA741
# Default: UA741
```

**Pin mapping** (single op-amp heuristic):
- IN- = Pin 2
- IN+ = Pin 3  
- OUT = Pin 6
- V+ = Pin 7
- V- = Pin 4

**Supported parameter aliases**:
- Inputs: `in+`/`in_plus`, `in-`/`in_minus`
- Output: `out`
- Power: `vplus`/`v+`, `vminus`/`v-`

### Explicit Net Declarations

Declare nets explicitly for clarity and validation:

```dsl
# Create named net
net: OUT
net: SIGNAL_A
net: VREF
```

**Use cases**: Pre-declare nets before components, improve readability, enable future validation checks


## 💬 Natural Language Helper (Experimental)

The UI includes a deterministic NL→DSL translator for common patterns:

### Supported Patterns

```text
1. Resistor connection:
   "connect R1 10k between VCC and OUT"
   → resistor: name=R1 value=10k node1=VCC node2=OUT

2. Voltage source:
   "voltage source V1 5V from VCC to GND"
   → voltage_source: name=V1 value=5V pos=VCC neg=GND

3. Op-amp wiring:
   "opamp U1 in+ INP in- INM out OUT v+ VCC v- GND"
   → opamp: name=U1 in+=INP in-=INM out=OUT v+=VCC v-=GND

4. Net creation:
   "make net OUT"
   → net: OUT
```

### How to Use

1. Enter natural language in the UI
2. Click **"Translate NL→DSL"** to preview
3. Review and edit the generated DSL
4. Click **"Parse & Generate"** to create netlist


## 🏗️ Repository Structure

```
nl2eda/
├── dsl/
│   ├── grammar.lark              # Lark grammar definition
│   └── parser.py                 # Parser → AST/JSON converter
│
├── nl2eda_skidl/
│   └── generator.py              # AST → SKiDL netlist conversion
│
├── ui/
│   └── app_streamlit.py          # Interactive web UI prototype
│
├── kicad/
│   └── cli_integration.py        # KiCad CLI/API hooks (Phase 2)
│
├── sim/
│   └── pyspice_interface.py      # SPICE simulation glue (Phase 3)
│
├── plugin/
│   └── nl2eda_kicad_plugin/      # KiCad plugin skeleton (Phase 5)
│
├── model/
│   └── trainingScripts/          # ML training data (Phase 6)
│
├── tests/
│   └── test_*.py                 # pytest test suite
│
├── .github/
│   └── workflows/                # CI/CD pipeline
│
├── pyproject.toml                # Project dependencies
└── README.md                     # This file
```


## 🔧 Configuration

### Strict Symbol Mode

By default, NL2EDA continues netlist generation even if a component symbol isn't found in KiCad libraries (nets are preserved).

To error out on missing symbols:

```bash
# Windows PowerShell
$env:NL2EDA_STRICT_SYMBOLS = "1"

# Linux/macOS
export NL2EDA_STRICT_SYMBOLS=1

# Then run your command
streamlit run ui/app_streamlit.py
```

**Use cases**: Production workflows, ensure all symbols exist before fabrication

### KiCad Installation (Phase 2)

```bash
# 1. Install KiCad 7+ from https://www.kicad.org/download/

# 2. Verify kicad-cli is available
kicad-cli --version

# 3. Ensure KiCad Python scripting is enabled
# Windows: Check KiCad installation includes Python support
# Linux: Install python3-pcbnew package
# macOS: Python support included by default

# Platform-specific setup will be documented in docs/ folder
```


## 🧪 Development Workflow

### Running Tests

```bash
# Run all tests
pytest

# Run with minimal output
pytest -q

# Run specific test file
pytest tests/test_parser.py

# Run with coverage
pytest --cov=nl2eda_skidl --cov-report=html
```

### Adding New Components

1. **Update grammar** in `dsl/grammar.lark`
2. **Add parser logic** in `dsl/parser.py`
3. **Implement generator** in `nl2eda_skidl/generator.py`
4. **Write tests** in `tests/test_newcomponent.py`
5. **Update documentation** in README and examples

### Code Style

```bash
# Format code
black .

# Check linting
flake8

# Type checking
mypy nl2eda_skidl/
```


## 📖 Example Usage

### Complete Circuit Example

```dsl
# Voltage divider with buffer

# Power supply
voltage_source: name=V1 value=5V pos=VCC neg=GND
ground: name=GND

# Voltage divider
resistor: name=R1 value=10k node1=VCC node2=VDIV
resistor: name=R2 value=10k node1=VDIV node2=GND

# Decoupling capacitor
capacitor: name=C1 value=100nF pos=VCC neg=GND

# Buffer amplifier
opamp: name=U1 in+=VDIV in-=OUT out=OUT v+=VCC v-=GND model=TL081

# Output load
resistor: name=RLOAD value=1k node1=OUT node2=GND
```

### Programmatic Usage

```python
from dsl.parser import parse_dsl
from nl2eda_skidl.generator import generate_netlist

# Parse DSL to AST
dsl_text = """
resistor: name=R1 value=10k node1=VCC node2=GND
capacitor: name=C1 value=1uF node1=VCC node2=GND
"""

ast = parse_dsl(dsl_text)

# Generate SKiDL netlist
netlist = generate_netlist(ast)

# Save to file
with open('circuit.net', 'w') as f:
    f.write(netlist)

print("Netlist generated successfully!")
```


## 🎓 Design Principles

### 1. Deterministic Over Clever

**Why**: EDA tools require predictable, repeatable behavior for safety-critical designs.

- DSL syntax is explicit—no hidden defaults or ambiguous interpretations
- Any ambiguity surfaces to the user as an error, not a silent assumption
- Same input always produces same output (no random behavior)

### 2. Fallback to Manual Recovery

**Why**: Automation should augment, not replace, human expertise.

- Always provide downloadable netlist and DSL files
- Allow manual editing at every stage
- Enable export to standard formats (SPICE, KiCad, etc.)

### 3. Strict Optional, Permissive Default

**Why**: Learning and prototyping require flexibility; production requires rigor.

- Default mode continues on missing symbols (nets preserved)
- Strict mode (`NL2EDA_STRICT_SYMBOLS=1`) errors on any issue
- Users choose appropriate level based on project phase

### 4. Tool Integration, Not Replacement

**Why**: Professional EDA tools are mature and battle-tested.

- Generate files that open in KiCad, not a custom viewer
- Output standard SPICE netlists compatible with any simulator
- Plugin architecture allows use within existing workflows


## 🐛 Known Issues & Limitations

### Current Limitations

- **Single-sheet schematics only**: No hierarchical design support yet
- **Limited component library**: Focus on basic passives, sources, and op-amps
- **Windows path issues**: KiCad + Python path setup can be tricky (workarounds documented)
- **No layout automation**: Generates schematic only, not PCB layout
- **Simulation basics**: PySpice interface is minimal (DC/AC analysis only)

### Future Improvements Needed

- [ ] Multi-sheet hierarchical schematic support
- [ ] Broader component library (microcontrollers, connectors, ICs)
- [ ] Symbol library management and auto-download
- [ ] PCB layout generation (via KiCad Python API)
- [ ] Advanced SPICE simulation (transient, Monte Carlo)
- [ ] Bill of Materials (BOM) generation
- [ ] Design rule checking (DRC) integration


## 🔮 Roadmap

### Phase 2: KiCad Integration (Q2 2024)
- [ ] Automated schematic file generation
- [ ] Symbol library mapping and validation
- [ ] Multi-platform testing (Windows, Linux, macOS)
- [ ] Documentation for KiCad Python API usage

### Phase 3: Simulation (Q3 2024)
- [ ] PySpice integration for DC/AC/Transient analysis
- [ ] Component model library
- [ ] Simulation result visualization in UI
- [ ] Pre-fab validation workflows

### Phase 4: UI & Distribution (Q4 2024)
- [ ] Improved Streamlit UI with real-time preview
- [ ] Docker image for easy deployment
- [ ] KiCad plugin for in-editor use
- [ ] PyPI package release

### Phase 5+: Advanced Features (2025)
- [ ] ML model for NL→DSL translation (if deterministic patterns insufficient)
- [ ] Component recommendation system
- [ ] Automated schematic layout optimization
- [ ] Cloud-based collaboration features


## 🤝 Contributing

This is a learning project, and contributions are welcome! Areas where help is needed:

1. **Component library expansion**: Add more parts (transistors, diodes, etc.)
2. **Grammar improvements**: Better DSL syntax suggestions
3. **Testing**: Validate on different platforms and KiCad versions
4. **Documentation**: Improve examples and tutorials
5. **Bug reports**: Find edge cases and broken workflows

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-component`)
3. Write tests for new functionality
4. Ensure all tests pass (`pytest`)
5. Submit a pull request with clear description

**Note**: Since this is a learning project, I'm especially interested in feedback on code organization, best practices, and educational value!


## 📚 Learning Resources

If you're interested in EDA automation and want to learn more:

### Circuit Design & Simulation
- *The Art of Electronics* by Horowitz & Hill
- KiCad documentation: https://docs.kicad.org/
- ngspice manual: http://ngspice.sourceforge.net/docs.html

### Python for EDA
- SKiDL documentation: https://devbisme.github.io/skidl/
- PySpice examples: https://pyspice.fabrice-salvaire.fr/

### Grammar & Parsing
- Lark parser documentation: https://lark-parser.readthedocs.io/
- *Crafting Interpreters* by Robert Nystrom



---

*Built with 🔌 as a learning journey into EDA automation and AI-assisted development.*


