module lab_3_top_level (
    input  logic clk,
    input  logic reset,
    input logic [1:0] mux_select, // toggles between hex and decimal
    input logic reg_enable,
    input  logic [15:0] switches_inputs, // slide switches (0 towards Basys3 board edge, 1 towards board center)
    output logic CA, CB, CC, CD, CE, CF, CG, DP, // segment outputs (active-low)
    output logic AN1, AN2, AN3, AN4, // anode outputs for digit selection (active-low)
    output logic [15:0] led // mapped to the LEDs above the slide switches, LEDs: write a 1 to light LED, 0 to turn it off
);

    // Internal signal declarations
    logic in_DP, out_DP;
    logic [3:0] an_i;
    logic [3:0] digit_to_display;
    logic [15:0] bcd_value_current; // output of current value as BCD
    logic [15:0] bcd_value_stored;  // output of stored value as BCD
    logic [15:0] mux_out;   // output of multiplexer (after selecting)
    logic [15:0] switches_outputs; // output of switches
    logic [15:0] switches_reg;     // output of the register

    // Instantiate components     
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk),
        .reset(reset),
        .sec_dig1(mux_out[3:0]),    // feeds mux_output values instead
        .sec_dig2(mux_out[7:4]),    // mux_output depends on mux_select pushbutton
        .min_dig1(mux_out[11:8]),   // this figures out to display BCD to hex
        .min_dig2(mux_out[15:12]),  // NOTE: feeding 4-bit nibbles
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
    
    bin_to_bcd BIN_TO_BCD_CURRENT (
        .bin_in(switches_inputs),    // takes in binary input from switches
        .bcd_out(bcd_value_current), // outputs in current BCD using double-dabble algorithm (4 digits, 4 bits each)
        .clk(clk),
        .reset(reset)
    );
    
    bin_to_bcd BIN_TO_BCD_STORED (
        .bin_in(switches_reg),      // takes in binary input from register
        .bcd_out(bcd_value_stored), // outputs in stored BCD using double-dabble algorithm (4 digits, 4 bits each)
        .clk(clk),
        .reset(reset)
    );
    
    mux4 MUX4 (
        .a(switches_inputs),    // current hex
        .b(bcd_value_current),  // current bcd
        .c(switches_reg),       // stored hex
        .d(bcd_value_stored),   // stored bcd
        .s(mux_select),
        .y(mux_out)
    );
    
    register_16bit REGISTER (
        .clk(clk),
        .reset(reset),
        .enable(reg_enable),
        .d(switches_inputs),
        .q(switches_reg)
    );
      
    assign led = switches_outputs;
    
endmodule