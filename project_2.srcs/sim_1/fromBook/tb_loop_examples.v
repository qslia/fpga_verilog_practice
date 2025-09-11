// Testbench for loop examples
module tb_loop_examples;
  reg clk, reset;
  reg [7:0] count;
  wire [15:0] sum;
  wire clock_out;

  // Instantiate the module
  loop_examples dut (
      .clk(clk),
      .reset(reset),
      .count(count),
      .sum(sum),
      .clock_out(clock_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    reset = 1;
    count = 0;

    // Reset the design
    #20 reset = 0;

    // Test repeat loop with different count values
    count = 3;
    #50;

    count = 7;
    #50;

    // Test with count = 0
    count = 0;
    #50;

    // Test with maximum count
    count = 8'hFF;
    #50;

    // End simulation
    #100 $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%0t, Reset=%b, Count=%d, Sum=%d, Clock_out=%b", $time, reset, count, sum,
             clock_out);
  end

endmodule