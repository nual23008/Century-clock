module Minutes_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_m_up,
    input wire tick_m_down,
    input wire mode,
    input wire set_minute,

    output reg [3:0] minute_ones,
    output reg [3:0] minute_tens,
    output reg tick_h_up,
    output reg tick_h_down
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minute_ones <= 4'd0;
            minute_tens <= 4'd0;
            tick_h_up <= 1'd0;
            tick_h_down <= 1'd0;
        end
        else begin
            tick_h_up <= 1'd0;
            tick_h_down <= 1'd0;

            if (mode) begin
                if (set_minute) begin
                    if (tick_m_up) begin
                        if (minute_ones == 4'd9 && minute_tens == 4'd5) begin
                            minute_ones <= 4'd0;
                            minute_tens <= 4'd0;
                            tick_h_up <= 1'd1;
                        end
                        else if (minute_ones == 4'd9) begin
                            minute_ones <= 4'd0;
                            minute_tens <= minute_tens + 4'd1;
                        end
                        else begin
                            minute_ones <= minute_ones + 4'd1;
                        end
                    end
                    else if (tick_m_down) begin
                        if (minute_ones == 4'd0 && minute_tens == 4'd0) begin
                            minute_ones <= 4'd9;
                            minute_tens <= 4'd5;
                            tick_h_down <= 1'd1;
                        end
                        else if (minute_ones == 4'd0) begin
                            minute_ones <= 4'd9;
                            minute_tens <= minute_tens - 4'd1;
                        end
                        else begin
                            minute_ones <= minute_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_m_up) begin
                    if (minute_ones == 4'd9 && minute_tens == 4'd5) begin
                        minute_ones <= 4'd0;
                        minute_tens <= 4'd0;
                        tick_h_up <= 1'd1;
                    end
                    else if (minute_ones == 4'd9) begin
                        minute_ones <= 4'd0;
                        minute_tens <= minute_tens + 4'd1;
                    end
                    else begin
                        minute_ones <= minute_ones + 4'd1;
                    end
                end
            end
        end
    end
    
endmodule
