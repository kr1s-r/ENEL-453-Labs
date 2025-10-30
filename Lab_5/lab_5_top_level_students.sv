/*
This design uses the XADC from the IP Catalog. The specific channel is XADC4.
The Auxiliary Analog Inputs are VAUXP[15] and VAUXN[15].
These map to the FPGA pins of N2 and N1, respecitively (also in .XDC).
These map to the JXADC PMOD and the specific PMOD inputs are
JXADC4:N2 and JXAC10:N1, respectively. These pin are right beside the PMOD GND
on JXAC11:GND and JXAC5:GND.

The ADC is set to single-ended, continuous sampling, 1 MSps, 256 averaging. 
Additional averaging is done using the averager module below.
*/
module lab_5_top_level_students (
    input  logic   clk,
    input  logic   reset,
    input  logic [1:0] bin_bcd_select,
   // input  logic [15:0] switches_inputs,
    input          vauxp15, // Analog input (positive) - connect to JXAC4:N2 PMOD pin  (XADC4)
    input          vauxn15, // Analog input (negative) - connect to JXAC10:N1 PMOD pin (XADC4)
    output logic   CA, CB, CC, CD, CE, CF, CG, DP,
    output logic   AN1, AN2, AN3, AN4,
    output logic [15:0] led
);
    
    // Internal signal declarations
    
    // Tie analog inputs to high-impedance to prevent I/O buffer inference
    //assign vauxp5 = 1'bZ;
    //assign vauxn5 = 1'bZ;
        
    logic [15:0] data, ave_data;              // Raw ADC data
    logic [15:0] scaled_adc_data;
    logic [3:0]  decimal_pt; // vector to control the decimal point, 1 = DP on, 0 = DP off
                             // [0001] DP right of seconds digit        
                             // [0010] DP right of tens of seconds digit
                             // [0100] DP right of minutes digit        
                             // [1000] DP right of tens of minutes digit
    logic [15:0] bcd_value, mux_out;
    
    // Connect ADC data to LEDs
    assign led = scaled_adc_data;
    
    // ADC Subsystem
    adc_subsystem ADC_SUBSYSTEM (
        .clk(clk),
        .reset(reset),
        .raw_data(data),
        .ave_data(ave_data),
        .scaled_adc_data(scaled_adc_data)
    );
    
    bin_to_bcd BIN2BCD (
        .clk(    clk),
        .reset(  reset),
        .bin_in( scaled_adc_data),
        .bcd_out(bcd_value)
    );

    mux4_16_bits MUX4 (
        .in0(scaled_adc_data), // hexadecimal, scaled and averaged
        .in1(bcd_value),       // decimal, scaled and averaged
        .in2(data[15:4]),      // raw 12-bit ADC hexadecimal
        .in3(ave_data),        // averaged and before scaling 16-bit ADC (extra 4-bits from averaging) hexadecimal
        .select(bin_bcd_select),
        .mux_out(mux_out)
    );
    
    // Decimal Point Controller
    decimal_point_controller DEC_POINT_CTRL (
        .decimal_pt(decimal_pt),
        .bin_bcd_select(bin_bcd_select)
    );
  
    // Seven Segment Display Subsystem
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk), 
        .reset(reset), 
        .sec_dig1(mux_out[3:0]),     // Lowest digit
        .sec_dig2(mux_out[7:4]),     // Second digit
        .min_dig1(mux_out[11:8]),    // Third digit
        .min_dig2(mux_out[15:12]),   // Highest digit
        .decimal_point(decimal_pt),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), 
        .CE(CE), .CF(CF), .CG(CG), .DP(DP), 
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)
    );
    
endmodule
