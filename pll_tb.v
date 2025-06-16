`timescale 1ns / 1ps

module pll_tb;

reg d1, d2, clk, rst;
reg [23:0] mod;  
wire up, dn;
wire [23:0] speed_var;
wire [23:0] accum;
wire signal_out;
wire f_qn;
wire [23:0] counter;

// Instantiate Phase Frequency Detector
PFD dut(
    .d1(d1),
    .d2(d2),
    .clk(clk),
    .up(up),
    .dn(dn)
);

// Instantiate Loop Filter
LoopFilter dut2(
    .clk(clk),
    .up(up),
    .dn(dn),
    .speed_var(speed_var),
    .rst(rst)
);

// Instantiate Digitally Controlled Oscillator
DCO #(
    .bit_count(24),
    .min_value(0)
) dut3 (
    .clk(clk),
    .speed_var(speed_var),
    .mod(mod),
    .rst(rst),
    .signal_out(signal_out),
    .accum(accum)
);

// Instantiate Frequency Divider to generate f_qn from DCO output
Frequency_Divider #(
    .n(1),
    .bit_count(8)
) divider (
    .clk(signal_out),
    .rst(rst),
    .f_qn(f_qn)
);
    // === System Clock ===
    initial clk = 0;
    always #5 clk = ~clk;  // 100 MHz

    // === Reference Clock d1 ===
    initial begin
        d1 = 0;
        forever begin
            #40 d1 = ~d1;  // Period = 80ns (12.5 MHz), 50% duty
        end
    end

    // === Delayed Clock d2 ===
    initial begin
        d2 = 0;
        forever begin
            #50 d2 = ~d2;  // Same period, but 10ns delayed vs d1
        end
    end

    // === Test Control ===
    initial begin
        rst = 1;
        mod = 24'd100000;
        #100;

        rst = 0;

        #2000;  // Let the simulation run
        $finish;
    end

    // === Monitor ===
    initial begin
        $display("Time\tD1\tD2\tUP\tDN\tSpeedVar\tSignal_Out");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%d\t%b",
                 $time, d1, d2, up, dn, speed_var, signal_out);
    end


endmodule
