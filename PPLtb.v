`timescale 1ns / 1ps

module PFDtb;
reg d1, d2, clk;
wire up, dn;

PFD uut(
.d1(d1),
.d2(d2),
.clk(clk),
.up(up),
.dn(dn)
);

initial clk = 0;
always #10 clk = ~clk;

initial begin
d1 = 0;
d2 = 0;
#10 d1 = 0;
#10 d2 = 1;
#10 d1 = 1;
#10 d2 = 0;
#10 d1 = 1;
#10 d2 = 1;
#10 d1 = 0;
#10 d2 = 0;
end

endmodule
