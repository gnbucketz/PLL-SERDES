`timescale 1ns / 1ps

module PFD(
    input d1,
    input d2,
    input clk1,
    input clk2,
    input rst,
    
    output reg q1,
    output wire q1_n,
    output reg q2,
    output wire q2_n,
    output wire pfd
    );
assign q1_n = ~q1;
assign q2_n = ~q2;   
assign pfd = q1 & q2;

always @(posedge clk1 or posedge rst) begin
    if (rst)
        q1 <= 0;
    else
        q1 <= d1;
end
    
endmodule
