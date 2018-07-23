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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module cylon (
  input clk,
  input [15:0] sw,
  input btnC,
  input btnL,
  input btnR,
  output [15:0] led
  );
  
  //parameter CLOCK_CYCLES_PER_PULSE = 28'd6_250_000;
  parameter CLOCK_CYCLES_PER_PULSE = 29'd25_000_000;
  localparam NUMBER_OF_LEDS = 16;
  
  localparam R_TO_L = 1'b0, L_TO_R = 1'b1;
  localparam MODE_CYLON = 2'b00, MODE_L = 2'b01, MODE_R = 2'b10;
  reg [15:0] active_led = 0;
  reg [3:0]  pointer = 0;
  reg        direction = 0;
  reg [1:0]  mode = 2'b00;
  
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
    .start_brightness(4'hf),
    .active(16'b1 << pointer),
    .faded_out(led)
  );
  
  // Set the pulse speed based on the position of the input switches
  always @(posedge clk)
  begin
    pulse_speed <= (CLOCK_CYCLES_PER_PULSE >> sw[3:0]);
  end
  
  // Set the LED movement mode when one of the buttons have been pressed.
  always @(posedge clk)
  begin
    if (btnC) begin
      mode <= MODE_CYLON;
    end else if (btnR) begin
      mode <= MODE_R;
    end else if (btnL) begin
      mode <= MODE_L;
    end else begin
      
    end
  end
  
  // Move the LEDs
  always @(posedge w_pulse_leds)
  begin
    //if (w_pulse_leds) begin
      if (mode == MODE_R) direction = L_TO_R;
      if (mode == MODE_L) direction = R_TO_L;

      if (pointer == 4'hf) begin
        if (mode == MODE_R) begin
          direction = L_TO_R;
          
        end else if (mode == MODE_L) begin
          direction = R_TO_L;
          //pointer = 4'h0;
          
        end else begin
          direction = L_TO_R;
          
        end
      end else if(pointer == 4'h0) begin
        if (mode == MODE_R) begin
          direction = L_TO_R;
          //pointer = 4'hF;
          
        end else if (mode == MODE_L) begin
          direction = R_TO_L;
          
        end else begin
          direction = R_TO_L;
          
        end
      end
      
      if (direction == R_TO_L) begin
        pointer = pointer + 1'b1;
      end else begin
        pointer = pointer - 1'b1;
      end
    //end
  end
  
endmodule
