`timescale 1ns/1ps

module Minutes_counter_tb;
    reg clk;
    reg rst_n;
    reg tick_m_up;
    reg tick_m_down;
    reg mode;
    reg set_minute;

    wire [3:0] minute_ones;
    wire [3:0] minute_tens;
    wire tick_h_up;
    wire tick_h_down;

    integer errors;
    integer i;

    Minutes_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_m_up(tick_m_up),
        .tick_m_down(tick_m_down),
        .mode(mode),
        .set_minute(set_minute),
        .minute_ones(minute_ones),
        .minute_tens(minute_tens),
        .tick_h_up(tick_h_up),
        .tick_h_down(tick_h_down)
    );

    always #5 clk = ~clk;

    task clock_cycle;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task pulse_up;
        begin
            tick_m_up = 1'b1;
            clock_cycle;
            tick_m_up = 1'b0;
            clock_cycle;
        end
    endtask

    task expect_state;
        input [3:0] expected_tens;
        input [3:0] expected_ones;
        input expected_up;
        input expected_down;
        begin
            if (minute_tens !== expected_tens ||
                minute_ones !== expected_ones ||
                tick_h_up !== expected_up ||
                tick_h_down !== expected_down) begin
                $display("FAIL: expected %0d%0d up=%0b down=%0b, got %0d%0d up=%0b down=%0b",
                         expected_tens, expected_ones, expected_up, expected_down,
                         minute_tens, minute_ones, tick_h_up, tick_h_down);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        tick_m_up = 1'b0;
        tick_m_down = 1'b0;
        mode = 1'b0;
        set_minute = 1'b0;
        errors = 0;

        #2;
        rst_n = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        // Normal mode counts only upward minute ticks.
        tick_m_down = 1'b1;
        clock_cycle;
        tick_m_down = 1'b0;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        for (i = 0; i < 9; i = i + 1)
            pulse_up;
        expect_state(4'd0, 4'd9, 1'b0, 1'b0);

        tick_m_up = 1'b1;
        clock_cycle;
        expect_state(4'd1, 4'd0, 1'b0, 1'b0);
        tick_m_up = 1'b0;
        clock_cycle;

        for (i = 10; i < 59; i = i + 1)
            pulse_up;
        expect_state(4'd5, 4'd9, 1'b0, 1'b0);

        tick_m_up = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b1, 1'b0);
        tick_m_up = 1'b0;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        // Setting mode changes minutes only while set_minute is selected.
        mode = 1'b1;
        tick_m_up = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);

        set_minute = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd1, 1'b0, 1'b0);

        tick_m_up = 1'b0;
        tick_m_down = 1'b1;
        clock_cycle;
        expect_state(4'd0, 4'd0, 1'b0, 1'b0);
        clock_cycle;
        expect_state(4'd5, 4'd9, 1'b0, 1'b1);

        tick_m_down = 1'b0;
        clock_cycle;
        expect_state(4'd5, 4'd9, 1'b0, 1'b0);

        if (errors == 0)
            $display("PASS: Minutes_counter boundary and mode tests");
        else
            $display("FAIL: %0d test(s) failed", errors);

        $finish;
    end
endmodule
