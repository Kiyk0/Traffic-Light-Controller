`timescale 1s/1ms

module trafficLightController_tb;
    // Inputs
    reg clk;
    reg rst;
    reg [3:0] sensor_1th;
    reg [3:0] sensor_5th;

    // Outputs
    wire [1:0] Light_north ,Light_south,Light_east,Light_west;

    // Instantiate the trafficLightController module
    trafficLightController uut (
        .clk(clk),
        .rst(rst),
        .sensor_1th(sensor_1th),
        .sensor_5th(sensor_5th),
        .Light_north(Light_north),
        .Light_east(Light_east),
        .Light_west(Light_west),
        .Light_south(Light_south)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #2.5 clk = ~clk; // Clock with 10-time unit period
    end

    // Test sequence
    initial begin
        // Monitor changes
        $monitor("Time=%0d | rst=%b | sensor_1th=%b | sensor_5th=%b | Light_north=%b | Light_south=%b | Light_east=%b | Light_west=%b |", $time, rst, sensor_1th, sensor_5th, Light_north ,Light_south,Light_east,Light_west);

        
        // Test case 1: No sensors active
        rst = 1; sensor_1th = 4'b0000; sensor_5th = 4'b0000;
        #100 rst = 0;

        // Test case 2: North light active
        #200 sensor_1th = 4'b0001; sensor_5th = 4'b0000;

        // Test case 3: North light extended green
        #200 sensor_1th = 4'b0001; sensor_5th = 4'b0001;

        // Test case 4: South light active
        #400 sensor_1th = 4'b0011; sensor_5th = 4'b0000;

        // Test case 5: South light extended green
        #400 sensor_1th = 4'b1100; sensor_5th = 4'b1010;

        // Test case 6: Multiple sensors active (priority North)
        #400 sensor_1th = 4'b1011; sensor_5th = 4'b1011;

        // Test case 7: Reset the module
        #700 rst = 1; #10 rst = 0;

        #100 $finish; // End simulation
    end
endmodule