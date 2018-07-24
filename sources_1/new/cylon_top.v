`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2018 09:54:51
// Design Name: 
// Module Name: cylon_top
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


module cylon_top(
    input clk,
    input [3:0] sw,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    output [15:0] led,
    output [6:0]  seg,
    output [3:0]  an,
    output        dp
  );

  parameter CLOCK_CYCLES_PER_PULSE  = 29'd25_000_000;
  parameter CLOCK_CYCLES_PER_SECOND = 29'd100_000_000;

  localparam  MODE_CYLON  = 2'b00,
              MODE_R_TO_L = 2'b01,
              MODE_L_TO_R = 2'b10,
              MODE_COUNT  = 2'b11;
  
  reg [1:0] mode = MODE_CYLON;
  
  cylon #(
    .CLOCK_CYCLES_PER_PULSE(CLOCK_CYCLES_PER_PULSE),    // Four pulses per second
    .CLOCK_CYCLES_PER_SECOND(CLOCK_CYCLES_PER_SECOND),  // One pulse per second
    .NUMBER_OF_LEDS(16)                                 // The number of devices to activate
    ) cylon (
      .clk(clk),
      .mode(mode),                                      // Cylon mode = 0, right to left = 1, left to right = 2 
      .speed({1'b0, sw[2:0]}),                          // Speed multiplier
      .brightness({sw[3],3'b111}),                      // Set thi brightness
      .led(led),
      .seg(seg),
      .an(an),
      .dp(dp)
    );
  
  // Set the LED movement mode when one of the buttons have been pressed.
  always @(posedge clk)
  begin
    if (btnC) begin
      mode <= MODE_CYLON;
    end else if (btnR) begin
      mode <= MODE_L_TO_R;
    end else if (btnL) begin
      mode <= MODE_R_TO_L;
    end else if (btnU) begin
      mode <= MODE_COUNT;
      end else begin
      
    end
  end
  
endmodule
