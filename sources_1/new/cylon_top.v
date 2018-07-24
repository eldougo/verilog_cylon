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
    input [15:0] sw,
    input btnC,
    input btnL,
    input btnR,
    output [15:0] led
  );

  localparam  MODE_CYLON  = 2'b00,
              MODE_R_TO_L = 2'b01,
              MODE_L_TO_R = 2'b10;
  
  reg [2:0] mode = MODE_CYLON;
  
  cylon #(.CLOCK_CYCLES_PER_PULSE(29'd25_000_000),    // Four pulses per decond.
          .NUMBER_OF_LEDS(16)                      // The number of devices to activate
    )(
      .clk(clk),
      .mode(mode),       // Cylon mode = 0, right to left = 1, left to right = 2 
      .speed(sw[2:0]),      // Speed multiplier
      .led(led)
    );
  
  // Set the LED movement mode when one of the buttons have been pressed.
  always @(posedge clk)
  begin
    if (btnC) begin
      mode <= MODE_CYLON;
    end else if (btnR) begin
      mode <= MODE_L_TO_R;
    end else if (btnL) begin
      mode <= MODE_L_TO_R;
    end else begin
      
    end
  end
  
endmodule
