# Finite State Machines (melfsm.v) - Complete Analysis

## Overview
This file contains two Verilog modules implementing **Finite State Machines (FSMs)** for sequence detection. Both modules demonstrate different approaches to FSM design:
- `melfsm`: A Mealy FSM for detecting the sequence "1010"
- `moore2`: A Moore FSM for detecting the sequence "10100"

## Module 1: melfsm - Mealy FSM

### Module Declaration
```verilog
module melfsm (
    din,    // Serial data input
    reset,  // Asynchronous reset
    clk,    // Clock signal
    y       // Output (sequence detected)
);
```

### Port Specifications
| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `din` | Input | 1-bit | Serial data input stream |
| `clk` | Input | 1-bit | Clock signal for synchronous operation |
| `reset` | Input | 1-bit | Asynchronous reset signal |
| `y` | Output | 1-bit | Output signal (1 when sequence detected) |

### State Definition
```verilog
parameter S0 = 2'b00,  // Initial state / Reset state
          S1 = 2'b01,  // After receiving '1'
          S2 = 2'b10,  // After receiving '10'
          S3 = 2'b11;  // After receiving '101'
```

### State Variables
- `cst [1:0]`: Current state register
- `nst [1:0]`: Next state logic

### Sequence Detection: "1010"
The FSM detects the overlapping sequence "1010":

#### State Transition Diagram
```
     din=1        din=0        din=1        din=0
S0 --------> S1 --------> S2 --------> S3 --------> S0
|             |             |             |          (y=1)
|din=0        |din=1        |din=0        |din=1
|             |             |             |
v             v             v             v
S0           S1           S0           S1
```

#### State Transition Table
| Current State | Input | Next State | Output |
|---------------|-------|------------|--------|
| S0 | 0 | S0 | 0 |
| S0 | 1 | S1 | 0 |
| S1 | 0 | S2 | 0 |
| S1 | 1 | S1 | 0 |
| S2 | 0 | S0 | 0 |
| S2 | 1 | S3 | 0 |
| S3 | 0 | S0 | **1** |
| S3 | 1 | S1 | 0 |

### Combinational Logic (Next State and Output)
```verilog
always @(cst or din) begin
    case (cst)
        S0: if (din == 1'b1) begin nst = S1; y = 1'b0; end
            else begin nst = cst; y = 1'b0; end
        S1: if (din == 1'b0) begin nst = S2; y = 1'b0; end
            else begin y = 1'b0; nst = cst; end
        S2: if (din == 1'b1) begin nst = S3; y = 1'b0; end
            else begin nst = S0; y = 1'b0; end
        S3: if (din == 1'b0) begin nst = S0; y = 1'b1; end
            else begin nst = S1; y = 1'b0; end
        default: nst = S0;
    endcase
end
```

### Sequential Logic (State Register)
```verilog
always @(posedge clk) begin
    if (reset) cst <= S0;
    else cst <= nst;
end
```

### Mealy Machine Characteristics
1. **Output depends on both current state and input**
2. **Immediate response**: Output changes as soon as input changes
3. **Fewer states**: Generally requires fewer states than Moore machines
4. **Glitch-prone**: Output may have glitches due to input transitions

## Module 2: moore2 - Moore FSM

### Module Declaration
```verilog
module moore2 (
    din,    // Serial data input
    reset,  // Asynchronous reset
    clk,    // Clock signal
    y       // Output (sequence detected)
);
```

### State Definition
```verilog
parameter S0 = 3'b000,  // Initial state
          S1 = 3'b001,  // After receiving '1'
          S2 = 3'b010,  // After receiving '10'
          S3 = 3'b011,  // After receiving '101'
          S4 = 3'b100;  // After receiving '1010' (sequence detected)
```

### Sequence Detection: "10100"
The FSM detects the sequence "10100" (extended version):

#### State Transition Diagram
```
     din=1        din=0        din=1        din=0        din=0/1
S0 --------> S1 --------> S2 --------> S3 --------> S4 --------> ...
|             |             |             |          (y=1)
|din=0        |din=1        |din=0        |din=1
|             |             |             |
v             v             v             v
S0           S1           S0           S1
```

#### State Transition Table
| Current State | Input | Next State | Output |
|---------------|-------|------------|--------|
| S0 | 0 | S0 | 0 |
| S0 | 1 | S1 | 0 |
| S1 | 0 | S2 | 0 |
| S1 | 1 | S1 | 0 |
| S2 | 0 | S0 | 0 |
| S2 | 1 | S3 | 0 |
| S3 | 0 | S4 | 0 |
| S3 | 1 | S1 | 0 |
| S4 | 0 | S1 | **1** |
| S4 | 1 | S3 | **1** |

