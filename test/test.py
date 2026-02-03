`default_nettype none

module tt_um_ay5876_moore_machine (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal Signals
    wire x1 = ui_in[0];
    wire z1;
    reg [2:0] y;          // Changed to [2:0] for standard 0-based indexing
    reg [2:0] next_state;

    // State parameters (Matching Page 82)
    parameter state_a=3'b000, state_b=3'b010, state_c=3'b110, state_d=3'b100, state_e=3'b011;

    // Sequential State Update
    always @(posedge clk) begin
        if (!rst_n)
            y <= state_a;
        else
            y <= next_state;
    end

    // Moore Output Logic: Depends ONLY on the state
    // In Lab 4, z1 is high when in state_c or state_e depending on the specific sequence
    assign z1 = (y == state_c || y == state_e); 

    // Combinational Next State Logic
    always @(*) begin
        case(y)
            state_a: next_state = x1 ? state_b : state_a;
            state_b: next_state = x1 ? state_c : state_a;
            state_c: next_state = x1 ? state_c : state_d;
            state_d: next_state = x1 ? state_e : state_a;
            state_e: next_state = x1 ? state_c : state_a;
            default: next_state = state_a;
        endcase
    end

    // Pin Assignments (Must drive all 8 pins)
    assign uo_out[0] = y[0];
    assign uo_out[1] = y[1];
    assign uo_out[2] = y[2];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;
    
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
