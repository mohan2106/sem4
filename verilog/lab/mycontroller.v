`timescale 1ns / 1ns
`include "RAM.v"
`include "RF.v"
`include "ALU.v"

module mycontroller(clk, reset, mar, wr_sel, rd_sel, out, a, b, c);
    input clk;
    input reset;

    // For debugging
    output reg [3:0] mar;
    output reg [3:0] wr_sel;
    output reg [3:0] rd_sel;
    output [7:0] out;
    output reg [7:0]a;
    output reg [7:0]b;
    output [7:0]c;
    
    // RAM and RF pointers
    wire [15:0] mdr;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in;
    reg wr_en;
    integer i;


    // ALU pointers
    reg [15:0] ins;
    reg [3:0] op;
    reg [2:0] func;


    RAM ram(clk, 16'b0, 1'b0, 1'b1, mar, mdr);
    RF rf(clk, reset, rd_sel, wr_sel, wr_en, in, out);
    ALU alu(a, b, func, c);

    initial
    begin
        // Loading first 2 memory locations
        wr_en = 1'b1;
        mar = 4'b0;
        wr_sel = 4'b0;
        for(i = 0; i < 2; i = i + 1)
        begin
            #30 in1 = mdr[15:8]; in = in1;
            #30 wr_sel = wr_sel + 1; in2 = mdr[7:0]; in = in2;
            #30 mar = mar + 1; wr_sel = wr_sel + 1;
        end

        // verification of RF Loading
        wr_en = 1'b0;
        rd_sel = 4'b0;
        for(i = 0; i < 4; i = i + 1)
        begin
            #1 rd_sel = rd_sel + 1;
        end

        // Instructions execution
        for(i = 0; i < 2; i = i + 1)
        begin
            #10 ins = mdr;
            op = ins[12:9];
            case(op)
                4'b0000:
                begin
                    rd_sel = ins[8:6];
                    #30
                    a = out;
                    #30
                    rd_sel = ins[5:3];
                    #30;
                    b = out;
                    #30;
                    func = 3'b000;
                    #30
                    wr_en = 1;
                    #30
                    wr_sel = ins[2:0];
                    #30
                    in = c;
                    #30;
                    wr_en = 0;
                    rd_sel = wr_sel;
                end
                4'b1000:
                begin
                    rd_sel = ins[8:6];
                    #30
                    a = out;
                    #30
                    b = ins[2:0];
                    #30;
                    func = 3'b000;
                    #30
                    wr_en = 1;
                    #30
                    wr_sel = ins[5:3];
                    #30
                    in = c;
                    #30;
                    wr_en = 0;
                    rd_sel = wr_sel;
                end
                default:;//
            endcase
            mar = mar + 1;
        end
        #10 $finish;
    end


endmodule