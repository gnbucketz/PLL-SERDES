`timescale 1ns / 1ps

module pll_tb;
reg d1, d2, clk;
wire up, dn;
wire [7:0] speed_var;

PFD dut(
.d1(d1),
.d2(d2),
.clk(clk),
.up(up),
.dn(dn)
);

LoopFilter dut2(
.clk(clk),
.up(up),
.dn(dn),
.speed_var(speed_var),
.rst(rst)
);

DCO dut3(
.clk(clk),
.speed_var(speed_var),
.mod(mod),
.rst(rst),
.signal_out(signal_out)
);

initial clk = 0;
always #10 clk = ~clk;

initial begin
    d1 = 0; d2 = 0; #10;

    d1 = 0; d2 = 1; #10;
    d1 = 0; d2 = 0; #10;

    d1 = 0; d2 = 1; #10;
    d1 = 0; d2 = 0; #10;

    d1 = 1; d2 = 0; #10;
    d1 = 0; d2 = 0; #10;

    d1 = 1; d2 = 0; #10;
    d1 = 0; d2 = 0; #10;

    d1 = 1; d2 = 1; #10;
    d1 = 0; d2 = 0; #10;

    d1 = 0; d2 = 0; #20;

    repeat (10) begin
        d1 = 0; d2 = 1; #10;
        d1 = 0; d2 = 0; #10;
    end

    repeat (10) begin
        d1 = 1; d2 = 0; #10;
        d1 = 0; d2 = 0; #10;
    end

    d1 = 1; d2 = 1; #10;
    d1 = 0; d2 = 0; #10;

    $finish;
end
endmodule
