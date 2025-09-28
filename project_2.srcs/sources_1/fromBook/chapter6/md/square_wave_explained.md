
# `square_wave` Module — FSM for Generating a Square Wave

## Overview
This Verilog module `square_wave` implements a **finite-state machine (FSM)** that generates a programmable square wave output signal.  
The duty cycle (ratio of "on" to "off" time) is controlled by the parameters `on_time` and `off_time`.

---

## Module Interface

```verilog
module square_wave #(
    parameter N = 4,              // width of counter (enough to hold on/off times)
    on_time  = 3'd5,              // number of clock cycles output stays high
    off_time = 3'd3               // number of clock cycles output stays low
) (
    input  wire clk,              // system clock
    input  wire reset,            // synchronous reset
    output reg  s_wave             // generated square wave
);
```

- **Parameters:**
  - `N`: width of the timer counter (default 4 bits).
  - `on_time`: number of cycles the output `s_wave` stays **HIGH**.
  - `off_time`: number of cycles the output `s_wave` stays **LOW**.

- **Inputs/Outputs:**
  - `clk`: clock input.
  - `reset`: active-high reset, returns FSM to initial state.
  - `s_wave`: square-wave output.

---

## Internal Signals
```verilog
    localparam S0 = 0, S1 = 1;    // FSM states
    reg PS, NS;                   // Present State, Next State
    reg [N-1:0] t = 0;            // counter for timing
```

- `PS`: current state (low-phase or high-phase of the wave).
- `NS`: next state to transition into.
- `t`: counter to track how long we’ve been in a state.

---

## State Register (Sequential Logic)
```verilog
    always @(posedge clk) begin
        if (reset == 1'b1) PS <= S0;  // reset to low-phase
        else PS <= NS;
    end
```

- On each clock edge, `PS` updates to `NS`.
- Reset forces the FSM into state `S0` (output low).

---

## Counter Update Logic
```verilog
    always @(posedge clk) begin
        if (PS != NS) t <= 0;      // reset counter on state change
        else t <= t + 1;           // increment counter while staying in same state
    end
```

- The counter `t` is reset whenever the FSM changes state.
- Otherwise, it increments every cycle inside the same state.

---

## Combinational Next-State and Output Logic
```verilog
    always @(PS, t) begin
        case (PS)
            S0: begin
                s_wave = 1'b0;     // output low
                if (t == off_time - 1) NS = S1;  // after off_time cycles → go high
                else NS = S0;
            end
            S1: begin
                s_wave = 1'b1;     // output high
                if (t == on_time - 1) NS = S0;   // after on_time cycles → go low
                else NS = S1;
            end
        endcase
    end
```

- **State `S0`:** Output is low. After `off_time` cycles, transition to `S1` (high state).
- **State `S1`:** Output is high. After `on_time` cycles, transition to `S0` (low state).

---

## Behavior Example

If parameters are:
- `on_time = 5`
- `off_time = 3`

The waveform looks like:

```
clk:    _|-|_|-|_|-|_|-|_|-|_|-|_|-|_
s_wave: ____█████___█████___█████____
         <3c> <5c> <3c> <5c> ...
```

- `s_wave` stays **low for 3 cycles**, then **high for 5 cycles**, repeatedly.

---

## FSM Summary

- **States:**  
  - `S0`: Output low (duration = `off_time` cycles).  
  - `S1`: Output high (duration = `on_time` cycles).  

- **Transitions:**  
  - `S0 → S1` after `off_time` cycles.  
  - `S1 → S0` after `on_time` cycles.  

- **Output:**  
  - Directly tied to the FSM state:  
    - `S0 → s_wave = 0`  
    - `S1 → s_wave = 1`  

Thus, this is essentially a **Moore FSM** (output depends only on the current state).

---

## Notes & Improvements
1. **Sensitivity List:** Use `always @(*)` instead of `always @(PS, t)` to ensure all signals are included automatically in simulation.
2. **Counter Width:** Ensure `N` is wide enough to cover the maximum of `on_time` and `off_time`. For example, if either requires up to 16 cycles, set `N ≥ 4`.
3. **Duty Cycle Control:** By adjusting `on_time` and `off_time`, you can generate square waves of different duty cycles.
4. **Frequency Control:** The total period = `(on_time + off_time) * Tclk`. Adjusting parameters changes the generated frequency.

---

## TL;DR
This module implements a **Moore FSM square wave generator**:
- `s_wave = 0` for `off_time` cycles (`S0`),
- then `s_wave = 1` for `on_time` cycles (`S1`),
- repeating endlessly.

---
