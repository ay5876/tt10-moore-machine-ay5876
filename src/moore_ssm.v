`timescale 1ns/1ps

module moore_ssm (
    input  wire rst_n,
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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            y <= state_a;
        else
            y <= next_state;
    end

    assign z1 = (~clk) & y[3];

    always @(*) begin
        next_state = y;
        case (y)
            state_a: next_state = x1 ? state_b : state_a;
            state_b: next_state = x1 ? state_c : state_a;
            state_c: next_state = x1 ? state_c : state_d;
            state_d: next_state = x1 ? state_e : state_a;
            state_e: next_state = x1 ? state_c : state_a;
            default: next_state = state_a;
        endcase
    end

endmodule
