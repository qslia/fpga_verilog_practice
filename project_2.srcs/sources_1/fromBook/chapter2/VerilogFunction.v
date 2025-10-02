module function_test (
    input [3:0] a1,
    a2,
    a3,
    a4,
    output reg [3:0] c
);
    reg [3:0] b1, b2;

    function [3:0] sum(input [3:0] a, b);
        begin
            sum = a + b;
        end
    endfunction

    always @* begin
        b1 = sum(a1, a2);
        b2 = sum(a3, a4);
        c  = sum(b1, b2);
    end
endmodule


module task_test (
    input [3:0] a1,
    a2,
    a3,
    a4,
    output reg [3:0] c
);
    reg [3:0] b1, b2;

    task sum(input [3:0] a, b, output [3:0] s);
        begin
            s = a + b;
        end
    endtask

    always @* begin
        sum(a1, a2, b1);
        sum(a3, a4, b2);
        sum(b1, b2, c);
    end
endmodule


module mem_read (
    C1,
    ada,
    clk
);
    input [9:0] ada;
    input clk;
    integer of0;
    output reg [17:0] C1;
    reg [17:0] A1;
    reg [17:0] b1[1023:0];
    integer j;
    initial begin
        of0 = $fopen("input_vector.txt", "r");
        for (j = 0; j <= 1023; j = j + 1) begin
            $fscanf(of0, "%d\n", A1);
            #1;
            b1[j] = A1;
        end
        $fclose(of0);
    end
    always @(posedge clk) begin
        C1 = b1[ada];
    end
endmodule


module mem_write (
    A,
    en,
    clk
);
    integer of0;
    input [17:0] A;
    input en, clk;
    integer j;
    initial begin
        j = 0;
    end
    always @(posedge clk) begin
        if (en) begin
            of0 = $fopen("output_vector.txt", "w");
            for (j = 0; j <= 4; j = j + 1) begin
                $fdisplay(of0, "%d\n", A);
                #10;
            end
        end else $fclose(of0);
    end
endmodule

module muxM (
    A,
    B,
    S,
    Y
);
    parameter M = 4;
    input [M:0] A, B;
    output [M:0] Y;
    input S;
    assign Y = (S) ? B : A;
endmodule

module Mux4_1 (
    A,
    B,
    S,
    Y
);
    parameter M1 = 7;
    input [M1:0] A, B;
    input S;
    output [M1:0] Y;
    wire [M1:0] Y1, Y2;
    defparam mux1.M = M1, mux2.M = M1, mux3.M = M1;
    muxM mux1 (
        A,
        B,
        S,
        Y1
    );
    muxM mux2 (
        A,
        B,
        S,
        Y2
    );
    muxM mux3 (
        Y1,
        Y2,
        S,
        Y
    );
endmodule

module DFF (  // D flip-flop
    q,
    clk,
    reset,
    d
);
    input d, clk, reset;
    output reg q;
    initial begin
        q = 0;
    end
    always @(posedge clk, posedge reset) begin
        if (reset) q <= 0;
        else q <= d;
    end
endmodule


module LUT (
    input [1:0] s,
    output reg y
);
    always @(s)
        case (s)
            2'b00: y = 0;
            2'b01: y = 1;
            2'b10: y = 1;
        endcase
endmodule

module LUT (
    input [1:0] s,
    output reg y
);
    always @(s) begin
        if (s == 2'b00) y = 0;
        else if (s == 2'b01) y = 1;
        else if (s == 2'b10) y = 1;
    end
endmodule

module encoder (
    input [2:0] s,
    output reg y2,
    y1,
    y0
);
    always @(s)
        casex (s)
            3'b1??:  y2 = 1'b1;
            3'b01?:  y1 = 1'b1;
            3'b001:  y0 = 1'b1;
            default: {y2, y1, y0} = 3'b000;
        endcase
endmodule



module mux_cs (
    input  a,
    b,
    s,
    output y
);
    assign y = (s == 0) ? a : b;
endmodule

module Mux2_1_4bit (
    a,
    b,
    s,
    y
);
    input [3:0] a, b;
    input s;
    output [3:0] y;
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : Mux2_block
            mux_cs m1 (
                a[i],
                b[i],
                s,
                y[i]
            );
        end
    endgenerate
endmodule


// Manual instantiation (less preferred for larger widths)
module Mux2_1_4bit_manual (
    input [3:0] a,
    b,
    input s,
    output [3:0] y
);
    mux_cs m0 (
        a[0],
        b[0],
        s,
        y[0]
    );
    mux_cs m1 (
        a[1],
        b[1],
        s,
        y[1]
    );
    mux_cs m2 (
        a[2],
        b[2],
        s,
        y[2]
    );
    mux_cs m3 (
        a[3],
        b[3],
        s,
        y[3]
    );
endmodule


// Example of fork-join block (should be inside a module and initial/always block)
module fork_join_example;
    reg x;

    initial begin
        fork
            begin
                x = #5 1'b1;
                x = #6 1'b0;
                x = #7 1'b1;
            end
        join
    end
endmodule



module alu (
    input  [7:0] A,
    B,  // ALU 8-bit Inputs
    input  [3:0] ALU_Sel,  // ALU Selection
    output [7:0] ALU_Out,  // ALU 8-bit Output
    output       CarryOut  // Carry Out Flag
);
    reg  [7:0] ALU_Result;
    wire [8:0] tmp;
    assign ALU_Out = ALU_Result;  // ALU out
    assign tmp = {1'b0, A} + {1'b0, B};
    assign CarryOut = tmp[8];  // Carryout flag
    always @(*) begin
        case (ALU_Sel)
            4'b0000:  // Addition
            ALU_Result = A + B;
            4'b0001:  // Subtraction
            ALU_Result = A - B;
            4'b0010:  // Multiplication
            ALU_Result = A * B;
            4'b0011:  // Division
            ALU_Result = A / B;
            4'b0100:  // Logical shift left
            ALU_Result = A << 1;
            4'b0101:  // Logical shift right
            ALU_Result = A >> 1;
            4'b0110:  // Rotate left
            ALU_Result = {A[6:0], A[7]};
            4'b0111:  // Rotate right
            ALU_Result = {A[0], A[7:1]};
            4'b1000:  // Logical and
            ALU_Result = A & B;
            4'b1001:  // Logical or
            ALU_Result = A | B;
            4'b1010:  // Logical xor
            ALU_Result = A ^ B;
            4'b1011:  // Logical nor
            ALU_Result = ~(A | B);
            4'b1100:  // Logical nand
            ALU_Result = ~(A & B);
            4'b1101:  // Logical xnor
            ALU_Result = ~(A ^ B);
            4'b1110:  // Greater comparison
            ALU_Result = (A > B) ? 8'd1 : 8'd0;
            4'b1111:  // Equal comparison
            ALU_Result = (A == B) ? 8'd1 : 8'd0;
            default: ALU_Result = A + B;
        endcase
    end
endmodule
