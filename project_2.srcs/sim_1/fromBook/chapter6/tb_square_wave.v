`timescale 1ns/1ps

module tb_square_wave;
    // Clock and reset
    reg clk = 1'b0;
    reg reset = 1'b1;

    // DUT outputs
    wire s_wave;

    // Parameters to mirror the DUT configuration
    localparam integer N_PARAM      = 4;
    localparam integer ON_TIME_CYC  = 5; // cycles s_wave stays high
    localparam integer OFF_TIME_CYC = 3; // cycles s_wave stays low

    // Instantiate the Device Under Test (DUT)
    square_wave #(
        .N(N_PARAM),
        .on_time(ON_TIME_CYC),
        .off_time(OFF_TIME_CYC)
    ) dut (
        .clk   (clk),
        .reset (reset),
        .s_wave(s_wave)
    );

    // 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        reset = 1'b1;
        #20;           // hold reset for two clock cycles
        reset = 1'b0;
    end

    // Basic visibility in the console
    initial begin
        $timeformat(-9, 0, " ns", 10);
        $display("Time        clk reset s_wave");
        $monitor("%t  %b    %b     %b", $time, clk, reset, s_wave);
    end

    // Simple self-check: verify on/off widths in clock cycles
    integer width_count = 0;
    integer error_count = 0;
    reg last_level;

    initial begin
        last_level  = 1'b0;
        width_count = 0;
    end

    // Sample slightly after the posedge so combinational outputs settle
    always @(posedge clk) begin
        if (reset) begin
            last_level  <= s_wave;
            width_count <= 0;
        end else begin
            #1; // allow DUT combinational logic to settle
            if (s_wave == last_level) begin
                width_count <= width_count + 1;
            end else begin
                // Check the width of the previous level
                if (last_level === 1'b1) begin
                    if (width_count != ON_TIME_CYC) begin
                        $display("ERROR at %t: high width %0d (expected %0d)", $time, width_count, ON_TIME_CYC);
                        error_count = error_count + 1;
                    end
                end else begin
                    if (width_count != OFF_TIME_CYC) begin
                        $display("ERROR at %t: low width %0d (expected %0d)", $time, width_count, OFF_TIME_CYC);
                        error_count = error_count + 1;
                    end
                end
                // Reset counter for the new level and record
                last_level  <= s_wave;
                width_count <= 1; // current cycle counts as first of the new level
            end
        end
    end

    // Stop the simulation after a while
    initial begin
        // Run long enough to observe several on/off periods
        #500;
        $display("\nSimulation finished at %t with %0d error(s).", $time, error_count);
        $finish;
    end

endmodule

