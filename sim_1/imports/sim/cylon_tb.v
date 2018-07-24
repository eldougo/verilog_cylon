`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2018 12:48:36
// Design Name: 
// Module Name: cylon_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define PRESS_BUTTON btnU

module cylon_tb();
  reg clk = 0;
  reg btnC = 0;
  reg btnU = 0;
  reg btnL = 0;
  reg btnR = 0;
  //wire w_pulse_16;
  wire [15:0] w_led;
  
  always #5 clk = !clk;
  
  cylon_top 
  #(
    .CLOCK_CYCLES_PER_PULSE(29'd500),
    .CLOCK_CYCLES_PER_SECOND(29'd500)
  ) cylon_UUT (
    .clk(clk),
    .sw(4'h7),
    .btnC(btnC),
    .btnU(btnU),
    .btnL(btnL),
    .btnR(btnR),
    .led(w_led));
  
  initial begin
    #1000;
    `PRESS_BUTTON = 1'b1;
    #200;
    `PRESS_BUTTON = 1'b0;
  end
  
  initial begin
    #100000 $stop;
  end
endmodule
