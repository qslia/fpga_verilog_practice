module ram_corrected (
    input clk,
    input en,
    input we,
    input [2:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] mem[0:7];

    // Initialize memory array
    initial begin
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            mem[i] = 8'h00;
        end
        data_out = 8'h00;
    end

    // Synchronous read/write operation
    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                mem[address] <= data_in;  // Write operation
            end
            data_out <= mem[address];  // Read operation (always)
        end
    end
endmodule
