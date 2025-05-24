`timescale 1ns / 1ps

module PFD(
 input d1, d2, clk,
 output reg up, dn,
 output wire rst
 );
 
 assign rst = up & dn;
 
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        up <= 0;
        dn <= 0;
    end else begin
        up <= d1;
        dn <= d2;
end
end
endmodule
