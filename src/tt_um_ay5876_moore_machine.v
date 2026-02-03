`default_nettype none

module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Use a normal descending range (no [1:3])
    wire [2:0] y;
    wire       z1;

    // Instantiate your Moore core (NOT the top module)
    moore_ssm u_core (
        .clk   (clk),
        .rst_n (rst_n),
        .x1    (ui_in[0]),
        .y     (y),
        .z1    (z1)
    );

    // Output mapping
    assign uo_out[0] = y[0];
    assign uo_out[1] = y[1];
    assign uo_out[2] = y[2];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;

    // Unused bidir pins
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // 'ena' can be unused (allowed). If you want:
    // wire _unused = ena | uio_in[0];

endmodule
