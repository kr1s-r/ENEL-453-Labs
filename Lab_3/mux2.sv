// Implementing a 2:1 mux
module mux2(
    input logic [15:0] a, b,
    input logic s,
    output logic [15:0] y
);

    assign y = s ? a : b; // if s = 1, then y = a, else y = b

endmodule
