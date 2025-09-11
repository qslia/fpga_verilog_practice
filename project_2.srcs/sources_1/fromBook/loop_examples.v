// Loop Examples in Verilog Behavioral Modeling
// Demonstrates various loop constructs as shown in Table 2.3

module loop_examples (
    input clk,
    input reset,
    input [7:0] count,
    output reg [15:0] sum,
    output reg clock_out
);

  // 1. FOREVER LOOP
  // Statements are executed continuously
  // Used for generating clock signals
  initial begin
    clock_out = 0;
    #5 forever #10 clock_out = ~clock_out;
  end

  // 2. REPEAT LOOP
  // Statements are executed repeatedly for a specified number of times
  // Example: Add 5 to sum 'count' number of times
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      sum = 0;
    end else begin
      sum = 0;  // Reset sum before repeat
      repeat (count) begin
        sum = sum + 5;
      end
    end
  end

  // Alternative repeat loop example
  reg [7:0] counter;
  always @(posedge clk) begin
    if (reset) begin
      counter = 0;
    end else begin
      counter = 0;
      repeat (8) begin
        counter = counter + 1;
      end
    end
  end

  // 3. WHILE LOOP
  // Statements are executed until a condition is satisfied
  // Example: Keep adding 5 until sum reaches a threshold
  reg [15:0] temp_sum;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      temp_sum = 0;
    end else begin
      temp_sum = 0;
      while (temp_sum < 100) begin
        temp_sum = temp_sum + 5;
      end
    end
  end

  // Another while loop example
  reg [3:0] bit_count;
  always @(posedge clk) begin
    if (reset) begin
      bit_count = 0;
    end else begin
      bit_count = 0;
      while (bit_count < 4) begin
        bit_count = bit_count + 1;
      end
    end
  end

  // 4. FOR LOOP
  // Statements are executed for a certain number of times
  // Example: Add 5 to sum 5 times
  integer k;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      sum = 0;
    end else begin
      sum = 0;
      for (k = 0; k < 5; k = k + 1) begin
        sum = sum + 5;
      end
    end
  end

  // More complex for loop example
  reg [7:0] array_sum;
  reg [7:0] data_array[0:7];
  integer i;
  always @(posedge clk) begin
    if (reset) begin
      array_sum = 0;
      // Initialize array
      for (i = 0; i < 8; i = i + 1) begin
        data_array[i] = i;
      end
    end else begin
      array_sum = 0;
      // Sum all elements in array
      for (i = 0; i < 8; i = i + 1) begin
        array_sum = array_sum + data_array[i];
      end
    end
  end

  // Nested loop example
  reg [15:0] matrix_sum;
  integer row, col;
  always @(posedge clk) begin
    if (reset) begin
      matrix_sum = 0;
    end else begin
      matrix_sum = 0;
      for (row = 0; row < 4; row = row + 1) begin
        for (col = 0; col < 4; col = col + 1) begin
          matrix_sum = matrix_sum + (row * 4 + col);
        end
      end
    end
  end

endmodule


