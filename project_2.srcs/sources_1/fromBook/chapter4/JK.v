module jk (
    q,
    qb,
    j,
    k,
    reset,
    clk
);
  output reg q, qb;
  input j, k, clk, reset;
  initial begin
    q  = 1'b0;
    qb = 1'b1;
  end
  always @(posedge clk)
    if (reset) begin
      q  = 1'b0;
      qb = 1'b1;
    end else
      case ({
        j, k
      })
        {
          1'b0, 1'b0
        } : begin
          q  = q;
          qb = qb;
        end
        {
          1'b0, 1'b1
        } : begin
          q  = 1'b0;
          qb = 1'b1;
        end
        {
          1'b1, 1'b0
        } : begin
          q  = 1'b1;
          qb = 1'b0;
        end
        {
          1'b1, 1'b1
        } : begin
          q  = ~q;
          qb = ~qb;
        end
      endcase
endmodule
