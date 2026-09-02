module CLK_gen (
    parameter CLK_1s = 50_000_000,
    parameter CLK_1p = 3_000_000_000
) (
    input clk,

    output tick_1s,
    output tick_1p
);
    reg [31:0] tick_1s_temp;
    reg [31:0] tick_1p_temp;

    assign tick_1s_temp = 32'd0;
    assign tick_1p_temp = 32'd0;

    always @(posedge clk) begin
        tick_1s_temp <= tick_1s_temp + 32'd1;
        tick_1p_temp <= tick_1p_temp + 32'd1;

        if (tick_1s_temp) begin
            tick_1s <= 1'b1;
        end
        else if (tick_1p_temp) begin
            tick_1p <= 1'b1;
        end
        else begin
            tick_1s <= 1'b0;
            tick_1p <= 1'b0;
        end
    end
endmodule