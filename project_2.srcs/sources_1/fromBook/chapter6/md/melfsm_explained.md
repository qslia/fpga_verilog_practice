
# `melfsm` — Finite-State Machine (FSM) Explained

## What is an FSM?
A **Finite-State Machine (FSM)** is a computational model that moves between a **finite** number of **states** based on inputs. It’s defined by:
- A set of states
- Inputs and (optionally) outputs
- A **next-state function** (how you move from the current state to the next)
- An **output function** (how outputs are produced from the current state and/or inputs)

Two common hardware styles:
- **Moore FSM**: outputs depend **only** on the current state (registered or combinational).
- **Mealy FSM**: outputs depend on the **current state and inputs** (often gives earlier/“same-cycle” outputs).

Your module is a **Mealy** FSM because `y` is driven in the **combinational** block and depends on **both** the state (`cst`) and the input (`din`) (e.g., in state `S3`, `y` is `1` only when `din == 0`).

---

## What the provided Verilog does

### Module IO and State Encoding
```verilog
module melfsm (
    din,
    reset,
    clk,
    y
);
    input din;          // serial input bit stream
    input clk;          // clock
    input reset;        // synchronous reset (active-high)
    output reg y;       // output (asserted for one cycle on pattern match)

    reg [1:0] cst, nst; // current state, next state
    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;
```

### Combinational next-state / output logic
```verilog
    always @(cst or din) begin
        case (cst)
            S0: if (din == 1'b1) begin
                    nst = S1; y = 1'b0;
                end else begin
                    nst = cst; y = 1'b0;
                end
            S1: if (din == 1'b0) begin
                    nst = S2; y = 1'b0;
                end else begin
                    nst = cst; y = 1'b0;
                end
            S2: if (din == 1'b1) begin
                    nst = S3; y = 1'b0;
                end else begin
                    nst = S0; y = 1'b0;
                end
            S3: if (din == 1'b0) begin
                    nst = S0; y = 1'b1; // assert output on match
                end else begin
                    nst = S1; y = 1'b0;
                end
            default: nst = S0; // (y isn't assigned here → see notes below)
        endcase
    end
```

### Sequential state register (synchronous reset)
```verilog
    always @(posedge clk) begin
        if (reset) cst <= S0;
        else       cst <= nst;
    end
endmodule
```

---

## Behavior: It detects the bit pattern **`1 0 1 0`** (overlapping allowed)

- From **`S0`**: seeing `1` → go to **`S1`**, else stay in `S0`.
- From **`S1`**: seeing `0` → go to **`S2`**, else stay in `S1`.
- From **`S2`**: seeing `1` → go to **`S3`**, else go to `S0`.
- From **`S3`**: seeing `0` → **assert `y=1`** and go to `S0` (pattern completed);
  seeing `1` → go to `S1` (this enables **overlap**, e.g., `...10101...`).

Therefore, whenever the input stream contains `... 1 0 1 0 ...`, the FSM asserts `y=1` **on the cycle where the last `0` is present** (Mealy output timing).

### Example timeline (Mealy timing)
| Cycle | din | cst (before) | nst (after comb) | y |
|------:|-----|---------------|------------------|---|
|   t0  |  1  | S0            | S1               | 0 |
|   t1  |  0  | S1            | S2               | 0 |
|   t2  |  1  | S2            | S3               | 0 |
|   t3  |  0  | S3            | S0               | **1** ← pattern `1010` detected |

Because `y` is produced in the **combinational** block, it reflects the current input **in the same cycle** (a Mealy characteristic).

---

## Is this Moore or Mealy?
**Mealy.** Output `y` depends on both `cst` and **current** `din` inside the combinational block (see `S3` case). A Moore version would assert `y` based solely on a dedicated “match” state, independent of `din` *that* cycle.

---

## Notes & Best Practices

1. **Combinational sensitivity list**  
   Prefer `always @(*)` over `always @(cst or din)` so the simulator infers the full sensitivity list automatically.
   ```verilog
   always @(*) begin
       // ...
   end
   ```

2. **Provide safe defaults** to avoid unintended latches and to keep `y` well-defined on `default:`
   ```verilog
   always @(*) begin
       nst = cst;   // default: hold state
       y   = 1'b0;  // default: deassert output

       case (cst)
           // state cases override as needed
       endcase
   end
   ```
   In your code, `default:` does not assign `y`, which could infer a latch in simulation/synthesis if an illegal state occurs.

3. **Sequential vs combinational assignments**  
   - Use **nonblocking** (`<=`) in clocked (`posedge clk`) blocks for state regs.
   - Use **blocking** (`=`) in **combinational** blocks for `nst`/`y` calculations—your code already follows this convention.

4. **Synchronous reset** (as written) is fine. If you need asynchronous reset, use `@(posedge clk or posedge reset)` and guard `reset` accordingly, matching your target library.

5. **Overlapping detection** is supported (from `S3` with `din==1` → `S1`). If you wanted **non-overlapping**, you’d typically return to `S0` after a detection regardless of `din`.

---

## A slightly cleaned-up version
```verilog
module melfsm (
    input  wire din,
    input  wire clk,
    input  wire reset,   // synchronous, active-high
    output reg  y
);
    typedef enum logic [1:0] { S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11 } state_t;
    state_t cst, nst;

    // Next-state and output (combinational)
    always @(*) begin
        nst = cst;
        y   = 1'b0;
        unique case (cst)
            S0: if (din)      nst = S1;
            S1: if (!din)     nst = S2;
            S2: if (din)      nst = S3; else nst = S0;
            S3: if (!din) begin
                      nst = S0;
                      y   = 1'b1; // detect 1-0-1-0
                  end else begin
                      nst = S1;   // overlap support
                  end
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset) cst <= S0;
        else       cst <= nst;
    end
endmodule
```

---

## Quick test idea
Feed `din = 1,0,1,0,1,0` over successive cycles. You should see `y` pulse high on the **2nd** and **4th** zeros (two detections with overlap).

---

## TL;DR
- This is a **Mealy FSM** that detects the serial pattern **`1010`**.
- `y` goes high **in the same cycle** as the final `0` of the pattern.
- Minor cleanups: use `always @(*)`, set default `nst`/`y` in the combinational block, and ensure `y` is assigned in every path (including `default:`).

