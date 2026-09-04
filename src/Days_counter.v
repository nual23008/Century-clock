module Days_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_d_up,
    input wire tick_d_down,
    input wire mode,
    input wire set_day,

    input wire [3:0] max_day_ones,
    input wire [3:0] max_day_tens,
    input wire [3:0] prev_max_day_ones,
    input wire [3:0] prev_max_day_tens,

    output reg [3:0] day_ones,
    output reg [3:0] day_tens,
    output reg tick_mo_up,
    output reg tick_mo_down
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            day_ones <= 4'd1;
            day_tens <= 4'd0;
            tick_mo_up <= 1'd0;
            tick_mo_down <= 1'd0;
        end
        else begin
            tick_mo_up <= 1'd0;
            tick_mo_down <= 1'd0;

            if (mode) begin
                if ((day_tens > max_day_tens) || ((day_tens == max_day_tens) && (day_ones > max_day_ones))) begin
                    day_ones <= max_day_ones;
                    day_tens <= max_day_tens;
                end
                if (set_day) begin
                    if (tick_d_up) begin
                        if (day_ones == max_day_ones && day_tens == max_day_tens) begin
                            day_ones <= 4'd1;
                            day_tens <= 4'd0;
                            tick_mo_up <= 1'd1;
                        end
                        else if (day_ones == 4'd9) begin
                            day_ones <= 4'd0;
                            day_tens <= day_tens + 4'd1;
                        end
                        else begin
                            day_ones <= day_ones + 4'd1;
                        end
                    end
                    else if (tick_d_down) begin
                        if (day_ones == 4'd1 && day_tens == 4'd0) begin
                            day_ones <= prev_max_day_ones;
                            day_tens <= prev_max_day_tens;
                            tick_mo_down <= 1'd1;
                        end
                        else if (day_ones == 4'd0) begin
                            day_ones <= 4'd9;
                            day_tens <= day_tens - 4'd1;
                        end
                        else begin
                            day_ones <= day_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_d_up) begin
                    if (day_ones == max_day_ones && day_tens == max_day_tens) begin
                        day_ones <= 4'd1;
                        day_tens <= 4'd0;
                        tick_mo_up <= 1'd1;
                    end
                    else if (day_ones == 4'd9) begin
                        day_ones <= 4'd0;
                        day_tens <= day_tens + 4'd1;
                    end
                    else begin
                        day_ones <= day_ones + 4'd1;
                    end
                end                
            end
        end
    end
    
endmodule