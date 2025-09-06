`timescale 1ns / 1ps

module LoopFilter#(
    parameter bit_count = 24,
    parameter default_speed = 8388608,
    parameter max_speed = 16777215,
    parameter min_speed = 0
)(
    input up, dn, rst, clk,
    output reg [bit_count-1:0] speed_var
    );

reg up_s1, up_s2, dn_s1, dn_s2;
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        up_s1 <= 0; up_s2 <= 0;
        dn_s1 <= 0; dn_s2 <= 0;
    end else begin 
        up_s1 <= up;   //synches with pfd
        up_s2 <= up_s1; //takes previous value of up_s1
        dn_s1 <= dn;
        dn_s2 <= dn_s1;
        end
    end
    
    wire up_pulse =  up_s1 & ~up_s2; 
    wire dn_pulse =  dn_s1 & ~dn_s2;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      speed_var <= default_speed;
    end else begin
      if (up_pulse & ~dn_pulse) begin
        speed_var <= (speed_var < max_speed) ? (speed_var + 1'b1) : max_speed; //read as if speed_var < max_speed +1 if not set as max_speed
      end else if (dn_pulse & ~up_pulse) begin
        speed_var <= (speed_var > min_speed) ? (speed_var - 1'b1) : min_speed; //read as if speed_var ? max_speed -1 if not set as min_speed
      end
    end
  end
endmodule 
