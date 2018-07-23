`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2018 18:21:52
// Design Name: 
// Module Name: pwm_fader
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


module pwm_fader
 #(NUMBER_DEVICES = 16)
  (
    input                      clk,
    input [29:0]               linger_clks,
    input [3:0]                start_brightness,
    input [NUMBER_DEVICES-1:0] active,
    output[NUMBER_DEVICES-1:0] faded_out
  );
  
  localparam FADE_SPEED = 4'h1;
  wire w_fade_pulse;
  wire [NUMBER_DEVICES-1:0] w_faded_out;
  
  reg [3:0]  dev_pwm[0:NUMBER_DEVICES-1];
  reg [3:0]  pwm_cntr = 0;
  
  // Generate fade pulses
  pulse_generator pulse_pwm (.clk(clk), .clks_per_pulse(linger_clks), .pulse(w_fade_pulse));
    
  // Set the all PWMs to zero 
  integer i;
  initial
  begin
    for(i = 0; i < NUMBER_DEVICES; i = i + 1)  begin
      dev_pwm[i] <= 4'h0;
    end
  end

  // Set the current LED to 100% and fade the rest
  integer n;
  always @(posedge w_fade_pulse)
  begin
    for(n = 0; n < NUMBER_DEVICES; n = n + 1)  begin
      if (active[n]) begin
        dev_pwm[n] <= start_brightness;
      end else if (dev_pwm[n] < FADE_SPEED) begin
        dev_pwm[n] <= 0;
      end else begin
        dev_pwm[n] <= dev_pwm[n] - FADE_SPEED;
      end
    end
  end
  
  // PWM counter
  always @(posedge clk)
  begin
    pwm_cntr <= pwm_cntr + 1'b1;
  end
  
  // PWM each LED
  genvar k;
  generate
    for(k = 0; k < NUMBER_DEVICES; k = k + 1) begin
      assign faded_out[k] = (dev_pwm[k] > pwm_cntr);
    end
  endgenerate
endmodule
