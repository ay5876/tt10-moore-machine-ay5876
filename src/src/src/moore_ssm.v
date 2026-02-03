`timescale 1ns/1ps
`default_nettype none

module moore_ssm(
    input  wire rst,   // active-low reset
    input  wire clk,
    input  wire x1,
    output reg  [1:3] y,
    output wire z1
);

    reg [1:3] next_state;

    parameter state_a = 3'b000,
              state_b = 3'b010,
              state_c = 3'b110,
              state_d = 3'b100,
              state_e = 3'b011;

    // State register (async reset to avoid X at start)
    always @(posedge clk or negedge rst) begin
        if (!rst)
            y <= state_a;
        else
            y <= next_state;
    end

    // Moore output (matches manual idea)
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

`default_nettype wire
