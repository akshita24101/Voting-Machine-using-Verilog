module voting_machine (
    input logic clk,
    input logic reset,
    input logic vote_A,
    input logic vote_B,
    input logic vote_C,
    output logic led_A,
    output logic led_B,
    output logic led_C,
    output logic [3:0] count_A,
    output logic [3:0] count_B,
    output logic [3:0] count_C,
    output logic [1:0] winner // 2'b00 - tie, 01 - A, 10 - B, 11 - C
);

    logic [3:0] led_counter_A, led_counter_B, led_counter_C;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count_A <= 0;
            count_B <= 0;
            count_C <= 0;
            led_counter_A <= 0;
            led_counter_B <= 0;
            led_counter_C <= 0;
        end
        else begin
            // Prevent multiple votes simultaneously
            if ((vote_A + vote_B + vote_C) == 1) begin
                if (vote_A) begin
                    count_A <= count_A + 1;
                    led_counter_A <= 5; // LED blinks for 5 cycles
                end
                else if (vote_B) begin
                    count_B <= count_B + 1;
                    led_counter_B <= 5;
                end
                else if (vote_C) begin
                    count_C <= count_C + 1;
                    led_counter_C <= 5;
                end
            end

            // Countdown LED timers
            if (led_counter_A > 0) led_counter_A <= led_counter_A - 1;
            if (led_counter_B > 0) led_counter_B <= led_counter_B - 1;
            if (led_counter_C > 0) led_counter_C <= led_counter_C - 1;
        end
    end

    assign led_A = (led_counter_A > 0);
    assign led_B = (led_counter_B > 0);
    assign led_C = (led_counter_C > 0);

    always_comb begin
        if (count_A > count_B && count_A > count_C)
            winner = 2'b01;
        else if (count_B > count_A && count_B > count_C)
            winner = 2'b10;
        else if (count_C > count_A && count_C > count_B)
            winner = 2'b11;
        else
            winner = 2'b00; // tie
    end

endmodule
