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
    wire sbar;
    // sbar is an intermediate net and thus it is called as wire.
    // A wire can be a single bit or can be a vector also
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
always @(posedge clk)
    q <= d;  // Use non-blocking assignment for sequential logic

// Wait statement example (procedural block)
always begin
    wait (en);  // Wait for enable signal
    q <= d;  // Use non-blocking assignment
    @(negedge en);  // Wait for enable to go low
end


module mux_bh (
    input  a,
    b,
    s,
    output y
);
    reg y;
    always @(s or a or b) begin
        if (s == 0) y = a;
        else y = b;
    end
endmodule


module mux_bh1 (
    input  a,
    b,
    s,
    output y
);
    reg y;
    always @(*) begin
        if (s == 0) y = a;
        else y = b;
    end
endmodule


module mux_case (
    input  a,
    b,
    s,
    output y
);
    reg y;
    always @(s or a or b) begin
        case (s)
            0: y = a;
            1: y = b;
        endcase
    end
endmodule


// Blocking Procedural Statement Example
initial begin
    x = #5 1'b1;  // Wait 5 time units, then assign 1 to x
    x = #6 1'b0;  // Wait 6 more time units, then assign 0 to x
    x = #7 1'b1;  // Wait 7 more time units, then assign 1 to x
end

// Non-Blocking Procedural Statement Example
initial begin
    x <= #5 1'b1;  // Schedule assignment of 1 to x after 5 time units
    x <= #6 1'b0;  // Schedule assignment of 0 to x after 6 time units
    x <= #7 1'b1;  // Schedule assignment of 1 to x after 7 time units
end


module mac (
    input clk,
    input [3:0] a,
    b,
    c,
    output reg [3:0] s
);
    reg [3:0] d;
    always @(posedge clk) begin
        d <= a + b;
        s <= c + d;
    end
endmodule


module mac (
    input clk,
    input [3:0] a,
    b,
    c,
    output reg [3:0] s
);
    reg [3:0] d;
    always @(posedge clk) begin
        d = a + b;
        s = c + d;
    end
endmodule


module mux_gl (
    input  a,
    b,
    s,
    output y
);
    wire q1, q2, sbar;
    not n1 (sbar, s);
    and a1 (q1, sbar, a);
    and a2 (q2, s, b);
    or o1 (y, q1, q2);
endmodule


module mux_4_1 (
    input a1,
    a2,
    a3,
    a4,
    input [1:0] s,
    output y
);
    wire t1, t2;
    mux_df m1 (
        a1,
        a2,
        s[0],
        t1
    );
    mux_df m2 (
        a3,
        a4,
        s[0],
        t2
    );
    mux_df m3 (
        t1,
        t2,
        s[1],
        y
    );
endmodule


module mux_4_1 (
    input a1,
    a2,
    a3,
    a4,
    input [1:0] s,
    output y
);
    wire t1, t2;
    mux_df m1 (
        .a(a1),
        .b(a2),
        .s(s[0]),
        .y(t1)
    );
    mux_df m2 (
        .a(a3),
        .b(a4),
        .s(s[0]),
        .y(t2)
    );
    mux_df m3 (
        .a(t1),
        .b(t2),
        .s(s[1]),
        .y(y)
    );
endmodule


module mux_4_1_mix (
    input a1,
    a2,
    a3,
    a4,
    input [1:0] s,
    output y
);
    reg y;
    wire t1, t2;
    mux_df m1 (
        a1,
        a2,
        s[0],
        t1
    );
    mux_gl m2 (
        a3,
        a4,
        s[0],
        t2
    );
    always @(s[1] or t1 or t2) begin
        if (s[1] == 0) y = t1;
        else y = t2;
    end
endmodule



