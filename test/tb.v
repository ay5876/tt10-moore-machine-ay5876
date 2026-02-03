`timescale 1ns/1ps
`default_nettype none

module tb;
    // These MUST be regs so cocotb can drive them from Python
    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;

    // These are wires because they are outputs from the DUT
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate DUT
    tt_um_ay5876_moore_machine dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Waveform dumping (Fixed Case Sensitivity)
    initial begin
        $dumpfile("tb.vcd");  // Must be lowercase
        $dumpvars(0, tb);     // Must be lowercase
        #1;
    end
endmodule
