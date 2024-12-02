`timescale 1ns / 1ps

module trafficLightController_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] sensor_1th;
    reg [3:0] sensor_5th;
    wire [7:0] lightOfTrafficLights;

    // Instantiate the trafficLightController
    trafficLightController uut (
        .clk(clk),
        .rst(rst),
        .sensor_1th(sensor_1th),
        .sensor_5th(sensor_5th),
        .lightOfTrafficLights(lightOfTrafficLights)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test scenarios
    initial begin
        $monitor(
            "Time: %0t | rst: %b | sensor_1th: %b | sensor_5th: %b | lightOfTrafficLights: %b | current_state: %b | next_state: %b | draft1: %b | draft2: %b | TLNO: %b | TLSO: %b | TLEO: %b | TLWO: %b | TLNS: %b | TLSS: %b | TLES: %b | TLWS: %b",
            $time, rst, sensor_1th, sensor_5th, lightOfTrafficLights,
            uut.current_state, uut.next_state, uut.draft1, uut.draft2,
            uut.TLNO, uut.TLSO, uut.TLEO, uut.TLWO,
            uut.TLNS, uut.TLSS, uut.TLES, uut.TLWS
        );

        // Initial reset
        rst = 1;
        sensor_1th = 4'b0000;
        sensor_5th = 4'b0000;
        #20;
        rst = 0;

        // Test case 1: Simulate no sensors active
        sensor_1th = 4'b0000;
        sensor_5th = 4'b0000;
        #200;

        // Test case 2: Activate some sensors
        sensor_1th = 4'b0001;
        sensor_5th = 4'b0001;
        #200;

        // Test case 3: Change sensor input patterns
        sensor_1th = 4'b1100;
        sensor_5th = 4'b1010;
        #200;

        // Test case 4: Random sensor activation
        sensor_1th = 4'b1111;
        sensor_5th = 4'b0000;
        #200;

        // Test case 5: Deactivate all sensors
        sensor_1th = 4'b0000;
        sensor_5th = 4'b0000;
        #200;

        // Test case 6: Reset the system during operation
        rst = 1;
        #20;
        rst = 0;

        // End simulation
        $finish;
    end

endmodule
