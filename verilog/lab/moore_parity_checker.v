`timescale 1ns / 1ns
module moore_parity_checker(clk, rst, in, out, state);
    input clk, rst, in;
    output reg out, state;

    parameter zero = 1'b0,
              one = 1'b1;
    
    reg next_state;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= zero;
        else
        begin
            state <= next_state;
        end
    end

    always@(in or state)
    begin
        if(state == one)
        begin
            if(in == 1)
                next_state <= zero;
            else
                next_state <= one;
        end
        else
        begin
            if(in == 1)
                next_state <= one;
            else
                next_state <= zero;
        end 
    end

    always@(state)
    begin
        out = state;
    end
endmodule