module trafficLightController(
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input [3:0] sensor_1th,     // Sensors to select active traffic light
    input [3:0] sensor_5th,     // Sensors to extend green duration
    output reg [1:0] Light_north ,Light_south,Light_east,Light_west
);

    // Timing Parameters
    parameter DEFAULT_GREEN_TIME = 4'd9;
    parameter EXTENDED_GREEN_TIME = 5'd18;
    parameter YELLOW_TIME = 4'd2;
    parameter RED_TIME = 4'd2;

    // State Parameters
    parameter ALL_RED = 4'b0000,
              TLNG = 4'b0001,
              TLEG = 4'b0010,
              TLSG = 4'b0100,
              TLWG = 4'b1000,
              TLNY = 4'b1001,
              TLEY = 4'b1010,
              TLSY = 4'b1011,
              TLWY = 4'b1100;

    reg [3:0] current_state, next_state; // Current and next state
    reg [4:0] timer; // Timer for light durations

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= ALL_RED;
            timer <= 4'd0;
             //{Light_north,Light_east,Light_south,Light_west} = 8'b00000000; // All lights off
        end else if (timer == 0) begin
            current_state <= next_state;
            case (next_state)
                TLNG: timer <= (sensor_1th[0] & sensor_5th[0]) ? EXTENDED_GREEN_TIME : DEFAULT_GREEN_TIME;
                TLEG: timer <= (sensor_1th[1] & sensor_5th[1]) ? EXTENDED_GREEN_TIME : DEFAULT_GREEN_TIME;
                TLSG: timer <= (sensor_1th[2] & sensor_5th[2]) ? EXTENDED_GREEN_TIME : DEFAULT_GREEN_TIME;
                TLWG: timer <= (sensor_1th[3] & sensor_5th[3]) ? EXTENDED_GREEN_TIME : DEFAULT_GREEN_TIME;
                TLNY, TLEY, TLSY, TLWY: timer <= YELLOW_TIME;
                ALL_RED: timer <= RED_TIME;
            endcase
        end else begin
            timer <= timer - 1; // Decrement timer
        end
    end

    // Next state logic for fair rotation
    always @(*) begin
        case (current_state)
            ALL_RED: begin
                if (sensor_1th[0]) next_state = TLNG;
                else if (sensor_1th[1]) next_state = TLEG;
                else if (sensor_1th[2]) next_state = TLSG;
                else if (sensor_1th[3]) next_state = TLWG;
                else next_state = TLNG; // Default start
            end

            // Green to Yellow transitions
            TLNG: next_state = TLNY;
            TLEG: next_state = TLEY;
            TLSG: next_state = TLSY;
            TLWG: next_state = TLWY;

            // Yellow to next Green transitions
            TLNY: next_state = TLEG;
            TLEY: next_state = TLSG;
            TLSY: next_state = TLWG;
            TLWY: next_state = TLNG;

            default: next_state = ALL_RED; // Safety fallback
        endcase
    end

    // Traffic light outputs
    always @(*) begin
        case (current_state)
            TLNG: {Light_north,Light_east,Light_south,Light_west} = 8'b10000000; // North green
            TLEG: {Light_north,Light_east,Light_south,Light_west} = 8'b00100000; // South green
            TLSG: {Light_north,Light_east,Light_south,Light_west} = 8'b00001000; // East green
            TLWG: {Light_north,Light_east,Light_south,Light_west} = 8'b00000010; // West green
            TLNY: {Light_north,Light_east,Light_south,Light_west} = 8'b01000000; // North yellow
            TLEY: {Light_north,Light_east,Light_south,Light_west} = 8'b00010000; // South yellow
            TLSY: {Light_north,Light_east,Light_south,Light_west} = 8'b00000100; // East yellow
            TLWY: {Light_north,Light_east,Light_south,Light_west} = 8'b00000001; // West yellow
            default: {Light_north,Light_east,Light_south,Light_west} = 8'b00000000; // All red
        endcase
    end

endmodule