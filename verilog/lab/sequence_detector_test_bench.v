`timescale 1ns / 1ns
module sequence_detector_test_bench();
    reg clk, in, rst;
    wire out;
    wire [2:0] state;

    sequence_detector m(.clk(clk), .in(in), .out(out), .state(state), .rst(rst));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, m);

        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial
    begin
        $monitor("time = %3d, state = %d, in = %d, out = %d\n", $time, state, in, out);
    end

    initial
    begin
        rst = 1;
        in = 0;
        #30 rst = 0;
        #10 in = 1;
        #11 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        #10 $finish;
    end
    
endmodule