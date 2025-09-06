`timescale 1ns/1ps
module Frequency_Divider #(
  parameter integer DIVIDE = 2  // even number >= 2
)(
  input  wire clk,
  input  wire rst,
  output reg  f_qn
);
  localparam integer HALF = DIVIDE/2;
  integer count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      f_qn  <= 1'b0;
      count <= 0;
    end else if (count == HALF-1) begin //8/2= 4, 4-1 = 3, after 3rd waveform itll flip
      count <= 0;
      f_qn  <= ~f_qn;
    end else begin
      count <= count + 1;
    end
  end
endmodule
