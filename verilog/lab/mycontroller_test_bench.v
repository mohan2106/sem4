`timescale 1ns / 1ns
module mycontroller_test_bench();
    reg clk;
    reg reset;
    wire [3:0] mar;
    wire [3:0] rd_sel;
    wire [3:0] wr_sel;
    wire [7:0] out;
    wire [7:0] a;
    wire [7:0] b;
    wire [7:0] c;

    mycontroller x(.clk(clk), .reset(reset), .wr_sel(wr_sel), .mar(mar), .out(out), .rd_sel(rd_sel), .a(a), .b(b), .c(c));

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
        $monitor("time = %3d, wr_sel = %d, rd_sel = %d, mar = %d, out = %d, a = %d, b = %d, c = %d\n", $time, wr_sel, rd_sel, mar, out, a, b, c);
    end
    
endmodule