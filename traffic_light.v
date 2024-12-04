module traffic_light(
    input clk,                     // Clock signal
    input rst,                     // Reset signal
    input change,                  // Change signal
    output reg [1:0] light         // Traffic light output
);

reg [1:0] current_state, next_state;

parameter 
    RED = 2'b00,
    YELLOW = 2'b01,
    GREEN = 2'b10;

initial begin
    current_state = RED;
    next_state = GREEN;
    light = 0;
end

// State Transition
always @(posedge rst or negedge rst or posedge change or negedge change) begin
    if (rst) begin
        current_state <= RED;         // Reset to RED state
    end
    else if (change) begin
        current_state <= next_state;  // Move to the next state
    end
end

// Next State Logic
always @(*) begin
    case (current_state)
        RED:    next_state = GREEN;
        GREEN:  next_state = YELLOW;
        YELLOW: next_state = RED;
        default: next_state = RED;
    endcase
end

// Output Logic
always @(*) begin
    case (current_state)
        RED:     light = RED;     // Red light ON
        GREEN:   light = GREEN;   // Green light ON
        YELLOW:  light = YELLOW;  // Yellow light ON
        default: light = RED;    // Default to RED for safety
    endcase
end

endmodule