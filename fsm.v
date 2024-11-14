`define Y2Rdelay 3  // Delay from yellow to red
`define R2Gdelay 2  // Delay from red to green

module sig_control (
    output reg [1:0] hwy,   // Highway signal: 2-bit to represent red, yellow, green
    output reg [1:0] cntry, // Country road signal: 2-bit to represent red, yellow, green
    input wire x,           // Sensor input
    input wire clock,       // Clock input
    input wire clear        // Asynchronous clear signal
);

    // Traffic light colors
    parameter red    = 2'b01;
    parameter yellow = 2'b10;
    parameter green  = 2'b11;

    // FSM states
    parameter s0 = 3'd0,  // Highway green, country red
              s1 = 3'd1,  // Highway yellow, country red
              s2 = 3'd2,  // Both red
              s3 = 3'd3,  // Highway red, country green
              s4 = 3'd4;  // Highway red, country yellow

    reg [2:0] state, nxt_state;  // State registers

    // Synchronous state update
    always @(posedge clock or posedge clear) begin
        if (clear)
            state <= s0;  // Reset to initial state
        else
            state <= nxt_state;  // Update to next state
    end

    // Traffic light output logic
    always @(*) begin
        case (state)
            s0: begin
                hwy = green; cntry = red;
            end
            s1: begin
                hwy = yellow; cntry = red;
            end
            s2: begin
                hwy = red; cntry = red;
            end
            s3: begin
                hwy = red; cntry = green;
            end
            s4: begin
                hwy = red; cntry = yellow;
            end
        endcase
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            s0: nxt_state = x ? s1 : s0;  // Transition to yellow if sensor active
            s1: nxt_state = s2;           // Move to red after yellow
            s2: nxt_state = s3;           // Move to country green
            s3: nxt_state = x ? s3 : s4;  // Stay green until no sensor input
            s4: nxt_state = s0;           // Return to highway green
        endcase
    end

endmodule
