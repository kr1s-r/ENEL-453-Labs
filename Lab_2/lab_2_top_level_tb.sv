`timescale 1ns / 1ps

module lab_2_top_level_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter RESET_DURATION = 5 * CLK_PERIOD;
    parameter QUARTER_CYCLE = CLK_PERIOD / 4;
    
    // Time needed to view changes in waveform (due to persistence of vision)
    parameter LONGER_DELAY = 1050000 * CLK_PERIOD;
    
    // Time needed for BCD conversion (17 clock cycles)
    // assume 20 just to be safe
    parameter BCD_DELAY = 20 * CLK_PERIOD;

    // Signals
    logic clk;
    logic reset;
    logic mux_select;
    logic [15:0] switches_inputs;
    logic CA, CB, CC, CD, CE, CF, CG, DP;
    logic AN1, AN2, AN3, AN4;
    logic [15:0] led;

    // Instantiate the Unit Under Test (UUT)
    lab_2_top_level uut (
        .clk(clk),
        .reset(reset),
        .mux_select(mux_select),
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
        mux_select = 1'b0;
        switches_inputs = 16'h0000;
        #BCD_DELAY;
        #LONGER_DELAY;
        
        mux_select = 1'b1;
        #BCD_DELAY;
        #LONGER_DELAY;
        
        // Test case 2:
        mux_select = 1'b0;
        switches_inputs = 16'hffff; 
        #BCD_DELAY;
        #LONGER_DELAY;
        
        mux_select = 1'b1;
        #BCD_DELAY;
        #LONGER_DELAY;
        
        // Test case 3:
        mux_select = 1'b0;
        switches_inputs = 16'h04D2; 
        #BCD_DELAY;
        #LONGER_DELAY;

        mux_select = 1'b1;
        #BCD_DELAY;
        #LONGER_DELAY;
        
        // Test case 4:
        mux_select = 1'b0;
        switches_inputs = 16'h0457; 
        #BCD_DELAY;
        #LONGER_DELAY;
        
        mux_select = 1'b1;
        #BCD_DELAY;
        #LONGER_DELAY;

        // Test case 5:
        mux_select = 1'b0;
        switches_inputs = 16'h15B3; 
        #BCD_DELAY;
        #LONGER_DELAY;
        
        mux_select = 1'b1;
        #BCD_DELAY;
//        #LONGER_DELAY;
        
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