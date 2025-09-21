module mux_tb;
  // Inputs
  reg  a;
  reg  b;
  reg  s;
  // Outputs
  wire y;
  // Instantiate the Unit Under Test (UUT)
  mux_gl uut (
      .a(a),
      .b(b),
      .s(s),
      .y(y)
  );
  initial begin
    // Initialize Inputs
    a = 0;
    b = 0;
    s = 0;
    // Wait 100 ns for global reset to finish
    #100;
    a = 1;
    b = 0;
    s = 0;
    #20;
    a = 1;
    b = 0;
    s = 1;
    #20;
    a = 1;
    b = 1;
    s = 0;
    // Add stimulus here
  end
endmodule
