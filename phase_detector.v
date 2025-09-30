`timescale 1ns/1ps

module PFD (
    input wire ref,
    input wire compared,
    input wire ext_rst,
    output reg up,
    output reg dn
);
    wire rst = ext_rst | (up & dn);
     
    always @(posedge rst or posedge ref) begin
        if (rst) begin
            up <= 1'b0;
        end else begin
            up <= 1'b1;
        end
    end
    
    always @(posedge rst or posedge compared) begin
        if (rst) begin
            dn <= 1'b0;
        end else begin
            dn <= 1'b1;
        end 
    end
    
    assign up_pulse = up & ~dn;
    assign dn_pulse = dn & ~up;
endmodule
