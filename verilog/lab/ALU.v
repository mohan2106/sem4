`timescale 1ns / 1ns
module ALU(a, b, func, c);
    input [7:0] a;
    input [7:0] b;
    input [2:0] func;
    output reg [7:0] c;

    always @(*)
    begin
        case(func)
            3'b000: c = a + b;
            3'b001: c = a - b;
            3'b010: c = a & b;
            3'b011: c = a ^ b;
            3'b100: c = ~a;
            3'b101: c = a << b;
            3'b110: c = a >> b;
            default: c = 8'b0;
        endcase
    end
    

endmodule