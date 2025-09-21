`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/07 14:00:00
// Design Name: 
// Module Name: seq_comb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A simple circuit with sequential and combinational logic
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seq_comb(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg [8:0] x
    );
    
    // A simple circuit describing both sequential
    // (register x) and combinational (+) logics concurrently
    always @(posedge clk)
        x <= a + b;
    
endmodule
