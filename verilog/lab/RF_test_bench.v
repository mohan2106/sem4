`timescale 1ns / 1ns
module RF_test_bench();
    reg clk;
    reg reset;
    reg [3:0] rd_sel;
    reg [3:0] wr_sel;
    reg wr_en;
    reg [7:0] data_in;
    wire [7:0] data_out;

    RF x(.clk(clk), .reset(reset), .rd_sel(rd_sel), .wr_sel(wr_sel), .wr_en(wr_en), .data_in(data_in), .data_out(data_out));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, x);
        clk = 1'b0;
        reset = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial
    begin
        $monitor("time = %3d, data_in = %d, data_out = %d, rd_sel = %d, wr_sel = %d\n", $time, data_in, data_out, rd_sel, wr_sel);
    end

    initial
    begin
        #2
        #10 reset = 1;
        #10 rd_sel = 4;
        #10 wr_en = 1; wr_sel = 5; data_in = 9;
        #10 rd_sel = 5;
        #10 reset = 0;
        #10 wr_sel = 1; data_in = 2;
        #10 rd_sel = 2; wr_sel = 2; data_in = 6;
        #10 rd_sel = 2;
        #10 wr_sel = 5; data_in = 10;
        #10 wr_en = 0;
        #10 rd_sel = 5;
        #10 $finish;
    end
    
endmodule