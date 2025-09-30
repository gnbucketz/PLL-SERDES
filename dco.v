`timescale 1ns/1ps
module DCO #(
  parameter bit_count = 24          
)(
  input  wire                 sys_clk,    
  input  wire                 ext_rst,    
  input  wire [bit_count-1:0] speed_var,  
  input  wire [bit_count-1:0] mod,        
  output reg                  signal_out, 
  output reg  [bit_count-1:0] accum       
);
    
  wire rst = ext_rst;  
  always @(posedge sys_clk or posedge ext_rst) begin
    if (rst) begin
      accum      <= {bit_count{1'b0}};
      signal_out <= 1'b0;
    end else begin
      accum      <= accum + speed_var + mod;  
      signal_out <= accum[bit_count-1];       
    end
  end

endmodule
