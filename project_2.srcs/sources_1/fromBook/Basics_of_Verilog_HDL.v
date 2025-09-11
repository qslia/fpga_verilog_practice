// Wire declarations
wire [2:0] a;  // a 3-bit wire (a[2] a[1] a[0]).
wire b;  // a 1-bit wire
wire [3:0] y;  // a 4-bit wire (y[3] y[2] y[1] y[0]).
wire c, s;  // Additional wires used later
reg x, clk, q, d, en;  // Register declarations for sequential elements

assign {y[3], y[2:0]} = {a[2:0], b};
// {a[2:0], b} → this concatenates a (3 bits) with b (1 bit) Result = 4 bits: [a2 a1 a0 b]
// {y[3], y[2:0]} → this is just another way of writing all of y (4 bits). Equivalent to {y[3], y[2], y[1], y[0]}.
// So the assignment is: y = {a[2:0], b};
// y[3] = a[2]
// y[2] = a[1]
// y[1] = a[0]
// y[0] = b

assign y = {3{1'b1}};  // This is equivalent to 3'b111.


module mux_df (
    input  a,
    b,
    s,
    output y
);
  wire sbar; // sbar is an intermediate net and thus it is called as wire. A wire can be a single bit or can be a vector also
  assign y = (a & sbar) | (s & b);
  assign sbar = ~s;
endmodule

// Removed duplicate mux_df module

module mux_cs (
    input  a,
    b,
    s,
    output y
);
  // Removed duplicate wire s declaration - s is already an input
  assign y = (s == 0) ? a : b;
endmodule

// Fixed tri-state assignments - separated and corrected syntax
assign y = (s == 0) ? a : 1'bz;  // Fixed: separated statements and changed 'bz to 1'bz
assign y = (s == 1) ? c : 1'bz;  // Fixed: changed second condition to use 'c'

// Wire reset declaration with assignment
wire reset;
assign reset = 1'b0;


// Delay examples
wire #5 y_delayed;  // net delay (renamed to avoid conflict)
assign #3 y_delayed = a & b;  // assignment delay

// Initial block for register initialization
initial begin
  x   = 1'b0;
  clk = 1'b0;  // Initialize clock
  q   = 1'b0;
  d   = 1'b0;
  en  = 1'b0;
end

// Clock generation - method 1
always #5 clk = ~clk;

// Clock generation - method 2 (alternative)
// always begin
//   #5 clk = 0;
//   #5 clk = 1;
// end

// Sequential logic examples
always @(posedge clk) q <= d;  // Use non-blocking assignment for sequential logic

// Wait statement example (procedural block)
always begin
  wait (en);  // Wait for enable signal
  q <= d;  // Use non-blocking assignment
  @(negedge en);  // Wait for enable to go low
end




