`timescale 1ns / 1ps

module lab_1b_top_level_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter RESET_DURATION = 5 * CLK_PERIOD;
    parameter QUARTER_CYCLE = CLK_PERIOD / 4;
    
    // Time needed to view changes in waveform (due to persistence of vision)
    parameter LONGER_DELAY = 1050000 * CLK_PERIOD;

    // Signals
    logic clk;
    logic reset;
    logic [15:0] switches_inputs;
    logic CA, CB, CC, CD, CE, CF, CG, DP;
    logic AN1, AN2, AN3, AN4;
    logic [15:0] led;

    // Instantiate the Unit Under Test (UUT)
    lab_1b_top_level uut (
        .clk(clk),
        .reset(reset),
        .switches_inputs(switches_inputs),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .DP(DP),
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4),
        .led(led)
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
        // Initialize inputs
        reset = 0;
        switches_inputs = 16'h0000;
        
        // Wait for a quarter cycle before starting
        #QUARTER_CYCLE;
        
        // Apply reset
        reset = 1;
        #RESET_DURATION;
        reset = 0;
        #CLK_PERIOD;

        // Test case 1:
        switches_inputs = 16'h0000; 
        #CLK_PERIOD;
        #LONGER_DELAY;
        
        // Test case 2:
        switches_inputs = 16'hffff; 
        #CLK_PERIOD;
        #LONGER_DELAY;
        
        // Test case 3:
        switches_inputs = 16'h04D2; 
        #CLK_PERIOD;
        #LONGER_DELAY;
        
        // Test case 4:
        switches_inputs = 16'h0457; 
        #CLK_PERIOD;
        #LONGER_DELAY;

        // Test case 3:
        switches_inputs = 16'h15B3; 
        #CLK_PERIOD;
        #LONGER_DELAY;

//        // Test case 5:
//        switches_inputs = 16'b1010_1010_1010_1010; 
//        #CLK_PERIOD;
        
//        // Test case 6:
//        switches_inputs = 16'b1100_1100_1100_1100; #CLK_PERIOD;
        
//        // Test case 7:
//        switches_inputs = 16'b0011_0011_0011_0011; #CLK_PERIOD;
        
        // End simulation
        #(5 * CLK_PERIOD);
        $stop;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: switches_inputs = %b, led = %b", 
                 $time, switches_inputs, led);
    end

endmodule