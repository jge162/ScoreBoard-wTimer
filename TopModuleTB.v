module Seven_segment_LED_Display_Controller_TB();

    // Inputs
    reg clock = 0;
    reg reset = 1;
    reg reset_points = 0;
    reg reset_score = 0;
    reg team = 0;
    reg one_point = 0;
    reg two_point = 0;
    reg three_point = 0;
    reg pause = 0;

    // Outputs
    wire [7:0] Anode_Activate;
    wire [6:0] LED_out;

    // Instantiate the UUT
    Seven_segment_LED_Display_Controller uut (
        .clock(clock),
        .reset(reset),
        .reset_points(reset_points),
        .reset_score(reset_score),
        .team(team),
        .one_point(one_point),
        .two_point(two_point),
        .three_point(three_point),
        .pause(pause),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    );

    // Clock generator
    always #5 clock = ~clock;

    // Testbench
    initial begin

        // Reset
        reset = 0;
        #10;
        reset = 1;
        #10;

        // Enable clock
        pause = 0;

        // Test case 1: increment team 1 score by one point
        one_point = 1;
        #100;
        one_point = 0;
        #100;
        $display("Team 1 score: %d", Anode_Activate);
        assert(Anode_Activate == 0); // Expected output for team 1 score of 1

        // Test case 2: increment team 1 score by two points
        two_point = 1;
        #100;
        two_point = 0;
        #100;
        $display("Team 1 score: %d", Anode_Activate);
        assert(Anode_Activate == 4); // Expected output for team 1 score of 3

        // Test case 3: increment team 2 score by three points
        team = 1;
        three_point = 1;
        #100;
        three_point = 0;
        #100;
        $display("Team 2 score: %d", Anode_Activate);
        assert(Anode_Activate == 3); // Expected output for team 2 score of 3

        // Test case 4: reset team scores
        reset_points = 1;
        #100;
        reset_points = 0;
        #100;
        $display("Team 1 score: %d", Anode_Activate);
        $display("Team 2 score: %d", LED_out);
        assert(Anode_Activate == 0 && LED_out == 0); // Expected output for team scores of 0

        // Test case 5: reset timer
        reset_score = 1;
        #100;
        reset_score = 0;
        #100;
        $display("Minutes: %d, Seconds: %d", Anode_Activate, LED_out);
        assert(Anode_Activate == 12 && LED_out == 0); // Expected output for timer reset

        // Test case 6: pause timer
        pause = 1;
        #1000;
        $display("Minutes: %d, Seconds: %d", Anode_Activate, LED_out);
        assert(Anode_Activate == 12 && LED_out == 0); // Expected
