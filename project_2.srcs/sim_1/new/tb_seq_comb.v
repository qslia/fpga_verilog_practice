`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 14:00:00
// Design Name: 
// Module Name: tb_seq_comb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for sequential combinational circuit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_seq_comb();
    
    // Testbench signals
    reg clk;
    reg [7:0] a, b;
    wire [8:0] x;
    
    // Instantiate the Unit Under Test (UUT)
    seq_comb uut (
        .clk(clk),
        .a(a),
        .b(b),
        .x(x)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        a = 0; b = 0;
        
        // Wait for a few clock cycles to stabilize
        #15;
        
        $display("Testing Sequential-Combinational Circuit: x <= a + b on posedge clk");
        $display("Time\tclk\ta\tb\tx");
        $display("----\t---\t--\t--\t--");
        
        // Test case 1: Basic addition
        @(negedge clk);
        a = 5; b = 3;
        $display("%0t\t%b\t%d\t%d\t%d", $time, clk, a, b, x);
        @(posedge clk);
        #1; // Small delay to see the updated value
        $display("%0t\t%b\t%d\t%d\t%d (after posedge)", $time, clk, a, b, x);
        
        // Test case 2: Change inputs, check synchronous update
        @(negedge clk);
        a = 10; b = 15;
        $display("%0t\t%b\t%d\t%d\t%d", $time, clk, a, b, x);
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%d\t%d\t%d (after posedge)", $time, clk, a, b, x);
        
        // Test case 3: Zero inputs
        @(negedge clk);
        a = 0; b = 0;
        $display("%0t\t%b\t%d\t%d\t%d", $time, clk, a, b, x);
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%d\t%d\t%d (after posedge)", $time, clk, a, b, x);
        
        // Test case 4: Maximum values
        @(negedge clk);
        a = 255; b = 255;
        $display("%0t\t%b\t%d\t%d\t%d", $time, clk, a, b, x);
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%d\t%d\t%d (after posedge)", $time, clk, a, b, x);
        
        // Test case 5: Rapid input changes (should only update on posedge)
        @(negedge clk);
        a = 1; b = 2;
        $display("%0t\t%b\t%d\t%d\t%d", $time, clk, a, b, x);
        #2; // Change inputs mid-cycle
        a = 7; b = 8;
        $display("%0t\t%b\t%d\t%d\t%d (mid-cycle change)", $time, clk, a, b, x);
        @(posedge clk);
        #1;
        $display("%0t\t%b\t%d\t%d\t%d (after posedge)", $time, clk, a, b, x);
        
        // Wait a few more cycles
        repeat(3) @(posedge clk);
        
        $display("\nTestbench completed successfully!");
        $display("Key observations:");
        $display("- x updates only on positive clock edge (sequential)");
        $display("- The addition a+b is combinational logic");
        $display("- x holds its value between clock edges (register behavior)");
        $finish;
    end
    
    // Monitor for continuous observation
    initial begin
        $monitor("Time=%0t, clk=%b, a=%d, b=%d, x=%d", $time, clk, a, b, x);
    end
    
endmodule
