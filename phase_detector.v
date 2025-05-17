`timescale 1ns / 1ps

module PFD(
    input d1,
    input d2,
    input clk,
    
    output reg up,
    output wire q1_n,
    output reg dn,
    output wire q2_n
    ); 
assign rst = up & dn;

always @(posedge clk or posedge rst) begin
    if (rst)
        up <= 0;
    else
        up <= d1;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        dn <= 0;
    else
        dn <= d2;
end
    
endmodule
