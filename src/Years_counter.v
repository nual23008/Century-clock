module Years_counter (
    input wire clk,
    input wire rst_n,
    input wire tick_y_up,
    input wire tick_y_down,
    input wire mode,
    input wire set_year,

    output reg [3:0] year_ones,
    output reg [3:0] year_tens,
    output reg [3:0] year_hundreds,
    output reg [3:0] year_thousands
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            year_ones <= 4'd0;
            year_tens <= 4'd0;
            year_hundreds <= 4'd0;
            year_thousands <= 4'd0;
        end
        else begin
            if (mode) begin
                if (set_year) begin
                    if (tick_y_up) begin
                        if (year_ones == 4'd9 && year_tens == 4'd9 && year_hundreds == 4'd9 && year_thousands == 4'd9) begin
                            year_ones <= 4'd0;
                            year_tens <= 4'd0;
                            year_hundreds <= 4'd0;
                            year_thousands <= 4'd0;                           
                        end
                        else if (year_ones == 4'd9 && year_tens == 4'd9 && year_hundreds == 4'd9) begin
                            year_ones <= 4'd0;
                            year_tens <= 4'd0;
                            year_hundreds <= 4'd0;
                            year_thousands <= year_thousands + 4'd1;                            
                        end
                        else if (year_ones == 4'd9 && year_tens == 4'd9) begin
                            year_ones <= 4'd0;
                            year_tens <= 4'd0;
                            year_hundreds <= year_hundreds + 4'd1;
                        end
                        else if (year_ones == 4'd9) begin
                            year_ones <= 4'd0;
                            year_tens <= year_tens + 4'd1;
                        end
                        else begin
                            year_ones <= year_ones + 4'd1;
                        end
                    end
                    else if (tick_y_down) begin
                        if (year_ones == 4'd0 && year_tens == 4'd0 && year_hundreds == 4'd0 && year_thousands == 4'd0) begin
                            year_ones <= 4'd9;
                            year_tens <= 4'd9;
                            year_hundreds <= 4'd9;
                            year_thousands <= 4'd9;                                                      
                        end
                        else if (year_ones == 4'd0 && year_tens == 4'd0 && year_hundreds == 4'd0) begin
                            year_ones <= 4'd9;
                            year_tens <= 4'd9;
                            year_hundreds <= 4'd9;
                            year_thousands <= year_thousands - 4'd1;
                        end
                        else if (year_ones == 4'd0 && year_tens == 4'd0) begin
                            year_ones <= 4'd9;
                            year_tens <= 4'd9;
                            year_hundreds <= year_hundreds - 4'd1;
                        end
                        else if (year_ones == 4'd0) begin
                            year_ones <= 4'd9;
                            year_tens <= year_tens - 4'd1;
                        end
                        else begin
                            year_ones <= year_ones - 4'd1;
                        end
                    end
                end
            end
            else begin
                if (tick_y_up) begin
                    if (year_ones == 4'd9 && year_tens == 4'd9 && year_hundreds == 4'd9 && year_thousands == 4'd9) begin
                        year_ones <= 4'd0;
                        year_tens <= 4'd0;
                        year_hundreds <= 4'd0;
                        year_thousands <= 4'd0;                           
                    end
                    else if (year_ones == 4'd9 && year_tens == 4'd9 && year_hundreds == 4'd9) begin
                        year_ones <= 4'd0;
                        year_tens <= 4'd0;
                        year_hundreds <= 4'd0;
                        year_thousands <= year_thousands + 4'd1;                            
                    end
                    else if (year_ones == 4'd9 && year_tens == 4'd9) begin
                        year_ones <= 4'd0;
                        year_tens <= 4'd0;
                        year_hundreds <= year_hundreds + 4'd1;
                    end
                    else if (year_ones == 4'd9) begin
                        year_ones <= 4'd0;
                        year_tens <= year_tens + 4'd1;
                    end
                    else begin
                        year_ones <= year_ones + 4'd1;
                    end                      
                end
            end
        end
    end
endmodule