`timescale 1ns/1ps
module tb;

  reg clk = 0;
  reg rst_n = 0;
  reg [7:0] ui_in = 0;
  wire [7:0] uo_out;
  reg  [7:0] uio_in = 0;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT (TinyTapeout top)
  tt_um_ay5876_moore_machine dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .clk(clk),
    .rst_n(rst_n)
  );

  // clock
  always #10 clk = ~clk;

  // dump
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // stimulus: drive x1 = ui_in[0]
  initial begin
    // hold reset low
    rst_n = 0;
    ui_in[0] = 0;
    #25;
    rst_n = 1;

    // x1 pattern on rising edges (like manual style)
    repeat(1) @(posedge clk) ui_in[0] = 0;
    repeat(1) @(posedge clk) ui_in[0] = 1;
    repeat(1) @(posedge clk) ui_in[0] = 0;
    repeat(1) @(posedge clk) ui_in[0] = 1;
    repeat(1) @(posedge clk) ui_in[0] = 0;
    repeat(1) @(posedge clk) ui_in[0] = 1;
    repeat(1) @(posedge clk) ui_in[0] = 0;
    repeat(1) @(posedge clk) ui_in[0] = 1;

    #200;
    $finish;
  end

endmodule
