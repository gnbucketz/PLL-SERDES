`timescale 1ns/1ps
module pll_tb;

  reg clk, rst, d1;
  real ref_half_ns;

  wire up, dn;
  wire [23:0] speed_var, accum;
  wire signal_out, f_qn;

  // PFD / Loop / DCO / Divider (your modules)
  PFD u_pfd (.ref(d1), .fb(f_qn), .arst(rst), .up(up), .dn(dn));

  // Use the width-integrating filter above (or your original for comparison)
  LoopFilter u_lf (.up(up), .dn(dn), .rst(rst), .clk(clk), .speed_var(speed_var));

  DCO u_dco (.speed_var(speed_var), .mod(24'd16777215),
             .clk(clk), .rst(rst), .signal_out(signal_out), .accum(accum));

  Frequency_Divider u_div (.clk(signal_out), .rst(rst), .f_qn(f_qn));

  // System clock for LF, counters, etc.
  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz

  // Reference clock: 80 ns period (12.5 MHz)
  initial begin
    d1 = 1'b0;
    ref_half_ns = 40.0;
    forever #(ref_half_ns) d1 = ~d1;
  end

  // Reset & run
  initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;
    #2_000_000;  // 2 ms
    $finish;
  end

  // Timing capture and live phase measurement
  real t_ref0=0.0, t_ref1=0.0, Tref=0.0;
  real t_fb0=0.0,  t_fb1=0.0,  Tfb=0.0;
  real phase_ns = 0.0;

  // capture edge times
  always @(posedge d1)   begin t_ref0=t_ref1; t_ref1=$realtime; if (t_ref0>0) Tref=t_ref1-t_ref0; end
  always @(posedge f_qn) begin t_fb0 =t_fb1;  t_fb1 =$realtime; if (t_fb0 >0) Tfb =t_fb1 -t_fb0;  end

  // compute signed phase vs nearest ref edge on each fb edge
  task automatic update_phase;
    real k, t_ref_nearest, d;
    begin
      if (Tref>0) begin
        k = $rtoi(($realtime - t_ref1)/Tref + 0.5); // round()
        t_ref_nearest = t_ref1 + k*Tref;
        d = $realtime - t_ref_nearest;
        // wrap to (-Tref/2, +Tref/2]
        if (d >  Tref/2.0) d = d - Tref;
        if (d <= -Tref/2.0) d = d + Tref;
        phase_ns = d;
      end
    end
  endtask

  always @(posedge f_qn) begin
    update_phase();
  end

  // simple lock detector & logging
  integer lock_ctr = 0;
  always @(posedge f_qn) begin
    if (Tref>0 && Tfb>0 && (Tfb>0.98*Tref) && (Tfb<1.02*Tref) && (phase_ns>-2.0) && (phase_ns<2.0))
      lock_ctr <= lock_ctr + 1;
    else
      lock_ctr <= 0;

    if (lock_ctr==8)
      $display("[%0t ns] LOCKED: Tref=%0.2f ns Tfb=%0.2f ns phase=%0.2f ns speed=0x%0h",
               $time, Tref, Tfb, phase_ns, speed_var);

    if ($time%2000==0)
      $display("[%0t ns] Tref=%0.2f Tfb=%0.2f phase=%0.2f speed=0x%0h up=%0b dn=%0b",
               $time, Tref, Tfb, phase_ns, speed_var, up, dn);
  end

endmodule
