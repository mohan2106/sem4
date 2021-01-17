`timescale 1ns / 1ns
module ALU_test_bench();
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] func;
    wire [7:0] c;

    ALU x(.a(a), .b(b), .func(func), .c(c));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, x);
    end

    initial
    begin
        $monitor("time = %3d, a = %d, b = %d, func = %d, c = %d\n", $time, a, b, func, c);
    end

    initial
    begin
        #2
        #10 a = 10; b = 3; func = 0;
        #10 a = 4; b = 2; func = 1;
        #10 $finish;
    end
endmodule