module tff (
    q,
    reset,
    clk,
    t
);
  output reg q, qb;
  input t, reset, clk;
  initial begin
    q = 1'b0;
  end
  
  always @(posedge clk)
    if (reset) q <= 1'b0;
    else if (t) q <= ~q;

endmodule
