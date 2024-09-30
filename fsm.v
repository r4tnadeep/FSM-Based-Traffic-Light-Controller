`define true  1'b1
`define false 1'b0
`define Y2Rdelay 3  // Delay from yellow to red
`define R2Gdelay 2  // Delay from red to green

module sig_control (
    output reg [1:0] hwy,    // Highway signal: 2-bit to represent red, yellow, green
    output reg [1:0] cntry,  // Country road signal: 2-bit to represent red, yellow, green
    input wire x,            // Sensor input
    input wire clock,        // Clock input
    input wire clear         // Asynchronous clear signal
);

    // State encoding for traffic lights (red = 1, yellow = 2, green = 3)
    parameter red    = 2'b01;
    parameter yellow = 2'b10;
    parameter green  = 2'b11;

    // State encoding for the FSM
    parameter s0 = 3'd0;  // Highway green, country red
    parameter s1 = 3'd1;  // Highway yellow, country red
    parameter s2 = 3'd2;  // Highway red, country red (transition state)
    parameter s3 = 3'd3;  // Highway red, country green
    parameter s4 = 3'd4;  // Highway red, country yellow

    reg [2:0] state;      // Current state
    reg [2:0] nxt_state;  // Next state

    // Synchronous state update
    always @(posedge clock or posedge clear) begin
        if (clear)
            state <= s0;  // Reset to initial state
        else
            state <= nxt_state;  // Move to next state
    end

    // Output logic based on current state
    always @(state) begin
        case (state)
            s0: begin
                hwy = green;    // Highway is green
                cntry = red;    // Country road is red
            end
            s1: begin
                hwy = yellow;   // Highway is yellow
                cntry = red;    // Country road remains red
            end
            s2: begin
                hwy = red;      // Highway is red
                cntry = red;    // Country road remains red
            end
            s3: begin
                hwy = red;      // Highway is red
                cntry = green;  // Country road is green
            end
            s4: begin
                hwy = red;      // Highway is red
                cntry = yellow; // Country road is yellow
            end
        endcase
    end

    // Next state logic based on current state and sensor input
    always @(state or x) begin
        case (state)
            s0: if (x == `true)
                    nxt_state = s1;
                else
                    nxt_state = s0;

            s1: nxt_state = s2;  // Move to transition state after Y2Rdelay

            s2: nxt_state = s3;  // Move to country green after R2Gdelay

            s3: if (x == `false)
                    nxt_state = s4;  // Transition back when country road is done
                else
                    nxt_state = s3;

            s4: nxt_state = s0;  // Move back to highway green
        endcase
