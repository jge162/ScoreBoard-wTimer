`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// school: CSUF
// Engineers: Jeremy, Duy, Spencer
// Create Date: 11/16/2021 07:26:26 PM
// Design Name: Basket ball score board
// Module Name: timer, scoreboard
// Project Name: 446 final project
// Target Devices: FPGA Nexys A7
//
// Additional Comments: group project
// 
//////////////////////////////////////////////////////////////////////////////////
   
module clock_divider(
input clk,
input reset,
output reg sclk
);
reg [31:0] count;
always@(posedge clk or negedge reset)
begin
if(reset == 1'b0) begin
    count <= 32'd0;
sclk <= 1'b0;
end else begin
if(count == 32'd9000000) begin
    count <= 32'd0;
sclk <= ~sclk;
end else begin
    count <= count + 1;
end
end
end
endmodule
