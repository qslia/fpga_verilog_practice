module melfsm (
    din,
    reset,
    clk,
    y
);
    input din;
    input clk;
    input reset;
    output reg y;
    reg [1:0] cst, nst;
    parameter S0 = 2'b00,  //all state
    S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    always @(cst or din) begin
        case (cst)
            S0:
            if (din == 1'b1) begin
                nst = S1;
                y   = 1'b0;
            end else begin
                nst = cst;
                y   = 1'b0;
            end
            S1:
            if (din == 1'b0) begin
                nst = S2;
                y   = 1'b0;
            end else begin
                y   = 1'b0;
                nst = cst;
            end
            S2:
            if (din == 1'b1) begin
                nst = S3;
                y   = 1'b0;
            end else begin
                nst = S0;
                y   = 1'b0;
            end
            S3:
            if (din == 1'b0) begin
                nst = S0;
                y   = 1'b1;
            end else begin
                nst = S1;
                y   = 1'b0;
            end
            default: nst = S0;
        endcase
    end
    always @(posedge clk) begin
        if (reset) cst <= S0;
        else cst <= nst;
    end
endmodule



