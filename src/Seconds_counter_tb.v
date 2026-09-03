`timescale 1ns/1ps

module Seconds_counter_tb;
    reg clk;
    reg rst_n;
    reg up;
    reg down;
    reg mode;
    reg set_second;

    wire [3:0] second_ones;
    wire [3:0] second_tens;
    wire tick_m_up;
    wire tick_m_down;

    integer errors;
    integer i;

    Seconds_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .up(up),
        .down(down),
        .mode(mode),
        .set_second(set_second),
        .second_ones(second_ones),
        .second_tens(second_tens),
        .tick_m_up(tick_m_up),
        .tick_m_down(tick_m_down)
    );

    always #5 clk = ~clk;

    task clock_cycle;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task expect_state;
        input [3:0] expected_tens;
        input [3:0] expected_ones;
        input expected_up;
        input expected_down;
        begin
            if (second_tens !== expected_tens ||
                second_ones !== expected_ones ||
                tick_m_up !== expected_up ||
                tick_m_down !== expected_down) begin
                $display("FAIL: expected %0d%0d up=%0b down=%0b, got %0d%0d up=%0b down=%0b",
                         expected_tens, expected_ones, expected_up, expected_down,
                         second_tens, second_ones, tick_m_up, tick_m_down);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        up = 1'b0;
        down = 1'b0;
        mode = 1'b0;
        set_second = 1'b0;
        errors = 0;

        #2;
        rst_n = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        // In normal mode, up is the combined tick_1s/button pulse.
        for (i = 0; i < 9; i = i + 1) begin
            up = 1'b1;
            clock_cycle;
            up = 1'b0;
            clock_cycle;
        end
        expect_state(4'd0, 4'd9, 1'b0, 1'b0);

        up = 1'b1;
        clock_cycle;
        expect_state(4'd1, 4'd0, 1'b0, 1'b0);
        up = 1'b0;
        clock_cycle;

        for (i = 10; i < 59; i = i + 1) begin
            up = 1'b1;
            clock_cycle;
            up = 1'b0;
            clock_cycle;
        end
        expect_state(4'd5, 4'd9, 1'b0, 1'b0);

        up = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b1, 1'b0);
        up = 1'b0;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        // Setting mode supports both directions only when seconds are selected.
        mode = 1'b1;
        up = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        set_second = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd1, 1'b0, 1'b0);
        up = 1'b0;
        down = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);
        clock_cycle;
        expect_state(4'd5, 4'd9, 1'b0, 1'b1);
        down = 1'b0;
        clock_cycle;
        expect_state(4'd5, 4'd9, 1'b0, 1'b0);

        if (errors == 0)
            $display("PASS: Seconds_counter boundary and mode tests");
        else
            $display("FAIL: %0d test(s) failed", errors);

        $finish;
    end
endmodule
