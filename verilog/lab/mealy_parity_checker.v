`timescale 1ns / 1ns
module mealy_parity_checker(clk, rst, in, out, state);
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
            begin
                next_state <= zero;
                out <= 0;
            end
            else
            begin
                next_state <= one;
                out <= 1;
            end
        end
        else
        begin
            if(in == 1)
            begin
                next_state <= one;
                out <= 1;
            end
            else
            begin
                next_state <= zero;
                out <= 0;
            end
        end 
    end
endmodule