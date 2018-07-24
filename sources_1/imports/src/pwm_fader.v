`timescale 1ns / 1ps

// Description: Set the PWM of the passed devices to 100% luminosity and fade the rest.
module pwm_fader
#(
  NUMBER_DEVICES = 16
)(
  input                      clk,
  input [29:0]               linger_clks,             // Number of clock cycles between each fade event
  input [3:0]                start_brightness,        // Brightness of the active device. 0-15
  input [NUMBER_DEVICES-1:0] active,                  // The active devices at full brightness
  output[NUMBER_DEVICES-1:0] faded_out                // The output to conect to the devices.
);
  
  localparam FADE_STEP = 4'h1;
  wire                      w_fade_pulse;
  wire [NUMBER_DEVICES-1:0] w_faded_out;
  
  reg [3:0]                 dev_pwm[0:NUMBER_DEVICES-1];
  reg [3:0]                 pwm_cntr = 0;
  
  // Generate fader pulses
  pulse_generator pulse_pwm (.clk(clk), .clks_per_pulse(linger_clks), .pulse(w_fade_pulse));
    
  // Initialize all devices to zero brightness. 
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
      end else if (dev_pwm[n] < FADE_STEP) begin
        dev_pwm[n] <= 0;
      end else begin
        dev_pwm[n] <= dev_pwm[n] - FADE_STEP;
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
