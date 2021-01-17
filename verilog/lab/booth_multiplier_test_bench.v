`timescale 1ns / 1ns
module booth_multiplier_test_bench();
    reg signed [3:0] m;
    reg signed [3:0] r;
    wire signed [7:0] out;

    booth_multiplier x(.m(m), .r(r), .out(out));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, x);
    end

    initial
    begin
        $monitor("time = %3d, m = %d, r = %d, p = %d\n", $time, m, r, out);
    end

    initial
    begin
        #10 m = 3;
        r = 4;
        #10 m = 2;
        r = -1;
        #10 m = 3;
        r = -5;
        #10 m = -5;
        r = -7;
        #10 $finish;
    end
    
endmodule