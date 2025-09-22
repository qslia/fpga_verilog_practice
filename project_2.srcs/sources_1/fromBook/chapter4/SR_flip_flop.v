module srff (
    S,
    R,
    clk,
    reset,
    q,
    qb
);
  output reg q, qb;
  input S, R, clk, reset;
  initial begin
    q  = 1'b0;
    qb = 1'b1;
  end
  always @(posedge clk)
    if (reset) begin
      q  <= 0;
      qb <= 1;
    end else begin
      if (S != R) begin
        q  <= S;
        qb <= R;
      end else if (S == 1 && R == 1) begin
        q  <= 1'bZ;
        qb <= 1'bZ;
      end
    end
endmodule
