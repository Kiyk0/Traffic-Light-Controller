module traffic_light_controller(
    input clk,                  // Clock signal
    input [3:0] sensor_1th,     // Sensor at the 1st position
    input [3:0] sensor_5th,     // Sensor at the 5th position
    output reg [7:0] light_led      // Traffic light output
);

reg [3:0] rst;
reg [7:0] state;
reg [7:0] count;
reg [3:0] change;
reg load;
reg [7:0] load_value;
reg [3:0] current_state, next_state; // Current and next states
reg [2:0] i;
reg [2:0] turn;
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
    NORTH0 = 10'b00_0000_0000,
    EAST0  = 10'b01_0000_0000,
    SOUTH0 = 10'b10_0000_0000,
    WEST0  = 10'b11_0000_0000,
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
    change = 4'b0000;
    load = 0;
    count = 0;
end

always @(posedge clk or posedge load) begin 
    if (load) begin
        count <= load_value;
        load = 0;
        current_state <= next_state;
    end
    else if (count != 0) count <= count - 1;
end

always @(posedge clk) begin
    if (count == 0) begin
        if (i == 2'b10) begin 
            i = 2'b00; 
            turn = turn + 1;
        end 
        else i = i + 1;
        state <= {sensor_5th, sensor_1th};
        casex ({turn, state})
            NORTH2: begin
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                load_value = 7'd60; //time
            end
            EAST2: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                load_value = 7'd60; //time
            end
            SOUTH2: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                load_value = 7'd60; //time
            end
            WEST2: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                load_value = 7'd60; //time
            end
            NORTH1: begin 
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                load_value = 7'd30; //time
            end
            EAST1: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                load_value = 7'd30; //time
            end
            SOUTH1: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                load_value = 7'd30; //time
            end
            WEST1: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                load_value = 7'd30; //times
            end
            NORTH0: begin 
                rst <= 4'b1110;
                change[0] = 1;
                load = 1;
                load_value = 7'd15; //time
            end
            EAST0: begin 
                rst <= 4'b1101;
                change[1] = 1;
                load = 1;
                load_value = 7'd15; //time
            end
            SOUTH0: begin 
                rst <= 4'b1011;
                change[2] = 1;
                load = 1;
                load_value = 7'd15; //time
            end
            WEST0: begin 
                rst <= 4'b0111;
                change[3] = 1;
                load = 1;
                load_value = 7'd15; //times
            end
            default: rst <= 4'b1111;
        endcase
        light_led = light;
    end
end

endmodule