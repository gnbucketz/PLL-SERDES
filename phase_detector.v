`timescale 1ns/1ps
module PFD (
  input  wire ref,     
  input  wire fb,      
  input  wire arst,   
  output wire up,
  output wire dn
);
  reg q_ref, q_fb;

  wire rst_both = q_ref & q_fb;
  wire rst_int  = rst_both | arst;   

  always @(posedge ref or posedge rst_int) begin
    if (rst_int) q_ref <= 1'b0;
    else         q_ref <= 1'b1;   
  end

  always @(posedge fb  or posedge rst_int) begin
    if (rst_int) q_fb <= 1'b0;
    else         q_fb <= 1'b1;    
  end

  assign up = q_ref;
  assign dn = q_fb;
endmodule
