module comp18 (
    A1,
    B1,
    LT1,
    GT1,
    EQ1
);
  input [17:0] A1, B1;
  output reg LT1, GT1, EQ1;
  always @(A1, B1) begin
    if (A1 > B1) begin
      LT1 <= 0;
      GT1 <= 1;
      EQ1 <= 0;
    end else if (A1 < B1) begin
      LT1 <= 1;
      GT1 <= 0;
      EQ1 <= 0;
    end else begin
      LT1 <= 0;
      GT1 <= 0;
      EQ1 <= 1;
    end
  end
endmodule
