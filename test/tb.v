`timescale 1ns/1ps
`default_nettype none

module tb;

    reg clk;
    reg rst_n;

    wire [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    wire ena;

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

    // Clock generation (cocotb also drives clock, this is OK)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dump waveform (OK)
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

    // ❌ NO $finish HERE
    // ❌ NO stimulus HERE
    // cocotb controls everything

endmodule