### Moore Machine Characteristics
1. **Output depends only on current state**
2. **Delayed response**: Output changes only on clock edge
3. **More states**: Generally requires more states than Mealy machines
4. **Glitch-free**: Output is stable and synchronized

## Comparison: Mealy vs Moore FSMs

| Aspect | Mealy FSM (`melfsm`) | Moore FSM (`moore2`) |
|--------|----------------------|----------------------|
| **Output Logic** | f(current_state, input) | f(current_state) |
| **Response Time** | Immediate (combinational) | Delayed (one clock cycle) |
| **Number of States** | 4 states | 5 states |
| **Sequence Length** | "1010" (4 bits) | "10100" (5 bits) |
| **Output Stability** | May have glitches | Glitch-free |
| **State Encoding** | 2 bits | 3 bits |
| **Power Consumption** | Lower (fewer flip-flops) | Higher (more flip-flops) |

## Timing Analysis

### Mealy FSM Timing
```
clk   __|‾|__|‾|__|‾|__|‾|__|‾|__
din   ____|‾‾‾‾|___|‾‾‾‾|_______
state S0  S0 S1  S1 S2  S2 S3  S3
y     __________________|‾|_____
                        ↑
                   Output immediate
```

### Moore FSM Timing
```
clk   __|‾|__|‾|__|‾|__|‾|__|‾|__|‾|__
din   _____|‾‾‾‾|___|‾‾‾‾|___|_______
state S0   S0 S1  S1 S2  S2 S3  S3 S4
y     __________________________|‾‾‾
                                 ↑
                          Output on clock edge
```

## Design Considerations

### 1. **Overlapping Sequences**
Both FSMs handle overlapping sequences correctly:
- When "1010" is detected, the FSM doesn't reset completely
- It transitions to appropriate state to catch overlapping patterns

### 2. **Reset Behavior**
- **Asynchronous Reset**: Both FSMs use asynchronous reset
- **Reset State**: Both return to S0 on reset
- **Reset Priority**: Reset has higher priority than clock

### 3. **Encoding Schemes**
- **Binary Encoding**: Both use binary state encoding
- **One-Hot Alternative**: Could use one-hot for faster decoding
- **Gray Code Alternative**: Could use Gray code for low power

### 4. **Synthesis Considerations**
- **State Register**: Synthesizes to flip-flops
- **Next State Logic**: Synthesizes to combinational logic
- **Output Logic**: Mealy requires more complex output logic

## Applications

### 1. **Communication Protocols**
- Frame synchronization patterns
- Start/stop bit detection
- Protocol header detection

### 2. **Data Processing**
- Pattern matching in data streams
- Error detection sequences
- Command recognition

### 3. **Control Systems**
- Sequence-based control logic
- Safety interlock systems
- Mode switching controllers

## Testing Strategy

### Test Vectors for "1010" Detection (Mealy)
```verilog
// Test sequence: 1101010110100
Input:  1 1 0 1 0 1 0 1 1 0 1 0 0
Output: 0 0 0 0 1 0 1 0 0 0 0 1 0
              ↑   ↑           ↑
          Detected sequences
```

### Test Vectors for "10100" Detection (Moore)
```verilog
// Test sequence: 110100101001010100
Input:  1 1 0 1 0 0 1 0 1 0 0 1 0 1 0 1 0 0
Output: 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 1
                  ↑       ↑           ↑ ↑
              Detected sequences
```

## Common Design Issues

### 1. **Incomplete Case Statements**
- Always include `default` case
- Prevents synthesis warnings and undefined behavior

### 2. **Sensitivity List**
- Mealy: Include both `cst` and `din`
- Moore: Include only `cst` for output logic

### 3. **Reset Implementation**
- Use consistent reset polarity
- Ensure all registers are properly reset

### 4. **State Assignment**
- Choose encoding for optimal area/speed trade-off
- Consider state transition frequency

## Summary

These FSM implementations demonstrate fundamental concepts in digital sequence detection:

- **Mealy FSM** (`melfsm`): Provides immediate response with fewer states but potential output glitches
- **Moore FSM** (`moore2`): Offers stable, synchronized outputs with more states and one clock delay

Both designs showcase proper FSM coding practices including:
- Clear state definitions using parameters
- Separate combinational and sequential logic blocks
- Proper reset handling
- Complete case coverage

The choice between Mealy and Moore depends on specific application requirements for timing, area, and output stability.
