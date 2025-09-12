`timescale 1ns / 1ps

module LoopFilter#(
    parameter bit_count = 24,
    parameter [bit_count-1:0] default_speed = 24'd8388608,
    parameter [bit_count-1:0] max_speed = 24'd16777215,
    parameter [bit_count-1:0] min_speed = 24'd0,
    parameter [bit_count-1:0] step = 24'd1
)(
    input wire ext_rst,
    input wire up_pulse,
    input wire dn_pulse,
    input wire sys_clk,
    output reg [bit_count-1:0] speed_var  
);
    wire rst = ext_rst;
    always @(posedge rst or posedge sys_clk) begin
        if (rst) begin
            speed_var <= default_speed;
        end else begin
            case ({up_pulse, dn_pulse}) 
                2'b00: begin
                    speed_var <= default_speed;
                end 
                2'b11: begin
                    speed_var <= default_speed;
                end
                2'b10: begin
                    if (speed_var < max_speed) begin
                        speed_var <= speed_var + step;
                    end
                end
                2'b01: begin
                    if (speed_var > min_speed) begin
                        speed_var <= speed_var - step;
                    end            
                end
            endcase
        end
    end
    endmodule
