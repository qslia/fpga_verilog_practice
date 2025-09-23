module dff (
    q,
    reset,
    clk,
    d
);
  output reg q;
  input reset, d, clk;
  initial begin
    q = 1'b0;
  end
  always @(posedge clk)
    if (reset) q <= 1'b0;
    else q <= d;
endmodule
