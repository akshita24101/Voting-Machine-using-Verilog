`timescale 1ns/1ps

module testbench;

    logic clk, reset;
    logic vote_A, vote_B, vote_C;
    logic led_A, led_B, led_C;
    logic [3:0] count_A, count_B, count_C;
    logic [1:0] winner;

    voting_machine vm (
        .clk(clk), .reset(reset),
        .vote_A(vote_A), .vote_B(vote_B), .vote_C(vote_C),
        .led_A(led_A), .led_B(led_B), .led_C(led_C),
        .count_A(count_A), .count_B(count_B), .count_C(count_C),
        .winner(winner)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        // Init
        clk = 0;
        reset = 1;
        vote_A = 0; vote_B = 0; vote_C = 0;
        #20 reset = 0;

        // Valid votes
        vote_A = 1; #20; vote_A = 0; #20;
        vote_B = 1; #20; vote_B = 0; #20;
        vote_C = 1; #20; vote_C = 0; #20;

        // Multiple button pressed - should be ignored
        vote_A = 1; vote_B = 1; #20; vote_A = 0; vote_B = 0; #20;

        // More valid votes
        vote_A = 1; #20; vote_A = 0; #20;
        vote_A = 1; #20; vote_A = 0; #20;

        // Reset mid-way
        reset = 1; #10; reset = 0; #20;

        // Vote again post reset
        vote_B = 1; #20; vote_B = 0; #20;
        vote_C = 1; #20; vote_C = 0; #20;
        vote_C = 1; #20; vote_C = 0; #20;

        // Finish
        $display("\n---- FINAL VOTE COUNTS ----");
        $display("Votes for A: %0d", count_A);
        $display("Votes for B: %0d", count_B);
        $display("Votes for C: %0d", count_C);

        case (winner)
            2'b01: $display("Winner: A");
            2'b10: $display("Winner: B");
            2'b11: $display("Winner: C");
            default: $display("Result: Tie");
        endcase

        #10 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
