module trafficLight(
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    input sensor_1th,          // Sensor at the 1st position
    input sensor_5th,          // Sensor at the 5th position
    output reg [1:0] light     // Traffic light output
);

    // Define states using parameters
    parameter RED = 2'b00,
              YELLOW = 2'b01,
              GREEN = 2'b10;

    reg [1:0] current_state, next_state; // Current and next state

    // Initialize the counter
    initial begin

        current_state<=RED;
        next_state <= sensor_1th ? GREEN : RED;
    end

    // State Transition and Counter Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= RED;        // Reset to RED state
            next_state <= sensor_1th ? GREEN : RED;
        end else begin
           
                current_state <= next_state; // Move to the next state
            
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            RED:    next_state <= sensor_1th ? GREEN : RED;
            GREEN:  next_state <= YELLOW;
            YELLOW: next_state <= RED;
            default: next_state <= RED;
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            RED:    light <= RED;   // Red light ON
            GREEN:  light <= GREEN; // Green light ON
            YELLOW: light <= YELLOW; // Yellow light ON
            default: light <= RED;  // Default to RED for safety
        endcase
    end

endmodule
