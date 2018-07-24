`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2018 12:04:40
// Design Name: 
// Module Name: cylon
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Do the cliche cylon thingy with the board's LEDs. 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//parameter CLOCK_CYCLES_PER_PULSE = 29'd25_000_000;    // Four pulses per decond.
module cylon
  #(
    CLOCK_CYCLES_PER_PULSE = 29'd25_000_000,
    NUMBER_OF_LEDS = 16
  )(
    input                       clk,
    input  [1:0]                mode,       // Cylon mode = 0, right to left = 1, left to right = 2 
    input  [3:0]                speed,      // Speed multiplier
    input  [3:0]                brightness, // Set the brightness level 0-15
    output [NUMBER_OF_LEDS-1:0] led
  );
  
  //parameter CLOCK_CYCLES_PER_PULSE = 29'd25_000_000; // Four pulses per decond.
  //parameter NUMBER_OF_LEDS = 16;                      // The number of devices to activate
  
  localparam  DIRECTION_L = 1'b0,
              DIRECTION_R = 1'b1;
  localparam  MODE_CYLON  = 2'b00,
              MODE_R_TO_L = 2'b01,
              MODE_L_TO_R = 2'b10;
  
  reg [15:0] active_led  = 0;
  reg [3:0]  pointer     = 0;
  reg        direction   = 0;
  reg [29:0] pulse_speed = CLOCK_CYCLES_PER_PULSE;
  
  wire w_pulse_leds;
  
  // 1/16th second pulse
  pulse_generator pulse_leds (
    .clk(clk),
    .clks_per_pulse(pulse_speed),
    .pulse(w_pulse_leds)
  );
  
  // Fader
  pwm_fader #(.NUMBER_DEVICES(NUMBER_OF_LEDS)) led_fader(
    .clk(clk),
    .linger_clks(pulse_speed >> 1),
    .start_brightness(brightness),
    .active(16'b1 << pointer),
    .faded_out(led)
  );
  
  // Set the pulse speed based on the position of the input switches
  always @(posedge clk)
  begin
    pulse_speed <= (CLOCK_CYCLES_PER_PULSE >> speed);
  end
  
  // Move the LEDs
  always @(posedge w_pulse_leds)
  begin
    case (mode)
    
    // set direction depending on mode and/or position
    MODE_L_TO_R: direction = DIRECTION_R;
    MODE_R_TO_L: direction = DIRECTION_L;
    default:
      // Cylon mode
      begin
        if (pointer == 4'hf)     direction = DIRECTION_R;
        else if(pointer == 4'h0) direction = DIRECTION_L;
        
      end
    endcase
    
    // Move in the given direction
    if (direction == DIRECTION_L) begin
      pointer = pointer + 1'b1;
    end else begin
      pointer = pointer - 1'b1;
    end
  end
  
endmodule
