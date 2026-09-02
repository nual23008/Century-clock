module CLK_gen #(
    parameter [31:0] CLK_1s = 50_000_000,
    parameter [31:0] CLK_1p = 3_000_000_000
) (
    input wire clk,
    input wire rst_n,

    output reg tick_1s,
    output reg tick_1p
);
    reg [31:0] tick_1s_count;
    reg [31:0] tick_1p_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_1s <= 1'd0;
            tick_1p <= 1'd0;
            tick_1p_count <= 32'd0;
            tick_1s_count <= 32'd0;
        end
        else begin
            tick_1s <= 1'b0;
            tick_1p <= 1'b0;

            tick_1s_count <= tick_1s_count + 32'd1;
            tick_1p_count <= tick_1p_count + 32'd1;

            if (tick_1s_count == CLK_1s - 1'd1) begin
                tick_1s_count <= 32'd0;
                tick_1s <= 1'b1;
            end
            else begin
                tick_1s <= 1'b0;
            end

            if (tick_1p_count == CLK_1p - 1'd1) begin
                tick_1p_count <= 32'd0;
                tick_1p <= 1'b1;
            end
            else begin
                tick_1p <= 1'b0;
            end     
        end
    end
    
endmodule