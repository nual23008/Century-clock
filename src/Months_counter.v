module Months_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_mo_up,
    input wire tick_mo_down,
    input wire mode,
    input wire set_month,

    output reg [3:0] month_ones,
    output reg [3:0] month_tens,
    output reg tick_y_up,
    output reg tick_y_down
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            month_ones <= 4'd1;
            month_tens <= 4'd0;
            tick_y_up <= 1'd0;
            tick_y_down <= 1'd0;
        end
        else begin
            tick_y_up <= 1'd0;
            tick_y_down <= 1'd0;
        
            if (mode) begin
                if (set_month) begin
                    if (tick_mo_up) begin
                        if (month_tens == 4'd1 && month_ones == 4'd2) begin
                            month_ones <= 4'd1;
                            month_tens <= 4'd0;
                            tick_y_up <= 1'd1;
                        end
                        else if (month_ones == 4'd9) begin
                            month_ones <= 4'd0;
                            month_tens <= month_tens + 4'd1;
                        end
                        else begin
                            month_ones <= month_ones + 4'd1;
                        end
                    end
                    else if (tick_mo_down) begin
                        if (month_ones == 4'd1 && month_tens == 4'd0) begin
                            month_ones <= 4'd2;
                            month_tens <= 4'd1;
                            tick_y_down <= 1'd1;
                        end
                        else if (month_ones == 4'd0) begin
                            month_ones <= 4'd9;
                            month_tens <= month_tens - 4'd1;
                        end
                        else begin
                            month_ones <= month_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_mo_up) begin
                    if (month_tens == 4'd1 && month_ones == 4'd2) begin
                        month_ones <= 4'd1;
                        month_tens <= 4'd0;
                        tick_y_up <= 1'd1;
                    end
                    else if (month_ones == 4'd9) begin
                        month_ones <= 4'd0;
                        month_tens <= month_tens + 4'd1;
                    end
                    else begin
                        month_ones <= month_ones + 4'd1;
                    end
                end          
            end
        end
    end
endmodule