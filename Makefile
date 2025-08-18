# Makefile for Voting Machine Verilog Project

# Simulator selection
SIM ?= modelsim
# SIM ?= vivado
# SIM ?= icarus

# File paths
SRC_DIR = src
SIM_DIR = simulation
TOP_MODULE = voting_machine
TB_MODULE = testbench

# Source files
SRCS = $(SRC_DIR)/$(TOP_MODULE).sv $(SRC_DIR)/$(TB_MODULE).sv

# Default target
all: compile simulate

# ModelSim targets
ifeq ($(SIM), modelsim)
compile:
	@echo "Compiling with ModelSim..."
	@mkdir -p work
	vlog -work work $(SRCS)

simulate: compile
	@echo "Running simulation with ModelSim..."
	@mkdir -p $(SIM_DIR)
	vsim -c work.$(TB_MODULE) -do "run -all; quit" > $(SIM_DIR)/simulation_results.txt
	@echo "Simulation complete. Results in $(SIM_DIR)/simulation_results.txt"

gui: compile
	@echo "Running simulation with ModelSim GUI..."
	@mkdir -p $(SIM_DIR)
	vsim -gui work.$(TB_MODULE)

waveform:
	@echo "Opening waveform viewer..."
	vsim -view $(SIM_DIR)/dump.vcd

clean_modelsim:
	@echo "Cleaning ModelSim files..."
	rm -rf work transcript *.wlf *.vstf
endif

# Icarus Verilog targets  
ifeq ($(SIM), icarus)
compile:
	@echo "Compiling with Icarus Verilog..."
	@mkdir -p $(SIM_DIR)
	iverilog -g2012 -o $(SIM_DIR)/$(TB_MODULE).vvp $(SRCS)

simulate: compile
	@echo "Running simulation with Icarus Verilog..."
	cd $(SIM_DIR) && vvp $(TB_MODULE).vvp > simulation_results.txt
	@echo "Simulation complete. Results in $(SIM_DIR)/simulation_results.txt"

waveform:
	@echo "Opening waveform with GTKWave..."
	gtkwave $(SIM_DIR)/dump.vcd &

clean_icarus:
	@echo "Cleaning Icarus files..."
	rm -rf $(SIM_DIR)/*.vvp $(SIM_DIR)/*.vcd
endif

# Vivado targets
ifeq ($(SIM), vivado)
compile:
	@echo "Compiling with Vivado..."
	@mkdir -p vivado_project
	vivado -mode batch -source scripts/compile_vivado.tcl

simulate: compile
	@echo "Running simulation with Vivado..."
	vivado -mode batch -source scripts/simulate_vivado.tcl

clean_vivado:
	@echo "Cleaning Vivado files..."
	rm -rf vivado_project *.jou *.log
endif

# Synthesis targets (requires synthesis tool)
synthesize:
	@echo "Synthesis target - tool specific implementation needed"
	@echo "Add your synthesis tool commands here"

# Lint/Style check
lint:
	@echo "Running style checks..."
	@if command -v verilator >/dev/null 2>&1; then \
		verilator --lint-only --top-module $(TOP_MODULE) $(SRCS); \
	else \
		echo "Verilator not found. Install for linting capability."; \
	fi

# Documentation generation
docs:
	@echo "Generating documentation..."
	@mkdir -p docs
	@echo "Add documentation generation commands here"

# Test targets
test: simulate
	@echo "Running tests..."
	@grep -q "FINAL VOTE COUNTS" $(SIM_DIR)/simulation_results.txt && echo "✓ Basic test passed" || echo "✗ Basic test failed"

# Coverage analysis (tool dependent)
coverage:
	@echo "Coverage analysis - tool specific implementation needed"

# Clean all generated files
clean:
	@echo "Cleaning all generated files..."
	rm -rf work transcript *.wlf *.vstf *.vcd *.vvp
	rm -rf $(SIM_DIR)/*.vcd $(SIM_DIR)/*.vvp $(SIM_DIR)/simulation_results.txt
	rm -rf vivado_project *.jou *.log
	rm -rf db incremental_db output_files

# Setup development environment
setup:
	@echo "Setting up development environment..."
	@mkdir -p $(SRC_DIR) $(SIM_DIR) docs constraints scripts

# Help target
help:
	@echo "Available targets:"
	@echo "  all        - Compile and simulate (default)"
	@echo "  compile    - Compile source files"
	@echo "  simulate   - Run simulation in batch mode"
	@echo "  gui        - Run simulation with GUI (ModelSim)"
	@echo "  waveform   - Open waveform viewer"
	@echo "  lint       - Run style/lint checks"
	@echo "  test       - Run basic tests"
	@echo "  synthesize - Run synthesis"
	@echo "  docs       - Generate documentation"
	@echo "  coverage   - Run coverage analysis"
	@echo "  clean      - Clean generated files"
	@echo "  setup      - Setup directory structure"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  SIM        - Simulator to use (modelsim|icarus|vivado)"
	@echo ""
	@echo "Examples:"
	@echo "  make SIM=icarus simulate"
	@echo "  make gui"
	@echo "  make clean"

.PHONY: all compile simulate gui waveform lint test synthesize docs coverage clean setup help
