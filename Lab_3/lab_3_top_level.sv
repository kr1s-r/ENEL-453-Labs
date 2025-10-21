module lab_3_top_level (
    input  logic clk,
    input  logic reset,
    input logic [1:0] mux_select, // toggles between hex and decimal (and stored versions)
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
    logic [15:0] bcd_value_current;   // output of current value as BCD
    logic [15:0] bcd_value_stored;    // output of stored value as BCD
    logic [15:0] mux_out;             // output of multiplexer (after selecting)
    logic [15:0] switches_outputs;    // output of switches
    logic [15:0] switches_reg;        // output of the register
    logic [15:0] sync_switches;       // synchronizes the switches
    logic [1:0] mux_select_debounced; // debounced for mux select buttons
    logic reg_enable_debounced;       // debounced for register enable button

    // Instantiate components
    synchronizer SWITCH_SYNCHRONIZER (
        .clk(clk),
        .reset(reset),
        .async_switches(switches_inputs),
        .sync_switches(sync_switches)
    );
    
    // Debouncer for Mux Select Bit 0 (top button)
    debounce DEBOUNCE_MUX_BIT0 (
        .clk(clk),
        .reset(reset),
        .button(mux_select[0]),
        .result(mux_select_debounced[0])
    );
    
    // Debouncer for Mux Select Bit 1 (right button)
    debounce DEBOUNCE_MUX_BIT1 (
        .clk(clk),
        .reset(reset),
        .button(mux_select[1]),
        .result(mux_select_debounced[1])
    );
    
    // Debouncer for Register Enable to store values (left button)
    debounce DEBOUNCE_REG_ENABLE (
        .clk(clk),
        .reset(reset),
        .button(reg_enable),
        .result(reg_enable_debounced)
    );
       
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
         .switches_inputs(sync_switches),
         .switches_outputs(switches_outputs)
    );
    
    bin_to_bcd BIN_TO_BCD_CURRENT (
        .bin_in(sync_switches),      // takes in binary input from switches
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
        .a(sync_switches),      // current hex
        .b(bcd_value_current),  // current bcd
        .c(switches_reg),       // stored hex
        .d(bcd_value_stored),   // stored bcd
        .s(mux_select_debounced),
        .y(mux_out)
    );
    
    register_16bit REGISTER (
        .clk(clk),
        .reset(reset),
        .enable(reg_enable_debounced),
        .d(sync_switches),
        .q(switches_reg)
    );
    
    assign led = switches_outputs;
    
endmodule