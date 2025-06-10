`timescale 1ns / 1ps

module DCO#(
parameter bit_count = 24,
parameter min_value = 0
)(
input [bit_count-1:0] speed_var, 
input [bit_count-1:0] mod,
input clk, 
input rst, 
output reg signal_out,
output reg [bit_count-1:0] accum

    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        accum <= min_value;
        signal_out <= 1'b0;
    end else begin
    if (accum >= mod) begin
        accum <= min_value;
        signal_out <= ~signal_out;
    end else begin
        accum <= accum + speed_var;

    end
    end
end
endmodule
