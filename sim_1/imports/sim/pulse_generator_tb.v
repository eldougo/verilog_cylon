`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2018 12:12:32
// Design Name: 
// Module Name: pulse_generator_tb
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


module pulse_generator_tb();
  
  reg clk = 0;
  wire w_pulse_16;
  
  always #5 clk = !clk;

  //pulse_generator #(28'd20) pulse_16 (.clk(clk), .pulse(w_pulse_16)); 
  pulse_generator #(28'd6250000) UUT0 (.clk(clk), .pulse(w_pulse_16));
  
  initial begin
    //$display("time,\tclk,\tw_pulse_16"); 
    //$monitor("%0d, %b, %b",$time, clk,w_pulse_16); 
  end
  
  initial begin
    @ (posedge w_pulse_16);
    #100 $stop;
  end
endmodule
