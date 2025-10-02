# What is 'always' Used For in Verilog HDL

## Overview
The `always` construct is one of the most fundamental and versatile features in Verilog HDL. It creates **procedural blocks** that execute repeatedly based on specified conditions, making it essential for modeling both **combinational** and **sequential** logic.

## Basic Syntax
```verilog
always @(sensitivity_list) begin
    // Procedural statements
end
```

## Types of Always Blocks (with Examples from Your Code)

### 1. **Combinational Logic** - Always @(*)
```verilog
// Example from mux_bh1 module (line 106)
always @(*) begin
    if (s == 0) y = a;
    else y = b;
end
```
**Purpose**: Models combinational logic that responds to any input change
**Key Points**: 
- Uses `@(*)` to automatically detect all input signals
- Output changes immediately when inputs change
- No memory/storage

### 2. **Combinational Logic** - Manual Sensitivity List
```verilog
// Example from mux_bh module (line 92)
always @(s or a or b) begin
    if (s == 0) y = a;
    else y = b;
end

// Example from your selected line 270
always @(s[1] or t1 or t2) begin
    if (s[1] == 0) y = t1;
    else y = t2;
end
```
**Purpose**: Same as above, but manually specifies which signals trigger the block
**Key Points**:
- Must list ALL signals that affect the output
- More error-prone than `@(*)`

### 3. **Sequential Logic** - Clocked (Synchronous)
```verilog
// Example from line 75
always @(posedge clk) q <= d;  // Simple D flip-flop

// Example from mac module (line 152)
always @(posedge clk) begin
    d <= a + b;
    s <= c + d;
end
```
**Purpose**: Models sequential logic that changes on clock edges
**Key Points**:
- Uses `posedge` (rising edge) or `negedge` (falling edge)
- Creates flip-flops and registers
- Uses non-blocking assignments (`<=`) for proper timing

### 4. **Sequential Logic** - Blocking Assignments (Problematic)
```verilog
// Example from second mac module (line 167)
always @(posedge clk) begin
    d = a + b;    // Blocking assignment
    s = c + d;    // Uses updated value of d immediately
end
```
**Purpose**: Same timing trigger, but different execution behavior
**Key Points**:
- Blocking assignments (`=`) execute sequentially
- Can cause race conditions and simulation/synthesis mismatches
- Generally discouraged for sequential logic

### 5. **Clock Generation**
```verilog
// Example from line 66
always #5 clk = ~clk;  // Toggle clock every 5 time units
```
**Purpose**: Generates periodic clock signals for testbenches
**Key Points**:
- No sensitivity list - runs continuously
- Uses delay (`#5`) to control frequency

### 6. **Event-Driven Procedural Blocks**
```verilog
// Example from lines 78-82
always begin
    wait (en);          // Wait for enable signal
    q <= d;             // Execute when enabled
    @(negedge en);      // Wait for enable to go low
end
```
**Purpose**: Complex control flow based on events
**Key Points**:
- Uses `wait` and `@` for event synchronization
- More complex than simple sensitivity lists

## When to Use Always Blocks

| Logic Type | Always Block Style | Assignment Type | Example Use |
|------------|-------------------|-----------------|-------------|
| **Combinational** | `@(*)` or `@(signal list)` | Blocking (`=`) | Multiplexers, decoders, ALUs |
| **Sequential** | `@(posedge clk)` | Non-blocking (`<=`) | Registers, counters, state machines |
| **Latches** | `@(level)` | Blocking (`=`) | Level-sensitive storage (avoid) |
| **Testbench** | `#delay` or complex events | Either | Clock generation, stimulus |

## Key Rules and Best Practices

### 1. **Variable Types**
- Signals assigned in `always` blocks must be declared as `reg`
- `wire` signals use `assign` statements, not `always` blocks

### 2. **Assignment Types**
- **Combinational logic**: Use blocking assignments (`=`)
- **Sequential logic**: Use non-blocking assignments (`<=`)

### 3. **Sensitivity Lists**
- **Combinational**: Include ALL input signals or use `@(*)`
- **Sequential**: Use clock and reset signals only

### 4. **Synthesis Considerations**
- Combinational `always` blocks → logic gates
- Sequential `always` blocks → flip-flops/latches
- Incomplete sensitivity lists can cause synthesis/simulation mismatches

## Comparison: Always vs Assign

| Feature | `always` Block | `assign` Statement |
|---------|---------------|-------------------|
| **Signal Type** | `reg` | `wire` |
| **Logic Style** | Procedural (behavioral) | Continuous (dataflow) |
| **Complexity** | Can handle complex logic | Simple expressions only |
| **Control Flow** | if/else, case, loops | Conditional operator only |
| **Example** | `always @(*) if(s) y=a; else y=b;` | `assign y = s ? a : b;` |

## Common Applications

### 1. **Multiplexers**
```verilog
always @(*) begin
    case (select)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
    endcase
end
```

### 2. **Flip-Flops and Registers**
```verilog
always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end
```

### 3. **State Machines**
```verilog
always @(posedge clk) begin
    case (current_state)
        IDLE: if (start) next_state <= ACTIVE;
        ACTIVE: if (done) next_state <= IDLE;
    endcase
end
```

## Common Mistakes to Avoid

1. **Incomplete sensitivity lists** (missing input signals)
2. **Mixing blocking and non-blocking** assignments inappropriately
3. **Multiple always blocks** driving the same signal
4. **Combinational loops** in always blocks
5. **Using `reg` declaration** to mean "register" (it just means "can be assigned in always")

## Summary
The `always` construct is Verilog's primary tool for describing **behavior** rather than just **structure**. It allows you to:

- **Model complex logic** using familiar programming constructs (if/else, case, loops)
- **Create both combinational and sequential circuits**
- **Control when and how logic executes**
- **Build everything from simple gates to complex processors**

Understanding `always` blocks is crucial for effective Verilog design - they're the bridge between software-like thinking and hardware implementation!
