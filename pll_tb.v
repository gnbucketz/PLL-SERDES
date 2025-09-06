`timescale 1ns/1ps
module pll_tb;

  reg clk, rst;
  reg d1;
  real ref_half_ns;

  wire up, dn;
  wire [23:0] speed_var, accum;
  wire signal_out, f_qn;

  PFD u_pfd (.ref(d1), .fb(f_qn), .arst(rst), .up(up), .dn(dn));

  LoopFilter u_lf (.up(up), .dn(dn), .rst(rst), .clk(clk), .speed_var(speed_var));

  DCO u_dco (.speed_var(speed_var), .mod(24'd16777215),  // must be 2^24-1
             .clk(clk), .rst(rst), .signal_out(signal_out), .accum(accum));

  Frequency_Divider u_div (.clk(signal_out), .rst(rst), .f_qn(f_qn));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    d1 = 1'b0;
    ref_half_ns = 40.0;            // 80 ns period = 12.5 MHz
    forever #(ref_half_ns) d1 = ~d1;
  end

  initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;

    #2_000_000;    // 2 ms
    $finish;
  end

//t_ref0, t_ref1: store the times of the last two rising edges of the reference clock d1
//t_ref = time between the tref1 and tref0
//t_fb0, t_fb1 store the times of the last two rising edges of the feedback clock f_qn
//T_fb: the measured period of f_qn (t_fb1 - t_fb0)
//phase_ns: time difference between the most recent feedback edge and the most recent reference edge

  real t_ref0=0,t_ref1=0,Tref=0;
  real t_fb0=0,t_fb1=0,Tfb=0;
  real phase_ns;

  always @(posedge d1)   begin t_ref0=t_ref1; t_ref1=$realtime; if(t_ref0>0) Tref=t_ref1-t_ref0; end
  always @(posedge f_qn) begin t_fb0 =t_fb1;  t_fb1 =$realtime; if(t_fb0 >0) Tfb =t_fb1 -t_fb0; end

  initial begin
    @(negedge rst);
    #5000; 
    phase_ns = (t_fb1 - t_ref1);
  end

endmodule
