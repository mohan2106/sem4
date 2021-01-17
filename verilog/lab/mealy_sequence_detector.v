`timescale 1ns / 1ns
module mealy_sequence_detector(clk, rst, in, out, state);
    input clk, rst, in;
    output reg out;
    output reg[2:0] state;
    
    parameter _0 = 3'b000,
              _1 = 3'b001,
              _10 = 3'b010,
              _101 = 3'b011,
              _1011 = 3'b100;
    
    reg[2:0] next_state;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= _0;
        else
        begin
            state <= next_state;
        end
    end

    always@(in or state)
    begin
        case(state)
            _0:
            begin
                if(in)
                    next_state <= _1;
                else
                    next_state <= _0;
                out <= 1'b0;
            end
            _1:
            begin
                if(in)
                    next_state <= _1;
                else
                    next_state <= _10;
                out <= 1'b0;
            end
            _10:
            begin
                if(in)
                    next_state <= _101;
                else
                    next_state <= _0;
                out <= 1'b0;
            end
            _101:
            begin
                if(in)
                begin
                    next_state <= _1011;
                    out <= 1'b1;
                end
                else
                begin
                    next_state <= _10;
                    out <= 1'b0;
                end
            end
            _1011:
            begin
                if(in)
                    next_state <= _1;
                else
                    next_state <= _10;
                out <= 1'b0;
            end
            default:
            begin
                next_state <= _0;
                out <= 1'b0;
            end
        endcase

    end
endmodule