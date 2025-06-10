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

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        speed_var <= default_speed;
    end else begin 
    case({up, dn})
        2'b00: speed_var <= speed_var;
        2'b01: speed_var <= (speed_var > 0) ? speed_var - 1 : min_speed; 
        2'b10: speed_var <= (speed_var < max_speed) ? speed_var + 1 : max_speed; 
        2'b11: speed_var <= speed_var;
        endcase
        end
    end
endmodule 
