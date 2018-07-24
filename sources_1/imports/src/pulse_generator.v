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
// Description: Generate a pulse every time 'clks_per_pulse' clock cycles have been
//              counted. Set 'clks_per_pulse' to  29'd100_000_000 for a 1 second pulse.
//              With 30 bits, the maximum pulse interval is 2^31-1 = 29'd2147483647, 
//              which is like 2.147 seconds. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Set clks_per_pulse to 29'd100_000_000 for a 1 second pulse.
module pulse_generator
#(
  CLOCK_BIT_WIDTH = 30
)(
  input clk,
  input [CLOCK_BIT_WIDTH-1:0] clks_per_pulse,
  output reg pulse = 0
);
    
  reg [CLOCK_BIT_WIDTH-1:0] counter = 0;
  
  // Generate a pulse and reset every time the counter hits the 'clks_per_pulse' parameter.
  // Must check if greater or equal incase the 'clks_per_pulse' parameter is changed.
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
