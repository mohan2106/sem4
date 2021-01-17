`timescale 1ns / 1ns
module booth_multiplier(m, r, out);
    input [3:0] m;
    input [3:0] r;
    output reg [7:0] out;

    reg signed [8:0] a, s, p;
    integer i;

    always@(m or r)
    begin
        a = {m, 5'b00000};
        s = {4'b0 - m, 5'b00000};
        p = {4'b0, r, 1'b0};
        for(i = 0; i <= 3; i = i + 1)
        begin
            if(p[0] == 0 & p[1] == 1)
                p = p + s;
            if(p[0] == 1 & p[1] == 0)
                p = p + a;
            p = p >>> 1;
        end
        out = p[8:1];
    end
    
endmodule