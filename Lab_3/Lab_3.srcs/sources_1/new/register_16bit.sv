// this register is essentially a flip-flop
module register_16bit(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [15:0] d,
    output logic [15:0] q
);
    
    // implementing register
    always_ff @(posedge clk)
        if (reset)
            q <= 16'b0; // on reset make all bits 0
        else if (enable)
            q <= d; // q copies d if reset=0, en=1, and on pos-edge of CLK
    
endmodule
