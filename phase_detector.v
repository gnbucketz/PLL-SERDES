`timescale 1ns / 1ps

module PFD(
    input d1,
    input d2,
    input clk1,
    input clk2,
    
    output reg up,
    output wire q1_n,
    output reg dn,
    output wire q2_n
    );
assign q1_n = ~up;
assign q2_n = ~dn;   
assign rst = up & dn;

always @(posedge clk1 or posedge rst) begin
    if (rst)
        up <= 0;
    else
        up <= d1;
end

always @(posedge clk2 or posedge rst) begin
    if (rst)
        dn <= 0;
    else
        dn <= d2;
end
    
endmodule
