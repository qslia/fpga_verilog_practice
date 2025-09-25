module counter_ddr (
    out,
    clk,
    en,
    reset
);
  output reg [2:0] out;
  input clk, en, reset;
  initial begin
    out = 3'b000;
  end
  always @(posedge clk or negedge clk)
    if (reset) begin
      out <= 3'b000;
    end else if (en) out <= out + 3'b0001;
    else out <= out;
endmodule
