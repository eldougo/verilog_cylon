`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2018 11:49:45
// Design Name: 
// Module Name: pulse_generator
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

// Set clks_per_pulse to 28'd100_000_000 for a 1 second pulse.
module pulse_generator(
    input clk,
    input [29:0] clks_per_pulse,
    output reg pulse = 0
  );
    
  reg [29:0] counter = 0;
  
  // Generate a pulse every time the counter hits the clks_per_pulse parameter
  always @(posedge clk)
  begin
    counter <= counter + 1'b1;
    if (counter >= clks_per_pulse) begin
      pulse <= 1'b1;
      counter <= 0;
    end else begin
      pulse <= 1'b0;
    end
  end
endmodule
