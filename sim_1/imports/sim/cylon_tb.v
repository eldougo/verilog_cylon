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


module cylon_tb();
  reg clk = 0;
  reg btnC = 0;
  reg btnL = 0;
  reg btnR = 0;
  wire w_pulse_16;
  wire [15:0] w_led;
  
  always #5 clk = !clk;
  
  cylon_top #(.CLOCK_CYCLES_PER_PULSE(28'd500)) UUT1 (
    .clk(clk),
    .sw(16'h0003),
    .btnC(btnC),
    .btnL(btnL),
    .btnR(btnR),
    .led(w_led));
  
  initial begin
    #1000;
    btnC = 1'b1;
    #200;
    btnC = 1'b0;
  end
  
  initial begin
    #100000 $stop;
  end
endmodule
