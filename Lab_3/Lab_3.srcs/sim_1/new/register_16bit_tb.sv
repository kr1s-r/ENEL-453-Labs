`timescale 1ns / 1ps

// Testbench for the register
// CLK generation is needed since we are using sequential logic
module register_16bit_tb();
    
    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter RESET_DURATION = 5 * CLK_PERIOD;
    
    // Internal Signals
    logic clk, reset, enable;
    logic [15:0] d;
    logic [15:0] q;
    
    // Instantiate the Unit Under Test (UUT)
    register_16bit uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .d(d),
        .q(q)
    );
    
    // Clock generation
    always begin
        clk = 0;
        #(CLK_PERIOD/2); // delay of CLK_PERIOD/2 = 5 ns
        clk = 1;
        #(CLK_PERIOD/2);
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        reset = 0;
        enable = 0;
        d=16'h0000;
        
        // Apply reset condition
        reset = 1;
        #RESET_DURATION;
        reset = 0;
        #CLK_PERIOD;
        
        // Test Case 1:
        d = 16'hFFFF;
        enable = 1; // button pressed
        #CLK_PERIOD;
        enable = 0; // button not pressed
        #CLK_PERIOD;
        
        // Test Case 2:
        d = 16'hAAAA;
        enable = 1; // button pressed
        #CLK_PERIOD; 
        enable = 0; // button not pressed
        #CLK_PERIOD;
        
        // Test Case 3:
        d = 16'h1234;
        enable = 1; // button  pressed
        #CLK_PERIOD;
        enable = 0; // button not pressed
        #CLK_PERIOD;
        
        // Test Case 4:
        d = 16'h55a3;
        enable = 1; // button  pressed
        #CLK_PERIOD;
        enable = 0; // button not pressed
        #CLK_PERIOD;
        
        // Test Case 5:
        d = 16'hcccc;
        enable = 1; // button  pressed
        #CLK_PERIOD;
        enable = 0; // button not pressed
        #CLK_PERIOD;
        
        // End simulation
        #(5 * CLK_PERIOD);
        $stop;
    end
endmodule
