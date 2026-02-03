`default_nettype none

// Tiny Tapeout top module MUST start with tt_um_
module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock
    input  wire       rst_n      // reset_n (active low)
);

    wire [2:0] y;
    wire       z1;

    // ✅ Instantiate the Moore machine module (NOT this top module)
    moore_ssm dut (
        .rst_n(rst_n),
        .clk  (clk),
        .x1   (ui_in[0]),
        .y    (y),
        .z1   (z1)
    );

    // Outputs (mapping consistent with manual pinout intent)
    assign uo_out[0] = y[0];  // y[1] in manual
    assign uo_out[1] = y[1];  // y[2] in manual
    assign uo_out[2] = y[2];  // y[3] in manual
    assign uo_out[3] = z1;

    // Unused outputs low
    assign uo_out[7:4] = 4'b0000;

    // No bidirectional pins used
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

    // Prevent unused warnings
    wire _unused = &{ena, ui_in[7:1], uio_in, 1'b0};

endmodule

`default_nettype wire
