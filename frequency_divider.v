`timescale 1ns / 1ps

module Frequency_Divider#(
parameter n = 1
//1 = divide 2, 2 = divide 4, 3 = divide by 8
)(
input clk, input rst,
output reg f_qn
    );
reg [7:0] counter;

always @(posedge clk or rst) begin
    if (rst) begin
        f_qn <= 0;
        counter <= 0;
    end else if (counter == 2** (n+1)) begin
        counter <= 0;
        f_qn = ~f_qn;    
    end else 
        counter <= counter + 1;
    end
endmodule
