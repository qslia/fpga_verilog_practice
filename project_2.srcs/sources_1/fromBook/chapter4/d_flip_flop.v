module dff_struct(q, qb, d, reset, ce, clk);
    output reg q, qb;
    input d, reset, ce, clk;
    
    // Initialize outputs
    initial begin
        q = 1'b0;
        qb = 1'b1;
    end
    
    // D flip-flop with clock enable and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;
            qb <= 1'b1;
        end else if (ce) begin
            q <= d;
            qb <= ~d;
        end
        // If ce is low, maintain current state (no change)
    end
endmodule