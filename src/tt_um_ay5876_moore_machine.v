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

    wire x1 = ui_in[0];
    wire z1;
    reg [1:3] y;
    reg [1:3] next_state;

    parameter state_a=3'b000, state_b=3'b010, state_c=3'b110, state_d=3'b100, state_e=3'b011;

    always @(posedge clk) begin
        if (~rst_n)
            y <= state_a;
        else
            y <= next_state;
    end

    assign z1 = y[3];

    always @(*) begin
        case(y)
            state_a: next_state = (x1 == 0) ? state_a : state_b;
            state_b: next_state = (x1 == 0) ? state_a : state_c;
            state_c: next_state = (x1 == 0) ? state_d : state_c;
            state_d: next_state = (x1 == 0) ? state_a : state_e;
            state_e: next_state = (x1 == 0) ? state_a : state_c;
            default: next_state = state_a;
        endcase
    end

    assign uo_out[0] = y[1];
    assign uo_out[1] = y[2];
    assign uo_out[2] = y[3];
    assign uo_out[3] = z1;
    assign uo_out[7:4] = 4'b0000;
    
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

endmodule
