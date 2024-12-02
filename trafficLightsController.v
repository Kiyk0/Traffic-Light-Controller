module trafficLightController(
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input [3:0] sensor_1th,     // Sensors at the 1st position
    input [3:0] sensor_5th,     // Sensors at the 5th position
    output reg [7:0] lightOfTrafficLights // Traffic light output
);
    // Traffic light outputs
    wire [1:0] TLNO, TLSO, TLEO, TLWO;
    reg [1:0] TLNS, TLSS, TLES, TLWS;
    reg [3:0] draft1, draft2;

    // State parameters
    parameter RED = 2'b00,
              YELLOW = 2'b01,
              GREEN = 2'b10;
              
    parameter TL1 = 4'b0001,
              TL2 = 4'b0010,
              TL3 = 4'b0100,
              TL4 = 4'b1000;

    reg [3:0] current_state, next_state; // Current and next states

    // Initialization
    initial begin
     //   TLNO = 0; TLSO = 0; TLEO = 0; TLWO = 0;
        TLNS = 0; TLSS = 0; TLES = 0; TLWS = 0;
        current_state = TL1;
    end

    // State transition and reset logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
           // TLNO <= 0; TLSO <= 0; TLEO <= 0; TLWO <= 0;
            TLNS <= 0; TLSS <= 0; TLES <= 0; TLWS <= 0;
            current_state <= TL1;
        end else if (lightOfTrafficLights == 8'b00000000) begin
            current_state <= next_state;
            draft2 <= sensor_1th & sensor_5th; 
        draft1 <= sensor_1th;
        end
    end

    // Next state logic
    always @(*) begin
                if(lightOfTrafficLights == 8'b00000000)begin

        case (current_state)
            TL1: next_state <= TL2;
            TL2: next_state <= TL3;
            TL3: next_state <= TL4;
            default: next_state <= TL1;
        endcase end
    end

    // Traffic light control logic
     always @(*) begin

        
        case (current_state)
            TL1: {TLWS, TLES, TLSS, TLNS} <= {6'b000000, draft2[0], draft1[0]};
            TL2: {TLWS, TLES, TLSS, TLNS} <= {4'b0000, draft2[1], draft1[1], 2'b00};
            TL3: {TLWS, TLES, TLSS, TLNS} <= {2'b00, draft2[2], draft1[2], 4'b0000};
            TL4: {TLWS, TLES, TLSS, TLNS} <= {draft2[3], draft1[3], 6'b000000};
            default: {TLWS, TLES, TLSS, TLNS} <= 8'b0;
        endcase 
    end

    // Instantiate individual traffic light modules
    trafficLight TLN(
        .clk(clk),
        .rst(rst),
        .sensor_1th(TLNS[0]),
        .sensor_5th(TLNS[1]),
        .light(TLNO)
    );

    trafficLight TLS(
        .clk(clk),
        .rst(rst),
        .sensor_1th(TLSS[0]),
        .sensor_5th(TLSS[1]),
        .light(TLSO)
    );

    trafficLight TLE(
        .clk(clk),
        .rst(rst),
        .sensor_1th(TLES[0]),
        .sensor_5th(TLES[1]),
        .light(TLEO)
    );

    trafficLight TLW (
        .clk(clk),
        .rst(rst),
        .sensor_1th(TLWS[0]),
        .sensor_5th(TLWS[1]),
        .light(TLWO)
    );
    // Combine lights into output
    always @(*) begin
        lightOfTrafficLights <= {TLWO, TLEO, TLSO, TLNO};
    end

endmodule
