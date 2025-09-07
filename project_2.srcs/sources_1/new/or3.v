`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 13:33:28
// Design Name: 
// Module Name: or3
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


module or3(
    input a,
    input b,
    input c,
    output reg x
    );
    
    always @(a or b or c)
        x = a | b | c;
        
endmodule
