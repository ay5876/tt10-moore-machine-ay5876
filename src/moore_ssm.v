`default_nettype none

module moore_ssm (
    input  wire rst_n,   // active-low reset
    input  wire clk,
    input  wire x1,
    output reg  [2:0] y, // use [2:0] (NOT [1:3]) to satisfy lint
    output wire z1
);

    reg [2:0] next_state;

    localparam state_a = 3'b000,
               state_b = 3'b010,
               state_c = 3'b110,
               state_d = 3'b100,
               state_e = 3'b011;

    // State register (async reset so y never starts as X)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            y <= state_a;
        else
            y <= next_state;
    end

    // Manual’s idea: output depends on clk level and MSB of state
    assign z1 = (~clk) & y[2];   // y[2] corresponds to "y[3]" in the manual

    // Next-state logic
    always @(*) begin
        next_state = y;
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
