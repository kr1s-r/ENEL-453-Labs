module lab_1b_top_level (
    input  logic clk,
    input  logic reset,
    input  logic [15:0] switches_inputs, // slide switches (0 towards Basys3 board edge, 1 towards board center)
    output logic CA, CB, CC, CD, CE, CF, CG, DP, // segment outputs (active-low)
    output logic AN1, AN2, AN3, AN4, // anode outputs for digit selection (active-low)
    output logic [15:0] led // mapped to the LEDs above the slide switches, LEDs: write a 1 to light LED, 0 to turn it off
);

    // Internal signal declarations
    logic in_DP, out_DP;
    logic [3:0] an_i;
    logic [3:0] digit_to_display;
    logic [15:0] bcd_value, mux_out, switches_outputs, switches_reg;

    // Instantiate components   
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk),
        .reset(reset),
        .sec_dig1(switches_inputs[3:0]),
        .sec_dig2(switches_inputs[7:4]),
        .min_dig1(switches_inputs[11:8]),
        .min_dig2(switches_inputs[15:12]),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP),
        .AN1(AN1),
        .AN2(AN2),
        .AN3(AN3),
        .AN4(AN4)
    );
    
    switch_logic SWITCHES (
         .switches_inputs( switches_inputs),
         .switches_outputs(switches_outputs)
    );
      
    assign led = switches_outputs;

endmodule
