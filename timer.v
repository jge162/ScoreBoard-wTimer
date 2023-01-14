`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// school: CSUF
// Engineers: Jeremy, Duy, Spencer
// 
// Create Date: 11/16/2021 07:26:26 PM
// Design Name: Basket ball score board
// Module Name: timer, scoreboard
// Project Name: 446 final project
// Target Devices: FPGA Nexys A7
//
// Additional Comments: group project
// 
//////////////////////////////////////////////////////////////////////////////////

module Seven_segment_LED_Display_Controller(
    input clock, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input reset_points, // reset game score
    input reset_score,  //reset time clock
    input team, //input to switch between teams
    input one_point, //input to increment 1 point
    input two_point, //input to increment 2 points
    input three_point,//input to increment 2 points
    input pause,  //pause timer
    output reg [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    wire slow_clock; //clock divider wire here
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;        // one second enable for counting numbers
    reg [15:0] displayed_number;   // counting number to be displayed
    reg [7:0] team_1; //used to store teams score
    reg [7:0] team_2; //used to store teams score
    reg [7:0] LED_BCD;//used to out put scores and timer
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
    wire [2:0] LED_activating_counter;  //3 bits
    reg [5:0] seconds;   // 00:ss
    reg [5:0] minutes;   // mm:00

    clock_divider DUT (.clk(clock),.reset(reset), .sclk(slow_clock)); 

    always @(posedge clock or negedge reset)
    begin
        if(reset==0)
            one_second_counter <= 0;
        else if (pause)
            displayed_number = displayed_number; 
        else begin
            if(one_second_counter>=99999999) 
            one_second_counter <= 0;
            else
            one_second_counter <= one_second_counter + 1;
        end
    end 
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    
    always @(posedge clock)
    begin
    
     if(reset_score) begin //reset score here
            minutes <= 12; 
            seconds <= 00;//default to 12:00 min once enabled
        end                         
        else if (one_second_enable == 1)
                 seconds <= seconds - 1;//decrement clock
        else if (seconds == 0) begin    //when clock == 0
                 seconds <= 59;         //set value to 59
                 minutes <= minutes - 1;//decrement mm
        end 
        else if (pause)                 //pause clock
            seconds=seconds;  
        else if ( minutes ==0)//reset MM:00 to 11 for wrap
            minutes <= 11; 
            
        end
   
    always @(posedge clock or negedge reset)
    begin 
        if  (reset==0)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    
    assign LED_activating_counter = refresh_counter[19:17];//used 3 instead of 19:18
    // anode activating signals for 8 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        3'b000: begin
            Anode_Activate = 8'b11111110; 
            // activate LED1 and Deactivate LED2, LED3, LED4, LED5, LED6, LED7, LED8
             LED_BCD = minutes / 10;//10s place
            // the first digit of the 16-bit number
              end
        3'b001: begin
            Anode_Activate = 8'b11111101; 
            // activate LED2 and Deactivate LED1, LED3, LED4, LED5, LED6, LED7, LED8
            LED_BCD = minutes % 10;//1s place
            // the second digit of the 16-bit number
              end
        3'b010: begin
            Anode_Activate = 8'b11111011; 
            // activate LED3 and Deactivate LED2, LED1, LED4, LED5, LED6, LED7, LED8
             LED_BCD = seconds / 10;//10s place
            // the third digit of the 16-bit number
                end
        3'b011: begin
            Anode_Activate = 8'b11110111; 
            // activate LED4 and Deactivate LED2, LED3, LED1, LED5, LED6, LED7, LED8
             LED_BCD = seconds % 10;//1s place
            // the fourth digit of the 16-bit number    
               end
        3'b100: begin
            Anode_Activate = 8'b11101111; 
            // activate LED5 and Deactivate LED2, LED3, LED4, LED5, LED1, LED7, LED8
                LED_BCD = (team_2 / 10);//10s place
            // the first digit of the 16-bit number
              end
        3'b101: begin
            Anode_Activate = 8'b11011111; 
            // activate LED6 and Deactivate LED1, LED3, LED4, LED5, LED2, LED7, LED8
                LED_BCD = (team_2 % 10);//1s place
            // the second digit of the 16-bit number
              end
        3'b110: begin
            Anode_Activate = 8'b10111111; 
            // activate LED7 and Deactivate LED2, LED1, LED4, LED5, LED6, LED3, LED8
                LED_BCD = (team_1 / 10);
            // the third digit of the 16-bit number
                end
        3'b111: begin
            Anode_Activate = 8'b01111111; 
            // activate LED8 and Deactivate LED2, LED3, LED1, LED5, LED6, LED7, LED4
                LED_BCD = (team_1 % 10);
            // the fourth digit of the 16-bit number    
               end
        endcase
    end   
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
       0: LED_out = 7'b0000001; // "0"     
       1: LED_out = 7'b1001111; // "1" 
       2: LED_out = 7'b0010010; // "2" 
       3: LED_out = 7'b0000110; // "3" 
       4: LED_out = 7'b1001100; // "4" 
       5: LED_out = 7'b0100100; // "5" 
       6: LED_out = 7'b0100000; // "6" 
       7: LED_out = 7'b0001111; // "7" 
       8: LED_out = 7'b0000000; // "8"     
       9: LED_out = 7'b0000100; // "9" 
       default: LED_out = 7'b0000001; // "0"
        endcase
    end
    
always @(posedge slow_clock)
begin
    if(reset_points) begin //reset team scores here
        team_1 = 7'b0000000; //set values to zero
        team_2 = 7'b0000000;
        end
        
       if (one_point)  
        begin //if button pressed for one point increment by 1
        if(team)
            team_1 = team_1 + 2'b01;
            else
            team_2 = team_2 + 2'b01;
        end //if button pressed for two points increment by 2
        else if (two_point) begin
            if(team)
            team_1 = team_1 + 2'b10;
            else
            team_2 = team_2 + 2'b10;
        end //if button pressed for three points increment by 3
        else if (three_point) begin
            if(team)
            team_1 <= team_1 + 2'b11;
            else
            team_2 <= team_2 + 2'b11;
        end

        if(team_1 >= 7'b1100100)//reset score board at 100
            team_1 = 7'b0000000;//back to zero

        if(team_2 >= 7'b1100100)//reset score board at 100
            team_2 = 7'b0000000;//back to zero
    end
endmodule
