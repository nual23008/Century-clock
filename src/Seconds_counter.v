module Seconds_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_1s,
    input wire up,
    input wire down,
    input wire mode,
    input wire set_second,

    output reg [3:0] second_ones,
    output reg [3:0] second_tens,
    output reg tick_m_up,
    output reg tick_m_down
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            second_ones <= 4'd0;
            second_tens <= 4'd0;
            tick_m_up <= 1'd0;
            tick_m_down <= 1'd0;
        end
        else begin
            tick_m_up <= 1'd0;
            tick_m_down <= 1'd0;
            
            if (mode) begin
                if (set_second) begin
                    if (up) begin
                        if (second_ones == 4'd9 && second_tens == 4'd5) begin
                            second_ones <= 4'd0;
                            second_tens <= 4'd0;
                            tick_m_up <= 1'd1;
                        end
                        else if (second_ones == 4'd9) begin
                            second_ones <= 4'd0;
                            second_tens <= second_tens + 4'd1;
                        end
                        else begin
                            second_ones <= second_ones + 4'd1;
                        end
                    end
                    else if (down) begin
                        if (second_ones == 4'd0 && second_tens == 4'd0) begin
                            second_ones <= 4'd9;
                            second_tens <= 4'd5;
                            tick_m_down <= 1'd1;
                        end
                        else if (second_ones == 4'd0) begin
                            second_ones <= 4'd9;
                            second_tens <= second_tens - 4'd1;
                        end
                        else begin
                            second_ones <= second_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_1s) begin
                    if (second_ones == 4'd9 && second_tens == 4'd5) begin
                        second_ones <= 4'd0;
                        second_tens <= 4'd0;
                        tick_m_up <= 1'd1;
                    end
                    else if (second_ones == 4'd9) begin
                        second_ones <= 4'd0;
                        second_tens <= second_tens + 4'd1;
                    end
                    else begin
                        second_ones <= second_ones + 4'd1;
                    end                    
                end
            end
        end
    end
    
endmodule