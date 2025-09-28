# Width-Checking Always Block (tb_square_wave)

This block verifies that the DUT (`square_wave`) holds its output `s_wave` high and low for the expected number of clock cycles (`ON_TIME_CYC` and `OFF_TIME_CYC`). It runs on every rising edge of `clk` and counts how long the current logic level persists, flagging errors if a segment is too short or too long.

```verilog
always @(posedge clk) begin
    if (reset) begin
        last_level  <= s_wave;
        width_count <= 0;
    end else begin
        #1; // allow DUT combinational logic to settle
        if (s_wave == last_level) begin
            width_count <= width_count + 1;
        end else begin
            // Check the width of the previous level
            if (last_level === 1'b1) begin
                if (width_count != ON_TIME_CYC) begin
                    $display("ERROR at %t: high width %0d (expected %0d)", $time, width_count, ON_TIME_CYC);
                    error_count = error_count + 1;
                end
            end else begin
                if (width_count != OFF_TIME_CYC) begin
                    $display("ERROR at %t: low width %0d (expected %0d)", $time, width_count, OFF_TIME_CYC);
                    error_count = error_count + 1;
                end
            end
            // Reset counter for the new level and record
            last_level  <= s_wave;
            width_count <= 1; // current cycle counts as first of the new level
        end
    end
end
```

## What Each Part Does

- Clocked process: Triggers on `posedge clk`, so counting aligns with clock cycles.
- Reset branch: On reset, initialize the tracker:
  - `last_level <= s_wave` captures the current output level to avoid a spurious edge on release.
  - `width_count <= 0` resets the cycle counter.
- Settling delay `#1`: Waits a short time (1 time unit) after the clock edge so any combinational logic in the DUT finishes before sampling `s_wave`. With a 10 ns clock in the TB, `#1` is small but effective to avoid race conditions.
- Same level path: If `s_wave` hasn’t changed (`s_wave == last_level`), increment `width_count` to accumulate cycles for this level.
- Edge detected path: If `s_wave` changed level:
  - Validate the width of the previous segment:
    - If the previous level was high (`last_level === 1'b1`), compare `width_count` with `ON_TIME_CYC`.
    - Otherwise compare with `OFF_TIME_CYC`.
  - On mismatch, print an error and increment `error_count`.
  - Start tracking the new level by setting `last_level <= s_wave` and `width_count <= 1` (the current cycle is the first cycle of the new level).

## Key Signals and Variables

- `s_wave`: DUT output under test.
- `last_level`: The level (`0` or `1`) during the just-completed segment.
- `width_count`: Number of clock cycles the current level has lasted so far.
- `error_count`: Accumulates detected width mismatches.

## Why `width_count` starts at 1 after a transition

When an edge is detected, the counter for the new level includes the current clock tick as the first cycle of that level, hence `width_count <= 1`.

## Notes on assignments

- Non-blocking (`<=`) is used for `last_level` and `width_count` to model sequential registers cleanly.
- `error_count` uses a simple blocking update (`=`) since it is only used for reporting and has no feedback into the current cycle’s control path.

## Relation to DUT parameters

The testbench instantiation sets `ON_TIME_CYC` and `OFF_TIME_CYC` to match the DUT parameters `on_time` and `off_time`. This block ensures the generated waveform respects those durations exactly.

