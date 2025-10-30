// Decimal Point Controller
// Selects appropriate decimal point position based on display mode
module decimal_point_controller(
    input logic [1:0] bin_bcd_select,
    output logic [3:0] decimal_pt
);

    always_comb begin
        case(bin_bcd_select)
            2'b00: decimal_pt = 4'b0000;  // averaged ADC with extra 4 bits
            2'b01: decimal_pt = 4'b0010;  // averaged and scaled voltage
            2'b10: decimal_pt = 4'b0000;  // raw ADC (12-bits)
            2'b11: decimal_pt = 4'b0000;
            default: decimal_pt = 16'h0000;  // Default case: output all zeros
        endcase
    end    
    //assign decimal_pt = 4'b0010; // vector to control the decimal point, 1 = DP on, 0 = DP off
                               // [0001] DP right of seconds digit        
                               // [0010] DP right of tens of seconds digit
                               // [0100] DP right of minutes digit        
                               // [1000] DP right of tens of minutes digit
endmodule
