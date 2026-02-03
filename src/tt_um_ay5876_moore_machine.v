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

    // Lab 4 Internal Signals (Page 82) 
    wire x1 = ui_in[0];
    wire z1;
    reg [1:3] y;
    reg [1:3] next_state;

    // State parameters 
    parameter state_a=3'b000, state_b=3'b010, state_c=3'b110, state_d=3'b100, state_e=3'b011;

    // Sequential State Update
    always @(posedge clk) begin
        if (~rst_n)
            y <= state_a;
        else
            y <= next_state;
    end

    // Moore Output Logic: Depends only on the state register 'y'
    assign z1 = y[3];

    // Combinational Next State Logic
    always @(y or x1) begin
        case(y)
            state_a: begin
                if(x1 == 0) next_state = state_a;
                else        next_state = state_b;
            end
            state_b: begin
                if(x1 == 0) next_state = state_a;
                else        next_state = state_c;
            end
            state_c: begin
                if(x1 == 0) next_state = state_d;
                else        next_state = state_c;
            end
            state_d: begin
                if(x1 == 0) next_state = state_a;
                else        next_state = state_e;
            end
            state_e: begin
                if(x1 == 0) next_state = state_a;
                else        next_state = state_c;
            end
            default: next_state = state_a;
        endcase
    end

    // Pin Assignments (Required for Tiny Tapeout Linter)
    assign uo_out[0] = y[1];
    assign uo_out[1] = y[2];
    assign uo_out[2] = y[3];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;
    
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
