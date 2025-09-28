Great questions!

## 1) `last_level  <= s_wave;` — what is the “old value of `s_wave`” here?

* That line is inside `always @(posedge clk)`. With **nonblocking** assignments (`<=`), the **RHS is sampled immediately** at the event (the clock edge), and the **LHS updates at the end of the current time step**.
* So on a given clock edge, `last_level <= s_wave;` captures **the value of `s_wave` at that edge** (after any zero-delay combinational settling that happens in that same timestep, which is why you often add a tiny `#delay` before *reading* signals if you’re worried about races).
* In your checker, you compare after `#1` (right after the posedge) to let the DUT’s combinational logic settle:

  ```verilog
  always @(posedge clk) begin
      if (reset) begin
          last_level  <= s_wave;     // capture current s_wave on reset
          width_count <= 0;
      end else begin
          #1;                         // let s_wave settle
          if (s_wave == last_level) begin
              width_count <= width_count + 1;
          end else begin
              // ... check the previous run-length ...
              last_level  <= s_wave; // capture the new level for the next run
              width_count <= 1;
          end
      end
  end
  ```
* Practically: **`last_level` holds the previously observed level** of `s_wave` across clock cycles (until a transition is detected). When you detect a change, you update `last_level` to the **current** `s_wave` so that on the *next* cycles it represents the “old” level for the subsequent run-length.

## 2) What does `$timeformat(-9, 0, " ns", 10);` do?

`$timeformat` controls how `$time` (and times shown by `$monitor`, `$display`, etc. when using `%t`) are printed.

The arguments are:

1. **Unit power-of-ten**: `-9` → use **10^-9 s** units → **nanoseconds**.
2. **Precision (digits after decimal)**: `0` → show **0 decimal places**.
3. **Suffix string**: `" ns"` → append **space + “ns”** to the printed time.
4. **Minimum field width**: `10` → pad the time field to at least **10 characters**.

So after that call, `%t` prints like:

```
       25 ns
      100 ns
     1234 ns
```

(all in **ns**, no decimals, with a minimum width of 10 characters, and the “ ns” suffix).
