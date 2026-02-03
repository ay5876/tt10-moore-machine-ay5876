`timescale 1ns/1ps
`default_nettype none

// Tiny Tapeout top module MUST start with tt_um_
module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,    // Dedicated outputs
    input  wire [7:0] uio_in,    // IOs: Input path
    output wire [7:0] uio_out,   // IOs: Output path
    output wire [7:0] uio_oe,    // IOs: Enable path (1=output, 0=input)
    input  wire       ena,       // always 1 when enabled
    input  wire       clk,       // clock
    input  wire       rst_n       // reset_n (active low)
);

    wire [1:3] y;
    wire z1;

    // Instantiate internal Moore machine
    moore_ssm dut (
        .rst(rst_n),       // active-low reset
        .clk(clk),
        .x1(ui_in[0]),
        .y(y),
        .z1(z1)
    );

    // Outputs (match manual pinout)
    assign uo_out[0] = y[1];
    assign uo_out[1] = y[2];
    assign uo_out[2] = y[3];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;

    // No bidirectional pins used
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

    // Prevent unused warnings
    wire _unused = &{ena, uio_in, ui_in[7:1], 1'b0};

endmodule

`default_nettype wire
