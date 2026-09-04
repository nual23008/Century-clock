module Year_detect (
    input wire clk,
    input wire rst_n,

    input wire [3:0] year_ones,
    input wire [3:0] year_tens,
    input wire [3:0] year_hundreds,
    input wire [3:0] year_thousands,
    input wire [3:0] month_ones,
    input wire [3:0] month_tens,

    output reg [3:0] max_day_ones,
    output reg [3:0] max_day_tens,
    output reg [3:0] prev_max_day_ones,
    output reg [3:0] prev_max_day_tens
);
    wire is_leap_year;
    wire is_divided_4;
    wire is_divided_100;
    wire is_divided_400;

    assign is_divided_4 = (year_tens[0] == 1'd0 && (year_ones == 4'd0 || year_ones == 4'd4 || year_ones == 4'd8)) ||
                          (year_tens[0] == 1'd1 && (year_ones == 4'd2 || year_ones == 4'd6));
    
    assign is_divided_100 = (year_ones == 4'd0 && year_tens == 4'd0);

    assign is_divided_400 = (year_thousands[0] == 1'd0 && (year_hundreds == 4'd0 || year_hundreds == 4'd4 || year_hundreds == 4'd8)) ||
                            (year_thousands[0] == 1'd1 && (year_hundreds == 4'd2 || year_hundreds == 4'd6));
    
    assign is_leap_year = is_divided_100 ? (is_divided_400 ? 1 : 0) : (is_divided_4 ? 1 : 0);

    always @(*) begin
        if (!rst_n) begin
            max_day_ones <= 4'd1;
            max_day_tens <= 4'd3;
            prev_max_day_ones <= 4'd1;
            prev_max_day_tens <= 4'd3;
        end
        else begin
            max_day_ones <= 4'd1;
            max_day_tens <= 4'd3;
            prev_max_day_ones <= 4'd1;
            prev_max_day_tens <= 4'd3;

            if (month_tens == 4'd0 && month_ones == 4'd2) begin
                if (is_leap_year) begin
                    max_day_ones <= 4'd9;
                    max_day_tens <= 4'd2;
                end
                else begin
                    max_day_ones <= 4'd8;
                    max_day_tens <= 4'd2;
                end
            end
            else if (month_tens == 4'd0 && (month_ones == 4'd4 || month_ones == 4'd6 || month_ones == 4'd9)) begin
                max_day_ones <= 4'd0;
                max_day_tens <= 4'd3;
            end
            else if (month_tens == 4'd1 && month_ones == 4'd1) begin
                max_day_ones <= 4'd0;
                max_day_tens <= 4'd3;
            end
            else begin
                max_day_ones <= 4'd1;
                max_day_tens <= 4'd3;
            end


            if (month_tens == 4'd0 && month_ones == 4'd3) begin
                if (is_leap_year) begin
                    prev_max_day_ones <= 4'd9;
                    prev_max_day_tens <= 4'd2;
                end
                else begin
                    prev_max_day_ones <= 4'd8;
                    prev_max_day_tens <= 4'd2;
                end
            end
            else if ((month_tens == 4'd0 && month_ones == 4'd5) ||
                     (month_tens == 4'd0 && month_ones == 4'd7) ||
                     (month_tens == 4'd1 && month_ones == 4'd0) ||
                     (month_tens == 4'd1 && month_ones == 4'd2)) begin
                prev_max_day_ones <= 4'd0;
                prev_max_day_tens <= 4'd3;
            end
            else begin
                prev_max_day_ones <= 4'd1;
                prev_max_day_tens <= 4'd3;
            end
        end
    end
endmodule