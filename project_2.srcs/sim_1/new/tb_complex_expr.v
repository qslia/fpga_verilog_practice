`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 13:45:00
// Design Name: 
// Module Name: tb_complex_expr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for complex expression module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_complex_expr();
    
    // Testbench signals
    reg [7:0] a, b, c, d, e;
    wire [15:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    complex_expr uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .y(y)
    );
    
    // Test stimulus
    initial begin
        // Initialize inputs
        a = 0; b = 0; c = 0; d = 0; e = 0;
        #10;
        
        $display("Testing Complex Expression: y = (a+b) * (c*d+e)");
        $display("Time\ta\tb\tc\td\te\ty1(a+b)\ty2(c*d+e)\ty");
        $display("----\t--\t--\t--\t--\t--\t-------\t--------\t----");
        
        // Test case 1: Simple values
        a = 2; b = 3; c = 4; d = 5; e = 1; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        // Test case 2: Zeros
        a = 0; b = 0; c = 0; d = 0; e = 0; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        // Test case 3: One operand zero
        a = 5; b = 3; c = 0; d = 7; e = 2; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        // Test case 4: Larger values
        a = 10; b = 15; c = 6; d = 7; e = 8; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        // Test case 5: Maximum single digit values
        a = 9; b = 9; c = 9; d = 9; e = 9; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        // Test case 6: Edge case with e dominating
        a = 1; b = 1; c = 1; d = 1; e = 100; #10;
        $display("%0t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", $time, a, b, c, d, e, uut.y1, uut.y2, y);
        
        $display("\nTestbench completed successfully!");
        $display("Formula verification:");
        $display("y = (a+b) * (c*d+e)");
        $finish;
    end
    
endmodule
