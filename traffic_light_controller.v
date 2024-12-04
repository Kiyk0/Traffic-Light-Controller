module traffic_light_controller(
    input clk,                  // Clock signal
    input [3:0] sensor_1th,     // Sensor at the 1st position
    input [3:0] sensor_5th,     // Sensor at the 5th position

    output reg [1:0] turn,
    output reg [3:0] rst,
    output reg [7:0] state,
    output reg [7:0] count,
    output reg [3:0] change,
    output reg load,
    output reg [7:0] load_value,
    output reg north,
    output reg east,
    output reg south,
    output reg west,

    output reg [7:0] light_led      // Traffic light output
);

// reg [3:0] rst;
// reg [7:0] state;
// reg [7:0] count;
// reg [3:0] change;
// reg load;
// reg [7:0] load_value;
// reg [3:0] current_state, next_state; // Current and next states
// reg [1:0] turn;
wire [7:0] light;

parameter
    NORTH2 = 10'b00_xxx1_xxx1,
    EAST2  = 10'b01_xx1x_xx1x,
    SOUTH2 = 10'b10_x1xx_x1xx,
    WEST2  = 10'b11_1xxx_1xxx,
    NORTH1 = 10'b00_0000_xxx1,
    EAST1  = 10'b01_0000_xx1x,
    SOUTH1 = 10'b10_0000_x1xx,
    WEST1  = 10'b11_0000_1xxx,
    NORTH0 = 10'b00_xxxx_xxxx,
    EAST0  = 10'b01_xxxx_xxxx,
    SOUTH0 = 10'b10_xxxx_xxxx,
    WEST0  = 10'b11_xxxx_xxxx,
    north_trafficlight = 4'b0001,
    east_trafficlight = 4'b0010,
    south_trafficlight = 4'b0100,
    west_trafficlight = 4'b1000;

traffic_light north_light(
    .clk(clk), .rst(rst[0]), .change(change[0]), .light(light[1:0])
);

traffic_light east_light(
    .clk(clk), .rst(rst[1]), .change(change[1]), .light(light[3:2])
);

traffic_light south_light(
    .clk(clk), .rst(rst[2]), .change(change[2]), .light(light[5:4])
);

traffic_light west_light(
    .clk(clk), .rst(rst[3]), .change(change[3]), .light(light[7:6])
);

initial begin
    rst = 4'b1111;
    change = 0;
    load = 0;
    count = 10;
    turn = 0;
    north = 0;
    east = 0;
    south = 0;
    west = 0;
end

always @(posedge clk or posedge load) begin 
    if (load) begin
        count <= load_value;
        load = 0;
    end
    else if (count != 0) count <= count - 1;
    light_led <= light;
end

always @(posedge clk) begin
    change = 0;
    if (north && count == 10) begin 
        change[0] = 1;
        north = 0;
        turn = turn + 1;        
    end
    else if (east && count == 10) begin 
        change[1] = 1;
        east = 0;
        turn = turn + 1;      
    end
    else if (south && count == 10) begin 
        change[2] = 1;
        south = 0;
        turn = turn + 1;  
    end
    else if (west && count == 10) begin 
        change[3] = 1;
        west = 0;
        turn = turn + 1;
    end
    light_led <= light;
end


always @(posedge clk) begin
    state <= {sensor_5th, sensor_1th};
    if (count == 0) begin
        casex ({turn, state})
            NORTH2: begin
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                north = 1;
                load_value = 7'd60; //time
            end
            EAST2: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                east = 1;
                load_value = 7'd60; //time
            end
            SOUTH2: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                south = 1;
                load_value = 7'd60; //time
            end
            WEST2: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                west = 1;
                load_value = 7'd60; //time
            end
            NORTH1: begin 
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                north = 1;
                load_value = 7'd40; //time
            end
            EAST1: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                east = 1;
                load_value = 7'd40; //time
            end
            SOUTH1: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                south = 1;
                load_value = 7'd40; //time
            end
            WEST1: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                west = 1;
                load_value = 7'd40; //times
            end
            NORTH0: begin 
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                north = 1;
                load_value = 7'd20; //time
            end
            EAST0: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                east = 1;
                load_value = 7'd20; //time
            end
            SOUTH0: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                south = 1;
                load_value = 7'd20; //time
            end
            WEST0: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                west = 1;
                load_value = 7'd20; //times
            end
            default: rst <= 4'b1111;
        endcase
        light_led <= light;
    end
end

endmodule