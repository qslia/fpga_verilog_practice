# Verilog MUX Modules Analysis

## Overview
This document analyzes two Verilog multiplexer (MUX) modules: `mux_bh` and `mux_bh1`, and explains the `@` symbol in Verilog.

## Module Comparison

### mux_bh Module
```verilog
module mux_bh (
    input  a,
    b,
    s,
    output y
);
  reg y;
  always @(s or a or b) begin
    if (s == 0) y = a;
    else y = b;
  end
endmodule
```

### mux_bh1 Module
```verilog
module mux_bh1 (
    input  a,
    b,
    s,
    output y
);
  reg y;
  always @(*) begin
    if (s == 0) y = a;
    else y = b;
  end
endmodule
```

## Key Differences

### 1. Sensitivity List
- **mux_bh**: Uses explicit sensitivity list `@(s or a or b)`
- **mux_bh1**: Uses wildcard sensitivity list `@(*)`

### 2. Behavioral Implications

#### mux_bh (Explicit Sensitivity List)
- The `always` block executes only when `s`, `a`, or `b` changes
- More explicit and traditional Verilog style
- Requires manual specification of all signals that should trigger the block
- Less prone to simulation/synthesis mismatches in older tools

#### mux_bh1 (Wildcard Sensitivity List)
- The `always` block executes when ANY signal used in the block changes
- Automatically detects all signals in the block (a, b, s)
- More convenient and less error-prone
- Modern Verilog style (introduced in Verilog 2001)
- Reduces the chance of missing signals in the sensitivity list

## The `@` Symbol in Verilog

The `@` symbol in Verilog is called the **event control operator** or **sensitivity list operator**. It defines when a procedural block should execute.

### Syntax
```verilog
always @(sensitivity_list) begin
    // procedural statements
end
```

### Types of Sensitivity Lists

1. **Explicit List**: `@(signal1 or signal2 or signal3)`
   - Block executes when any of the specified signals change
   - Example: `@(s or a or b)`

2. **Wildcard List**: `@(*)` or `@(*)`
   - Block executes when any signal used in the block changes
   - Automatically inferred by the compiler
   - Example: `@(*)`

3. **Edge-Triggered**: `@(posedge clk)` or `@(negedge clk)`
   - Block executes on rising or falling edge of a signal
   - Used for sequential logic (flip-flops, registers)

4. **Mixed**: `@(posedge clk or negedge reset)`
   - Combines edge-triggered and level-sensitive events

### Other Uses of `@`

1. **Wait Statements**: `@(negedge en);` - Wait for a specific event
2. **Event Control in Testbenches**: Used to synchronize testbench events
3. **Named Events**: `@(event_name);` - Wait for custom events

## Functional Equivalence

Both `mux_bh` and `mux_bh1` modules are functionally identical:
- They implement a 2-to-1 multiplexer
- When `s = 0`, output `y = a`
- When `s = 1`, output `y = b`
- Both use behavioral modeling with `if-else` statements

## Recommendations

- **Use `@(*)`** for combinational logic (like these MUX modules)
- **Use explicit lists** only when you need specific control over sensitivity
- **Use edge-triggered** (`@(posedge clk)`) for sequential logic
- **Always use `@(*)`** for combinational always blocks to avoid simulation/synthesis mismatches

## Summary

The main difference between these modules is the sensitivity list style:
- `mux_bh`: Traditional explicit sensitivity list
- `mux_bh1`: Modern wildcard sensitivity list

Both are functionally equivalent, but `mux_bh1` is preferred in modern Verilog design due to its convenience and reduced error potential.
