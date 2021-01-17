`timescale 1ns / 1ns
module RAM(clk, data_in, wr_en, rd_en, address, data_out);
    input clk;
    input [15:0] data_in;
    input wr_en;
    input rd_en;
    input [3:0] address;
    output reg [15:0] data_out;

    reg [15:0] memory [15:0];
    integer i, j;
    
    initial
    begin
        for(i = 0; i < 16; i = i + 1)
            memory[i] <= 16'b0;
        memory[0] <= 770;
        memory[1] <= 1029; 
        // INSTRUCTIONS:
        memory[2] <= 16'b000_0000_001_010_101;
        memory[3] <= 16'b000_1000_011_110_111;

    end

    always @(posedge clk)
    begin
        if(wr_en)
            memory[address] <= data_in;
    end

    always @(*)
    begin
        if(rd_en)
            data_out <= memory[address];
    end
endmodule