`timescale 1ns / 1ps

module tb_d_flip_flop();
    // Testbench signals
    reg d, reset, ce, clk;
    wire q, qb;
    
    // Instantiate the D flip-flop
    dff_struct uut (
        .q(q),
        .qb(qb),
        .d(d),
        .reset(reset),
        .ce(ce),
        .clk(clk)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        d = 0;
        reset = 1;
        ce = 0;
        
        // Display header
        $display("Time\tclk\treset\tce\td\tq\tqb");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b", $time, clk, reset, ce, d, q, qb);
        
        // Test reset functionality
        #15 reset = 0;
        
        // Test clock enable functionality
        #10 ce = 1; d = 1;  // Should set q=1, qb=0 on next posedge
        #10 d = 0;          // Should set q=0, qb=1 on next posedge
        #10 d = 1;          // Should set q=1, qb=0 on next posedge
        
        // Test clock enable disable
        #10 ce = 0; d = 0;  // Should maintain current state
        #20;                // Wait 2 clock cycles
        
        // Re-enable and change data
        #10 ce = 1; d = 0;  // Should set q=0, qb=1 on next posedge
        
        // Test reset while enabled
        #10 reset = 1;      // Should reset regardless of other inputs
        #10 reset = 0;
        
        // Final test
        #10 d = 1;          // Should set q=1, qb=0 on next posedge
        #20;
        
        $display("\nTestbench completed successfully!");
        $finish;
    end
    
endmodule
