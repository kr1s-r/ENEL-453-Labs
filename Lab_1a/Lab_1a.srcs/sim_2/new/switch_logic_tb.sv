`timescale 1ns / 1ps

module switch_logic_tb();
    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock

    // Internal Signals
    logic [15:0] switches_inputs;
    logic [15:0] switches_outputs;
    logic [15:0] expected_outputs;
    
    // Instantiate UUT (using explicit connections)
    switch_logic uut(
        .switches_inputs(switches_inputs),
        .switches_outputs(switches_outputs)
    );
    
    // Test stimulus
    initial begin
        // Tests all possible input combinations
        // 16-bits, therefore there are 2^16 combinations (65,536)
        for (int i = 0; i < 65536; i++) begin
            switches_inputs = i;
            #CLK_PERIOD; // delay
            
            // expected output
            expected_outputs[15:8] = ~switches_inputs[15:8]; 
            expected_outputs[7:1]  = switches_inputs[7:1];
            expected_outputs[0] = switches_inputs[1] & switches_inputs[0];
            
            // check output
            assert(switches_outputs === expected_outputs)
            else $error("Test failed at i=%0d", i);
        end
        
        $display("Tests completed");

        // End simulation
        #(5 * CLK_PERIOD);
        $stop;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time = %0t: switches_inputs = %b, switches_outputs = %b", 
                 $time, switches_inputs, switches_outputs);
    end
endmodule