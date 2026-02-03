`timescale 1ns/1ps
// Tiny Tapeout top module MUST start with tt_um_
module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,    // inputs
    output wire [7:0] uo_out,    // outputs
    input  wire [7:0] uio_in,    // bidir inputs
    output wire [7:0] uio_out,   // bidir outputs
    output wire [7:0] uio_oe,    // bidir output enable
    input  wire       ena,       // always 1 when enabled
    input  wire       clk,       // global clock
    input  wire       rst_n       // global reset (active low)
);

    wire [1:3] y;
    wire z1;

    // Your Moore machine module
    moore_ssm dut (
        .rst(rst_n),       // your module uses active-low reset already
        .clk(clk),
        .x1(ui_in[0]),
        .y(y),
        .z1(z1)
    );

    // Map to outputs (match manual pinout idea)
    assign uo_out[0] = y[1];
    assign uo_out[1] = y[2];
    assign uo_out[2] = y[3];
    assign uo_out[3] = z1;

    // Unused outputs low
    assign uo_out[7:4] = 4'b0000;

    // No bidirectional pins used
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

endmodule
