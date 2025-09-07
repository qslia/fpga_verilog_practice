`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 13:33:50
// Design Name: 
// Module Name: tb_or3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_or3(

    );
    
    // Testbench signals
    reg a, b, c;
    wire x;
    
    // Instantiate the Unit Under Test (UUT)
    or3 uut (
        .a(a),
        .b(b),
        .c(c),
        .x(x)
    );
    
    // Test stimulus
    initial begin
        // Initialize inputs
        a = 0; b = 0; c = 0;
        #10;
        
        // Test all possible combinations
        $display("Testing 3-input OR gate:");
        $display("Time\ta\tb\tc\tx");
        $display("----\t-\t-\t-\t-");
        
        a = 0; b = 0; c = 0; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 0; b = 0; c = 1; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 0; b = 1; c = 0; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 0; b = 1; c = 1; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 1; b = 0; c = 0; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 1; b = 0; c = 1; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 1; b = 1; c = 0; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        a = 1; b = 1; c = 1; #10; $display("%0t\t%b\t%b\t%b\t%b", $time, a, b, c, x);
        
        $display("Testbench completed successfully!");
        $finish;
    end
    
endmodule
