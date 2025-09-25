module rom_corrected (
    input clk,
    input en,
    input [2:0] address,
    output reg [7:0] data_out
);
    reg [7:0] mem[0:7];

    // Proper ROM initialization
    initial begin
        mem[0] = 8'b00000001;  // 1
        mem[1] = 8'b00000010;  // 2
        mem[2] = 8'b00000011;  // 3
        mem[3] = 8'b00000100;  // 4
        mem[4] = 8'b00000101;  // 5
        mem[5] = 8'b00000110;  // 6
        mem[6] = 8'b00000111;  // 7
        mem[7] = 8'b00001000;  // 8
    end

    // Synchronous read
    always @(posedge clk) begin
        if (en) begin
            data_out <= mem[address];
        end
        // Remove unnecessary else clause - registers hold value by default
    end
endmodule
