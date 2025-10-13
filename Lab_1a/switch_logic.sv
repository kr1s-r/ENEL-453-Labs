module switch_logic (
    input  logic [15:0] switches_inputs,
    output logic [15:0] switches_outputs 
);
    
    assign switches_outputs[15:8] = ~switches_inputs[15:8]; 
    assign switches_outputs[7:1]  = switches_inputs[7:1];
    assign switches_outputs[0]    = switches_inputs[1] & switches_inputs[0]; 

endmodule
