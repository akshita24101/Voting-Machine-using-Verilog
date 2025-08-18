# Voting Machine using Verilog

A digital voting machine implementation in SystemVerilog that allows three candidates (A, B, C) to receive votes with real-time counting, winner determination, and visual feedback through LED indicators.

## Features

- **Three-Candidate Voting**: Support for candidates A, B, and C
- **Vote Validation**: Prevents multiple simultaneous button presses
- **Real-time Counting**: 4-bit counters for each candidate (0-15 votes)
- **Winner Determination**: Automatic winner calculation with tie detection
- **Visual Feedback**: LED indicators that blink for 5 clock cycles after each vote
- **Reset Functionality**: System reset capability to restart voting
- **Comprehensive Testing**: Full testbench with various voting scenarios

## System Architecture

### Module Interface

```systemverilog
module voting_machine (
    input logic clk,           // System clock
    input logic reset,         // Active-high reset
    input logic vote_A,        // Vote button for candidate A
    input logic vote_B,        // Vote button for candidate B
    input logic vote_C,        // Vote button for candidate C
    output logic led_A,        // LED indicator for candidate A
    output logic led_B,        // LED indicator for candidate B
    output logic led_C,        // LED indicator for candidate C
    output logic [3:0] count_A, // Vote count for candidate A
    output logic [3:0] count_B, // Vote count for candidate B
    output logic [3:0] count_C, // Vote count for candidate C
    output logic [1:0] winner   // Winner indication (00-tie, 01-A, 10-B, 11-C)
);
```

### Key Components

1. **Vote Counters**: 4-bit counters for each candidate
2. **LED Timers**: 4-bit countdown timers for visual feedback
3. **Vote Validation Logic**: Ensures only one vote is registered per clock cycle
4. **Winner Logic**: Combinational logic to determine the winner

## Voting Logic

- **Valid Vote**: Only one button pressed at a time
- **Invalid Vote**: Multiple buttons pressed simultaneously (ignored)
- **LED Feedback**: LEDs blink for 5 clock cycles after a valid vote
- **Winner Determination**: 
  - `2'b01`: Candidate A wins
  - `2'b10`: Candidate B wins
  - `2'b11`: Candidate C wins
  - `2'b00`: Tie or no clear winner

## File Structure

```
Voting-Machine-using-Verilog/
├── src/
│   ├── voting_machine.sv          # Main voting machine module
│   └── testbench.sv               # Comprehensive testbench
├── docs/
│   ├── block_diagram.png          # System block diagram
│   └── timing_diagram.png         # Timing analysis
├── simulation/
│   ├── dump.vcd                   # VCD waveform file
│   └── simulation_results.txt     # Simulation output
├── constraints/
│   └── timing_constraints.sdc     # Synthesis constraints
├── README.md                      # This file
├── LICENSE                        # MIT License
└── .gitignore                     # Git ignore file
```

## Getting Started

### Prerequisites

- **Simulator**: EDA Playground, Vivado, or any SystemVerilog-compatible simulator

### Running the Simulation

## Running the Voting Machine on EDA Playground

You can simulate the Voting Machine design directly on [EDA Playground](https://www.edaplayground.com/).

---

### 1. Project Setup
1. Go to [EDA Playground](https://www.edaplayground.com/).  
2. Select **SystemVerilog** as the language.  
3. Choose a simulator (e.g., **Icarus Verilog** or **Synopsys VCS**).  
4. Add your source files:
   - `voting_machine.sv` as the main file
   - `testbench.sv` as a second file 

---

### 2. Modify Testbench for EDA Playground

EDA Playground automatically handles waveform generation, so you can remove or comment out these lines in `testbench.sv`:

```verilog
$dumpfile("dump.vcd");
$dumpvars(0, testbench);


### Expected Output

```
---- FINAL VOTE COUNTS ----  
Votes for A: 0  
Votes for B: 2  
Votes for C: 4  
Winner: C  

## Test Scenarios

The testbench covers the following scenarios:

1. **Basic Voting**: Single votes for each candidate
2. **Invalid Voting**: Multiple simultaneous button presses (should be ignored)
3. **Sequential Voting**: Multiple votes for the same candidate
4. **System Reset**: Mid-simulation reset functionality
5. **Winner Determination**: Various winning scenarios including ties


## Future Enhancements

- [ ] Add password-protected admin mode
- [ ] Implement vote result display on 7-segment displays
- [ ] Add UART interface for remote monitoring
- [ ] Include vote timestamp logging
- [ ] Add more candidates (expandable to N candidates)
- [ ] Implement weighted voting system


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

- **Akshita** - *Initial work* - [akshita24101](https://github.com/akshita24101)

## Acknowledgments

- SystemVerilog community for best practices
- Digital design principles from various textbooks
- Open-source EDA tools community

---

## Technical Specifications

| Parameter | Value |
|-----------|-------|
| Clock Frequency | User-defined |
| Vote Counter Width | 4 bits (0-15 votes) |
| LED Blink Duration | 5 clock cycles |
| Reset Type | Asynchronous, active-high |
| Technology | SystemVerilog (IEEE 1800) |

---

