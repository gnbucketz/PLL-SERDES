`timescale 1ns / 1ps

module LoopFilter(
    input up, dn, rst, clk,
    output reg [7:0] speed_var
    );

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        speed_var <= 24'd8388608;
    end else begin 
    case({up, dn})
        2'b00: speed_var <= speed_var;
        2'b01: speed_var <= (speed_var > 0) ? speed_var - 1 : 24'd0; 
        2'b10: speed_var <= (speed_var < 24'd16777215) ? speed_var + 1 : 24'd16777215; 
        2'b11: speed_var <= speed_var;
        default: speed_var <= 24'd8388608;
        endcase
        end
    end
endmodule 
