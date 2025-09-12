# Loop Examples Sum Analysis - Why Sum is Always 25

## Overview

In the `loop_examples.v` module, the `sum` output signal consistently shows a value of 25, regardless of the `count` input value. This document explains why this happens and how to fix it.

## The Problem: Multiple Drivers

The root cause is that **two separate `always` blocks are driving the same `sum` signal**, creating a multiple driver conflict.

### Driver 1: REPEAT Loop Block (Lines 23-32)

```verilog
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum = 0;
  end else begin
    sum = 0;  // Reset sum before repeat
    repeat (count) begin
      sum = sum + 5;
    end
  end
end
```

**Expected behavior**: This block should calculate `sum = count × 5`
- If count = 3, sum should be 15
- If count = 7, sum should be 35
- If count = 0, sum should be 0

### Driver 2: FOR Loop Block (Lines 79-88)

```verilog
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum = 0;
  end else begin
    sum = 0;
    for (k = 0; k < 5; k = k + 1) begin
      sum = sum + 5;
    end
  end
end
```

**Actual behavior**: This block **always** calculates `sum = 5 × 5 = 25`
- The loop counter `k` goes from 0 to 4 (5 iterations)
- Each iteration adds 5 to sum
- Final result: 0 + 5 + 5 + 5 + 5 + 5 = 25

## Why FOR Loop Wins

In Verilog simulation, when multiple `always` blocks drive the same signal:

1. **Race condition**: Both blocks execute on the same clock edge
2. **Last writer wins**: The block that executes last determines the final value
3. **Simulation order**: The FOR loop block appears to execute after the REPEAT loop block

## Simulation Evidence

From your testbench output, you can observe:

| Test Case | Count Input | Expected Sum (REPEAT) | Actual Sum | 
|-----------|-------------|----------------------|------------|
| Test 1    | 3           | 15                   | 25         |
| Test 2    | 7           | 35                   | 25         |
| Test 3    | 0           | 0                    | 25         |
| Test 4    | 255         | 1275                 | 25         |

The sum remains constant at 25 because the FOR loop always executes exactly 5 iterations.

## The Verilog Rule Violation

**Rule**: A signal should only be driven by one `always` block (unless using proper tri-state logic).

**Violation**: The `sum` signal is driven by two different `always` blocks.

**Consequences**:
- Unpredictable behavior
- Simulation vs synthesis mismatches
- Functional errors
- Potential synthesis warnings/errors

## Solutions

### Solution 1: Use Separate Output Signals

```verilog
module loop_examples (
    input clk,
    input reset,
    input [7:0] count,
    output reg [15:0] sum_repeat,  // For repeat loop
    output reg [15:0] sum_for,     // For for loop
    output reg clock_out
);

// REPEAT LOOP
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum_repeat = 0;
  end else begin
    sum_repeat = 0;
    repeat (count) begin
      sum_repeat = sum_repeat + 5;
    end
  end
end

// FOR LOOP
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum_for = 0;
  end else begin
    sum_for = 0;
    for (k = 0; k < 5; k = k + 1) begin
      sum_for = sum_for + 5;
    end
  end
end
```

### Solution 2: Use Mode Selection

```verilog
module loop_examples (
    input clk,
    input reset,
    input [7:0] count,
    input mode,  // 0 = repeat loop, 1 = for loop
    output reg [15:0] sum,
    output reg clock_out
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum = 0;
  end else begin
    sum = 0;
    if (mode == 0) begin
      // REPEAT LOOP
      repeat (count) begin
        sum = sum + 5;
      end
    end else begin
      // FOR LOOP
      for (k = 0; k < 5; k = k + 1) begin
        sum = sum + 5;
      end
    end
  end
end
```

### Solution 3: Remove Conflicting Block

Simply comment out or remove one of the conflicting `always` blocks to eliminate the multiple driver issue.

## Key Takeaways

1. **Multiple drivers cause unpredictable behavior** - avoid driving the same signal from multiple `always` blocks
2. **The FOR loop has a fixed iteration count** - it will always produce the same result (25)
3. **The REPEAT loop responds to input** - it should vary based on the `count` input
4. **Proper design requires single drivers** - each signal should have only one source

## Testing Recommendation

After implementing any of the solutions:

1. Run the testbench again
2. Verify that the sum changes with different count values
3. Check for synthesis warnings about multiple drivers
4. Ensure the behavior matches your design intent

This analysis explains why your sum is always 25 and provides multiple paths to fix the issue while maintaining the educational value of demonstrating different loop types in Verilog.
