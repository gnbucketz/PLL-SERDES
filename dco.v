`timescale 1ns / 1ps

module DCO(
input [23:0] speed_var, 
input [23:0] mod,
input clk, 
input rst, 
output reg signal_out
    );

reg [23:0] accum = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        accum <=24'd0;
        signal_out <=1'd0;
    end else begin
    if (accum >= mod) begin
        accum <= 0;
        signal_out <= ~signal_out;
    end else begin
        accum <= accum + speed_var;

    end
    end
end
endmodule
