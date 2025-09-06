`timescale 1ns/1ps
module DCO#(
  parameter bit_count = 24
)(
  input  wire [bit_count-1:0] speed_var,
  input  wire [bit_count-1:0] mod,
  input  wire clk,
  input  wire rst,
  output reg  signal_out,
  output reg  [bit_count-1:0] accum
);
  reg [bit_count:0] sum; // one bit wider

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      accum      <= {bit_count{1'b0}};
      signal_out <= 1'b0;
    end else begin
      sum = {1'b0,accum} + {1'b0,speed_var};  // wide add
      if (sum >= {1'b0,mod}) begin
        accum      <= sum - {1'b0,mod};       // modulo subtract
        signal_out <= ~signal_out;            // toggle on wrap
      end else begin
        accum      <= sum[bit_count-1:0];
        // signal_out unchanged
      end
    end
  end
endmodule
