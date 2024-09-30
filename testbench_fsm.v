
`timescale 1ns/1ps

module tb_sig_control;
    reg clock;   // Clock signal
    reg clear;   // Asynchronous clear signal
    reg x;       // Sensor input (road activity)

    wire [1:0] hwy;    // Highway signal (2-bit for red, yellow, green)
    wire [1:0] cntry;  // Country road signal (2-bit for red, yellow, green)

    // Instantiate the sig_control module
    sig_control uut (
        .hwy(hwy),
        .cntry(cntry),
        .x(x),
        .clock(clock),
        .clear(clear)
    );

    // Clock generation: toggle every 10ns (period = 20ns)
    always #10 clock = ~clock;

    // Testbench procedure
    initial begin
        // Initialize inputs
        clock = 0;
        clear = 0;
        x = 0;

        // Apply reset
        clear = 1;
        #20;
        clear = 0;

        // Test Scenario 1: No vehicle on country road (x = 0)
        x = 0;
        #100;

        // Test Scenario 2: Vehicle detected on country road (x = 1)
        x = 1;
        #100;

        // Test Scenario 3: No vehicle on country road again (x = 0)
        x = 0;
        #200;

        // End simulation
        #200;
        $finish;
    end
endmodule
