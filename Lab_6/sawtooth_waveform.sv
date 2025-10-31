module sawtooth_waveform
    #(
        parameter int WIDTH = 8,                   // Bit width for duty_cycle
        parameter int CLOCK_FREQ = 100_000_000,    // System clock frequency in Hz
        parameter real WAVE_FREQ = 1.0             // Desired sawtooth wave frequency in Hz
    )
    (
        input  logic clk,      // System clock (100 MHz)
        input  logic reset,    // Active-high reset
        input  logic enable,   // Active-high enable
        output logic pwm_out,  // PWM output signal
        output logic [WIDTH-1:0] R2R_out // R2R ladder output
    );

    // Calculate maximum duty cycle value based on WIDTH
    localparam int MAX_DUTY_CYCLE = (2 ** WIDTH) - 1;  // 255 for WIDTH = 8
    // For sawtooth, only one ramp (0 → MAX), so total steps = MAX_DUTY_CYCLE
    localparam int TOTAL_STEPS = MAX_DUTY_CYCLE;       // 255 steps
    // Calculate downcounter PERIOD to achieve desired wave frequency
    localparam int DOWNCOUNTER_PERIOD = integer'(CLOCK_FREQ / (WAVE_FREQ * TOTAL_STEPS));

    // Ensure DOWNCOUNTER_PERIOD is positive
    initial begin
        if (DOWNCOUNTER_PERIOD <= 0) begin
            $error("DOWNCOUNTER_PERIOD must be positive. Adjust CLOCK_FREQ or WAVE_FREQ.");
        end
    end

    // Internal signals
    logic zero;                   // Output from downcounter (enables duty_cycle update)
    logic [WIDTH-1:0] duty_cycle; // Duty cycle value for PWM
    
    assign R2R_out = duty_cycle; // R2R ladder resistor circuit automatically generates the analog voltage

    // Instantiate downcounter module
    downcounter #(
        .PERIOD(DOWNCOUNTER_PERIOD)
    ) downcounter_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .zero(zero)
    );

    // Duty cycle up counter logic (sawtooth)
    always_ff @(posedge clk) begin
        if (reset) begin
            duty_cycle <= 0;
        end else if (enable) begin
            if (zero) begin
                if (duty_cycle == MAX_DUTY_CYCLE)
                    duty_cycle <= 0;            // Reset to zero when reaching max
                else
                    duty_cycle <= duty_cycle + 1; // Increment linearly
            end
        end else begin
            duty_cycle <= 0; // Optionally reset when disabled
        end
    end

    // Instantiate PWM module
    pwm #(
        .WIDTH(WIDTH)
    ) pwm_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );

endmodule
