// This is a moving averager
// Averaging helps to remove noise and gives a smoother and more stable signal
module averager
    #(parameter int
        power = 8, // 2**N samples, default is 2**8 = 256 samples
        N = 12)    // # of bits to take the average of
    (
        input logic clk,
        reset,
        EN,
        input logic [N-1:0] Din,   // input to averager
        output logic [N-1:0] Q     // N-bit moving average
    );

    logic [N-1:0] REG_ARRAY [2**power:1];
    logic [power+N-1:0] sum;
    assign Q = sum[power+N-1:power];

    always_ff @(posedge clk) begin
        if (reset) begin
            sum <= 0;
            // all registers are cleared to 0
            for (int j = 1; j <= 2**power; j++) begin
                REG_ARRAY[j] <= 0;
            end
        end
        else if (EN) begin
            // as new ADC values arrive they're added to the sum
            // new samples are added in while removing the oldest sample
            sum <= sum + Din - REG_ARRAY[2**power];
            for (int j = 2**power; j > 1; j--) begin
                REG_ARRAY[j] <= REG_ARRAY[j-1];
            end
            REG_ARRAY[1] <= Din; // new sample is at the start
        end
    end
endmodule
