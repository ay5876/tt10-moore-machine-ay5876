`default_nettype none

module moore_ssm (
    input  wire       clk,
    input  wire       rst_n,   // active-low reset
    input  wire       x1,
    output reg  [2:0] y,
    output reg        z1
);

    // 4-state example Moore machine
    typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
    state_t state, next;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else        state <= next;
    end

    // Next-state logic
    always @(*) begin
        next = state;
        case (state)
            S0: next = x1 ? S1 : S0;
            S1: next = x1 ? S2 : S0;
            S2: next = x1 ? S3 : S0;
            S3: next = x1 ? S3 : S0;
            default: next = S0;
        endcase
    end

    // Moore outputs depend only on state
    always @(*) begin
        y  = 3'b000;
        z1 = 1'b0;
        case (state)
            S0: begin y = 3'b001; z1 = 1'b0; end
            S1: begin y = 3'b010; z1 = 1'b0; end
            S2: begin y = 3'b100; z1 = 1'b0; end
            S3: begin y = 3'b111; z1 = 1'b1; end
            default: begin y = 3'b001; z1 = 1'b0; end
        endcase
    end

endmodule
