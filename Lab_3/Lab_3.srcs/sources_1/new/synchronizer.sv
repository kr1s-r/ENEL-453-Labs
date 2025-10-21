// A 16-bit synchronizer to help avoid metastability
// can create a synchronizer with just one always_ff that generates two flip-flops
// but I wrote two always_ff so that the code is easier to read and understand
module synchronizer(
    input logic clk,
    input logic reset,
    input logic [15:0] async_switches, // asynchronous inputs
    output logic [15:0] sync_switches  // synchronous outputs
);
    // Internal Signals
    logic [15:0] sync1;
    logic [15:0] sync2;
    
    // First synchronization stage
    always_ff @(posedge clk)
        begin
            if (reset) sync1 <= 16'b0;
            else sync1 <= async_switches;
        end
    
    // Second synchronization stage 
    always_ff @(posedge clk)
        begin
            if (reset) sync2 <= 16'b0;
            else sync2 <= sync1;
        end

    assign sync_switches = sync2;

endmodule