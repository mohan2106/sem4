`timescale 1ns / 1ns
module RAM_test_bench();
    reg clk;
    reg [15:0] data_in;
    reg wr_en;
    reg rd_en;
    reg [3:0] address;
    wire [15:0] data_out;

    RAM x(.clk(clk), .data_in(data_in), .wr_en(wr_en), .rd_en(rd_en), .address(address), .data_out(data_out));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, x);
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial
    begin
        $monitor("time = %3d, data_in = %d, data_out = %d, address = %d\n", $time, data_in, data_out, address);
    end

    initial
    begin
        #2
        #10 wr_en = 1; address = 2; data_in = 5;
        #1 wr_en = 0; rd_en = 1;
        #1 wr_en = 1; rd_en = 0;
        #10 wr_en = 0; rd_en = 1; address = 2;
        #10 address = 5;
        #10 rd_en = 0; wr_en = 1; data_in = 2;
        #10 wr_en = 0; rd_en = 1; address = 0;
        #10 address = 2;
        #10 address = 5;
        #10 $finish;
    end
    
endmodule