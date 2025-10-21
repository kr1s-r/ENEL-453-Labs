// Implementing a 4:1 mux
module mux4(
    input logic [15:0] a, b, c, d,
    input logic [1:0] s,
    output logic [15:0] y
);

    always_comb
        case(s)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
            default: y = a;
        endcase

    // code for 2:1 mux from before
    // assign y = s ? a : b; // if s = 1, then y = a, else y = b
    
endmodule
