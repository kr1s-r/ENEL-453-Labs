module output_mode_fsm (
    input  logic clk,
    input  logic reset,
    input  logic [2:0] mode_select,  // 3-bit input for mode selection
    output logic triangle_enable,
    output logic sawtooth_enable,
    output logic r2r_enable,
    output logic buzzer_enable
);
    typedef enum logic [2:0] { // 3-bit enum
        OFF_MODE = 3'b000,
        TRI_MODE = 3'b001,
        SAW_MODE = 3'b010,
        R2R_MODE = 3'b011,
        BUZZER_MODE = 3'b100
    } statetype;

    statetype current_state, next_state;

    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= OFF_MODE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = statetype'(mode_select);  // Directly use mode_select as the next state
    end

    // Output logic
    always_comb begin
        triangle_enable = 0;
        sawtooth_enable = 0;
        r2r_enable = 0;
        buzzer_enable = 0;
        case (current_state)
            TRI_MODE:    triangle_enable = 1;
            SAW_MODE:    sawtooth_enable = 1;
            R2R_MODE:    r2r_enable = 1;
            BUZZER_MODE: buzzer_enable = 1;
            OFF_MODE:    ; // All outputs remain 0
            default:      ; // Handling undefined states
        endcase
    end
endmodule