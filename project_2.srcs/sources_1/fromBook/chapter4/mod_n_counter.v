module modN_counter #(
    parameter N = 10,
    WIDTH = 4
) (
    input clk,
    reset,
    output reg [WIDTH-1:0] out
);
  always @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end else begin
      if (out == N - 1) out <= 0;
      else out <= out + 1;
    end
  end
endmodule
