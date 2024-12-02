`timescale 1ns / 1ps

module trafficLight_tb;

    // Testbench signals
    reg clk;             // Clock signal
    reg rst;             // Reset signal
    reg sensor_1th;      // Sensor at the 1st position
    reg sensor_5th;      // Sensor at the 5th position
    wire [1:0] light;    // Traffic light output

    // Instantiate the trafficLight module
    trafficLight uut (
        .clk(clk),
        .rst(rst),
        .sensor_1th(sensor_1th),
        .sensor_5th(sensor_5th),
        .light(light)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10ns
    end

    // Test scenarios
    initial begin
        // Display output values during simulation
        $monitor(
            "Time: %0t | rst: %b | sensor_1th: %b | sensor_5th: %b | light: %b",
            $time, rst, sensor_1th, sensor_5th, light
        );

        // Test case 1: Reset the system
        rst = 1;
        sensor_1th = 0;
        sensor_5th = 0;
        #20; // Wait 20ns
        rst = 0;

        // Test case 2: No sensors active (remain in RED state)
        sensor_1th = 0;
        sensor_5th = 0;
        #200; // Wait for the RED state duration

        // Test case 3: Activate sensor_1th (transition to GREEN state)
        sensor_1th = 1;
        sensor_5th = 0;
        #200; // Wait for state transitions

        // Test case 4: sensor_1th active, sensor_5th triggers longer GREEN duration
        sensor_1th = 1;
        sensor_5th = 1;
        #300;

        // Test case 5: Both sensors inactive (return to RED)
        sensor_1th = 0;
        sensor_5th = 0;
        #200;

        // Test case 6: Reset during operation
        rst = 1;
        #20;
        rst = 0;

        // Test case 7: Random sensor inputs
        sensor_1th = 1;
        sensor_5th = 0;
        #100;
        sensor_1th = 0;
        sensor_5th = 1;
        #100;

        // End simulation
        $finish;
    end

endmodule
