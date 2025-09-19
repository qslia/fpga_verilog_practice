# Understanding `negedge en` in Verilog

## What is `negedge en`?

`negedge en` is a **negative edge detection** construct in Verilog that waits for a signal named `en` (enable) to transition from a high logic level (1) to a low logic level (0).

## Breaking Down the Term

- **`negedge`** = **Negative Edge** - detects a falling edge transition (1 → 0)
- **`en`** = The signal name (in this case, likely an "enable" signal)

## How It Works

```verilog
@(negedge en);  // Wait for enable to go low
```

This statement causes the execution to **pause** until the `en` signal transitions from:
- Logic 1 (high) → Logic 0 (low)

## Context in Your Code Example

```verilog
always begin
    wait (en);          // Wait for enable signal to be high (1)
    q <= d;             // Execute when enabled - assign d to q
    @(negedge en);      // Wait for enable to go low (1 → 0)
end
```

### Execution Flow:
1. **`wait (en)`** - Waits until `en` becomes high (1)
2. **`q <= d`** - When `en` is high, assigns the value of `d` to `q`
3. **`@(negedge en)`** - Waits for `en` to transition from high to low
4. **Loop repeats** - Goes back to step 1

## Edge Detection Types in Verilog

| Construct | Meaning | Transition |
|-----------|---------|------------|
| `@(posedge signal)` | Positive edge | 0 → 1 |
| `@(negedge signal)` | Negative edge | 1 → 0 |
| `@(signal)` | Any edge | 0 → 1 or 1 → 0 |

## Practical Use Cases

1. **Clock Domain Crossing** - Synchronizing between different clock domains
2. **Handshaking Protocols** - Waiting for acknowledgment signals
3. **State Machine Control** - Transitioning states based on control signals
4. **Reset Logic** - Detecting when reset signals are deasserted

## Important Notes

- **Simulation Only**: `@(negedge)` is primarily used in testbenches and behavioral modeling
- **Not Synthesizable**: Most synthesis tools cannot convert this directly to hardware
- **Blocking Statement**: Execution stops until the edge occurs
- **Must Have Transition**: The signal must actually change from 1 to 0, not just be at 0

## Example Waveform

```
Time:     0   1   2   3   4   5   6   7   8
en:       0   1   1   1   0   0   1   1   0
          ^           ^           ^       ^
          |           |           |       |
          |       negedge         |   negedge
          |       occurs          |   occurs
      posedge                 posedge
      occurs                  occurs
```

In this example, `@(negedge en)` would trigger at times 4 and 8.

## Related Concepts

- **`posedge`** - Opposite of negedge, detects rising edges (0 → 1)
- **`wait()`** - Level-sensitive waiting (waits for condition to be true)
- **`@()`** - Edge-sensitive waiting (waits for signal transition)
- **Event control** - General mechanism for controlling when statements execute

---
*Generated on: Friday, September 19, 2025*
