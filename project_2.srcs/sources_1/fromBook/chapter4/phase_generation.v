module pg (
    start,
    stop,
    phase,
    clk,
    reset
);
  input start, stop, reset, clk;
  output reg phase;
  initial begin
    phase <= 0;
  end
  always @(posedge clk)
    if (reset) phase <= 1'b0;
    else if (start) phase <= 1'b1;
    else if (stop) phase <= 1'b0;
endmodule
