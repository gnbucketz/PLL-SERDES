`timescale 1ns / 1ps

module LoopFilter(
    input up, dn, rst, clk,
    output reg [7:0] speed_var
    );

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        speed_var <= 8'd128;
    end else begin 
    case({up, dn})
        2'b00: speed_var <= speed_var;
        2'b01: speed_var <= (speed_var > 0) ? speed_var - 1 : 8'd0; 
        2'b10: speed_var <= (speed_var < 8'd255) ? speed_var + 1 : 8'd255; 
        2'b11: speed_var <= speed_var;
        default: speed_var <= 8'd128;
        endcase
        end
    end
endmodule 
