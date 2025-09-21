# Why Sum is Always 25 - Analysis

## Problem Overview

In the `loop_examples.v` module, the `sum` output is always 25 regardless of the `count` input value. This happens due to **multiple driver conflict** in the Verilog code.

## Root Cause Analysis

### Multiple Always Blocks Driving the Same Signal

The `sum` signal is being driven by **two different always blocks**:

1. **REPEAT LOOP block** (lines 23-32):
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

2. **FOR LOOP block** (lines 79-88):
```verilog
always @(posedge clk or posedge reset) begin
  if (reset) begin
    sum = 0;
  end else begin
    sum = 0;
    for (k = 0; k < 5; k = k + 1) begin
      sum = sum + 5;  // This always executes 5 times
    end
  end
end
```

### Why Sum is Always 25

The FOR LOOP block **always wins** because:

1. **Fixed iteration count**: The for loop always executes exactly 5 times (`k < 5`)
2. **Fixed increment**: Each iteration adds 5 to sum
3. **Calculation**: 5 iterations × 5 per iteration = **25**
4. **Driver priority**: In Verilog simulation, when multiple always blocks drive the same signal, the result is unpredictable, but in this case, the for loop block appears to take precedence

### Expected vs Actual Behavior

| Count Input | Expected Sum (repeat loop) | Actual Sum | Reason |
|-------------|---------------------------|------------|---------|
| 3           | 15 (3 × 5)               | 25         | For loop overrides |
| 7           | 35 (7 × 5)               | 25         | For loop overrides |
| 0           | 0 (0 × 5)                | 25         | For loop overrides |
| 255         | 1275 (255 × 5)           | 25         | For loop overrides |

## Simulation Evidence

From the testbench monitoring:
- Time changes
- Count input changes (3, 7, 0, 255)
- **Sum remains constant at 25**
- This confirms the for loop block is the dominant driver

## Solutions

### Option 1: Remove Conflicting Always Block
Remove either the repeat loop block or the for loop block to eliminate the conflict.

### Option 2: Use Different Output Signals
Create separate output signals for each loop type:
```verilog
output reg [15:0] sum_repeat,    // For repeat loop
output reg [15:0] sum_for        // For for loop
```

### Option 3: Use Conditional Logic
Combine the logic into a single always block with a mode select input.

## Verilog Design Rule Violated

**Rule**: Never drive the same signal from multiple always blocks unless using proper arbitration logic.

**Consequence**: Unpredictable behavior, simulation/synthesis mismatches, and functional errors.

## Conclusion

The sum is always 25 because the FOR LOOP always block executes 5 iterations of adding 5, regardless of the `count` input. The REPEAT LOOP block, which should respond to the `count` input, is being overridden by this conflicting driver.

To fix this issue, the design should be restructured to have only one always block driving the `sum` output, or separate output signals should be used for different loop demonstrations.
