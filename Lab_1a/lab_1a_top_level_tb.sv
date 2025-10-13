`timescale 1ns / 1ps

module lab_1a_top_level_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock

    // Signals
    logic [15:0] switches_inputs;
    logic [15:0] led;

    // Instantiate the Unit Under Test (UUT)
    lab_1a_top_level uut (
        .switches_inputs(switches_inputs),
        .led(led)
    );

    // Test stimulus
    initial begin
        // Initialize inputs

        // Test case 1:
        switches_inputs = 16'b0000_0000_0000_0000; #CLK_PERIOD;
        
        // Test case 2:
        switches_inputs = 16'b1111_1111_1111_1111; #CLK_PERIOD;

        // Test case 3:
        switches_inputs = 16'b0101_0101_0101_0101; #CLK_PERIOD;

        // Test case 4:
        switches_inputs = 16'b1010_1010_1010_1010; #CLK_PERIOD;
        
        // Test case 5:
        switches_inputs = 16'b1100_1100_1100_1100; #CLK_PERIOD;
        
        // Test case 6:
        switches_inputs = 16'b0011_0011_0011_0011; #CLK_PERIOD;
        
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