`timescale 1ns/1ps
`default_nettype none

// ---------------------------
// Your Moore Machine (manual)
// ---------------------------
module tt_um_ay5876_moore_machine (
    input  wire rst,      // active-low reset
    input  wire clk,
    input  wire x1,
    output reg  [1:3] y,   // manual indexing
    output wire z1
);

    reg [1:3] next_state;

    parameter state_a = 3'b000,
              state_b = 3'b010,
              state_c = 3'b110,
              state_d = 3'b100,
              state_e = 3'b011;

    // State register (async active-low reset)
    always @(posedge clk or negedge rst) begin
        if (!rst)
            y <= state_a;
        else
            y <= next_state;
    end

    // Output (same idea as manual)
    assign z1 = (~clk) & y[3];

    // Next-state logic
    always @(*) begin
        next_state = y; // default prevents latch
        case (y)
            state_a: next_state = (x1 == 1'b0) ? state_a : state_b;
            state_b: next_state = (x1 == 1'b0) ? state_a : state_c;
            state_c: next_state = (x1 == 1'b0) ? state_d : state_c;
            state_d: next_state = (x1 == 1'b0) ? state_a : state_e;
            state_e: next_state = (x1 == 1'b0) ? state_a : state_c;
            default: next_state = state_a;
        endcase
    end

endmodule


// --------------------------------------------
// TinyTapeout TOP MODULE (this is required)
// --------------------------------------------
module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,    // inputs (we use ui_in[0] as x1)
    output wire [7:0] uo_out,   // outputs
    input  wire [7:0] uio_in,   // unused
    output wire [7:0] uio_out,  // unused
    output wire [7:0] uio_oe,   // unused
    input  wire       clk,
    input  wire       rst_n      // active-low reset
);

    wire [1:3] y;
    wire z1;

    // Use ui_in[0] as x1
    moore_ssm dut (
        .rst(rst_n),
        .clk(clk),
        .x1(ui_in[0]),
        .y(y),
        .z1(z1)
    );

    // Map outputs:
    // uo_out[0] = z1
    // uo_out[3:1] = state bits y[1:3] (so it matches your waveform/report nicely)
    assign uo_out[0] = z1;
    assign uo_out[3] = y[3];
    assign uo_out[2] = y[2];
    assign uo_out[1] = y[1];
    assign uo_out[7:4] = 4'b0000;

    // unused bidirectional pins
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // avoid unused warnings
    wire _unused = &{uio_in, ui_in[7:1], 1'b0};

endmodule

`default_nettype wire
