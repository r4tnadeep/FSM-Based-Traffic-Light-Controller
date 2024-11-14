
`timescale 1ns / 1ps

module sig_control_tb;

    reg clock;
    reg clear;
    reg x;
    wire [1:0] hwy;   // Highway signal
    wire [1:0] cntry; // Country road signal

    // Instantiate the DUT (Device Under Test)
    sig_control uut (
        .hwy(hwy),
        .cntry(cntry),
        .x(x),
        .clock(clock),
        .clear(clear)
    );

    // Clock generation: 50 MHz -> Period = 20 ns
    always begin
        #10 clock = ~clock;  // Toggle clock every 10 ns
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        clock = 0;
        clear = 0;
        x = 0;

        // Apply asynchronous reset
        #5 clear = 1;  // Assert clear
        #15 clear = 0; // Deassert clear, FSM starts at s0 (highway green)

        // Test 1: No car on country road (x = 0)
        #50; // Observe the state, FSM should stay in s0 (highway green)

        // Test 2: Car arrives on country road (x = 1)
        x = 1;
        #50; // After 50 ns, FSM should transition to s1 (highway yellow)

        // Test 3: Transition from yellow to red (Y2Rdelay)
        #30; // After Y2Rdelay (yellow to red delay), FSM should transition to s2 (both red)

        // Test 4: Transition from red to green for country road (R2Gdelay)
        #20; // After R2Gdelay, FSM should transition to s3 (country green)

        // Test 5: Car stays on country road, FSM remains in s3 (country green)
        #50; 

        // Test 6: Car leaves country road (x = 0)
        x = 0;
        #30; // After car leaves, FSM should transition to s4 (country yellow)

        // Test 7: Country yellow to highway green
        #30; // After the yellow light, FSM should transition back to s0 (highway green)

        // Test 8: Reassert clear during operation
        #50 clear = 1;  // Assert clear in the middle of the cycle
        #15 clear = 0;  // Deassert clear, FSM should reset to s0 (highway green)

        // Test 9: Car arrives again while in highway green (x = 1)
        #50 x = 1;
        #100; // Let the FSM go through the entire cycle: s0 -> s1 -> s2 -> s3 -> s4 -> s0

        // Test 10: Multiple cycles to check repeated state transitions
        x = 0; // FSM should return to s0 (highway green)
        #100 x = 1; // Repeat the cycle, FSM should go through s1 -> s2 -> s3 -> s4 -> s0

        // Finish the simulation
        #300 $finish;
    end

    

endmodule
