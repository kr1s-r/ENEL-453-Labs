`timescale 1ns / 1ps

// Testbench for the 2:1 mux
// CLK generation is not needed since this is purely combinational logic
module mux4_tb();

    // Parameters
    parameter DELAY = 10; // 10ns for 100MHz clock
    
    // Internal signals
    logic [15:0] a, b;
    logic s;
    logic [15:0] y;
    
    mux4 uut(
        .a(a),
        .b(b),
        .s(s),
        .y(y) 
    );
    
    initial begin
        // Test case 1:
        s = 1'b0;
        a = 16'h0000;
        b = 16'hffff;
        #DELAY;
        
        s = 1'b1;
        #DELAY;
        
        // Test case 2:
        s = 1'b1;
        a = 16'hcde3;
        b = 16'ha32f;
        #DELAY;
        
        s = 1'b0;
        #DELAY;
        
        // Test case 3:
        s = 1'b0;
        a = 16'ha5a5;
        b = 16'h5a5a;
        #DELAY;
        
        s = 1'b1;
        #DELAY;
        
        // Test case 3:
        s = 1'b1;
        a = 16'h5a5a;
        b = 16'hcccc;
        #DELAY;
        
        s = 1'b0;
        #DELAY;
        
        // End simulation
        $stop;
    end
endmodule
