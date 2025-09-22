module segment7 (
    BCD,
    SEG
);
  input [3:0] BCD;
  output reg [6:0] SEG;
  always @(BCD) begin
    case (BCD)
      0: SEG = 7'b1111110;
      1: SEG = 7'b0110000;
      2: SEG = 7'b1101101;
      3: SEG = 7'b1111001;
      4: SEG = 7'b0110011;
      5: SEG = 7'b1011011;
      6: SEG = 7'b1011111;
      7: SEG = 7'b1110000;
      8: SEG = 7'b1111111;
      9: SEG = 7'b1111011;
      default: SEG = 7'b0000000;
    endcase
  end
endmodule
