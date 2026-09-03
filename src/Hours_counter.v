module Hours_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_h_up,
    input wire tick_h_down,
    input wire mode,
    input wire set_hour,

    output reg [3:0] hour_ones,
    output reg [3:0] hour_tens,
    output reg tick_d_up,
    output reg tick_d_down
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hour_ones <= 4'd0;
            hour_tens <= 4'd0;
            tick_d_up <= 1'd0;
            tick_d_down <= 1'd0;
        end
        else begin
            tick_d_up <= 1'd0;
            tick_d_down <= 1'd0;

            if (mode) begin
                if (set_hour) begin
                    if (tick_h_up) begin
                        if (hour_ones == 4'd3 && hour_tens == 4'd2) begin
                            hour_ones <= 4'd0;
                            hour_tens <= 4'd0;
                            tick_d_up <= 1'd1;
                        end
                        else if (hour_ones == 4'd9) begin
                            hour_ones <= 4'd0;
                            hour_tens <= hour_tens + 4'd1;
                        end
                        else begin
                            hour_ones <= hour_ones + 4'd1;
                        end
                    end
                    else if (tick_h_down) begin
                        if (hour_ones == 4'd0 && hour_tens == 4'd0) begin
                            hour_ones <= 4'd3;
                            hour_tens <= 4'd2;
                            tick_d_down <= 1'd1;
                        end
                        else if (hour_ones == 4'd0) begin
                            hour_ones <= 4'd9;
                            hour_tens <= hour_tens - 4'd1;
                        end
                        else begin
                            hour_ones <= hour_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_h_up) begin
                    if (hour_ones == 4'd3 && hour_tens == 4'd2) begin
                        hour_ones <= 4'd0;
                        hour_tens <= 4'd0;
                        tick_d_up <= 1'd1;
                    end
                    else if (hour_ones == 4'd9) begin
                        hour_ones <= 4'd0;
                        hour_tens <= hour_tens + 4'd1;
                    end
                    else begin
                        hour_ones <= hour_ones + 4'd1;
                    end
                end               
            end
        end
    end
endmodule