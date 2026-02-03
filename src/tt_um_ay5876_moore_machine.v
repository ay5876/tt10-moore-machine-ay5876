

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

    wire [1:3] y;
    wire z1;

    // Instantiate FSM CORE (NOT ITSELF)
    moore_ssm u_fsm (
        .rst_n(rst_n),
        .clk(clk),
        .x1(ui_in[0]),
        .y(y),
        .z1(z1)
    );

    assign uo_out[0] = y[1];
    assign uo_out[1] = y[2];
    assign uo_out[2] = y[3];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, ui_in[7:1], uio_in, 1'b0};

endmodule
