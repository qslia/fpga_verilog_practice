module square_wave #(
    parameter N = 4,
    on_time = 3'd5,
    off_time = 3'd3
) (
    input  wire clk,
    reset,
    output reg  s_wave
);
    localparam S0 = 0, S1 = 1;
    reg PS, NS;
    reg [N-1:0] t = 0;
    always @(posedge clk) begin
        if (reset == 1'b1) PS <= S0;
        else PS <= NS;
    end
    always @(posedge clk) begin
        if (PS != NS) t <= 0;
        else t <= t + 1;
    end
    always @(PS, t) begin
        case (PS)
            S0: begin
                s_wave = 1'b0;
                if (t == off_time - 1) NS = S1;
                else NS = S0;
            end
            S1: begin
                s_wave = 1'b1;
                if (t == on_time - 1) NS = S0;
                else NS = S1;
            end
        endcase
    end
endmodule
