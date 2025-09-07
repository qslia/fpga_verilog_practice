`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 13:45:00
// Design Name: 
// Module Name: complex_expr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A complex expression with sequential assignments
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module complex_expr(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    input [7:0] e,
    output reg [15:0] y
    );
    
    reg [8:0] y1;  // 9 bits to handle a+b overflow
    reg [15:0] y2; // 16 bits to handle c*d+e overflow
    
    // A complex expression described by multiple assignments,
    // which are executed sequentially
    always @(a or b or c or d or e) begin
        y1 = a + b;
        y2 = c * d + e;
        y = y1 * y2;
    end
    
endmodule
