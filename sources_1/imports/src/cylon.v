`timescale 1ns / 1ps

// Description: Do the cliche cylon thingy with the board's LEDs.
module cylon
  #(
    CLOCK_CYCLES_PER_PULSE  = 29'd25_000_000, // Four pulses per second.
    CLOCK_CYCLES_PER_SECOND = 29'd100_000_000, // One pulses per second.
    NUMBER_OF_LEDS          = 16
  )(
    input                       clk,
    input  [1:0]                mode,       // Cylon mode = 0, right to left = 1, left to right = 2 
    input  [3:0]                speed,      // Speed multiplier
    input  [3:0]                brightness, // Set the brightness level 0-15
    output [NUMBER_OF_LEDS-1:0] led,
    output [6:0]                seg,
    output [3:0]                an,
    output                      dp
  );
  
  localparam  DIRECTION_L = 1'b0,
              DIRECTION_R = 1'b1;
  localparam  MODE_CYLON  = 2'b00,
              MODE_R_TO_L = 2'b01,
              MODE_L_TO_R = 2'b10,
              MODE_COUNT  = 2'b11;
  
  reg [NUMBER_OF_LEDS-1:0] active_led  = 0;
  reg [NUMBER_OF_LEDS-1:0] led_timer  = 0;
  reg [NUMBER_OF_LEDS-1:0] seconds_timer = 0;
  reg [3:0]                pointer     = 0;
  reg                      direction   = 0;
  reg [29:0] pulse_speed_cylon = CLOCK_CYCLES_PER_PULSE;
  reg [29:0] pulse_speed_led = CLOCK_CYCLES_PER_SECOND;
  reg [29:0] pulse_speed_second = CLOCK_CYCLES_PER_SECOND;
  
  wire                      w_pulse_cylon;
  wire                      w_pulse_led;
  wire                      w_pulse_seconds;
  wire [NUMBER_OF_LEDS-1:0] w_active_leds;
  
  assign w_active_leds = (mode == MODE_COUNT) ? led_timer : (16'b1 << pointer);
  
  // Pulses for the cylon
  pulse_generator pulse_cylon (
    .clk(clk),
    .clks_per_pulse(pulse_speed_cylon),
    .pulse(w_pulse_cylon)
  );
  
  // Pulses for the LED counter
    pulse_generator pulse_led_cntr (
      .clk(clk),
      .clks_per_pulse(pulse_speed_led),
      .pulse(w_pulse_led)
    );

    // 1 second pulse
    pulse_generator pulse_seconds (
      .clk(clk),
      .clks_per_pulse(pulse_speed_second),
      .pulse(w_pulse_seconds)
    );
  
  // Fader for the LEDs.
  pwm_fader #(.NUMBER_DEVICES(NUMBER_OF_LEDS)) led_fader(
    .clk(clk),
    .linger_clks(pulse_speed_cylon >> 1),
    .start_brightness(brightness),
    .active(w_active_leds),
    .faded_out(led)
  );
  
  seven_seg_display_driver seven_seg_display_driver
  (
    .clk(clk),            // Clock
    .disp_buf(seconds_timer),       // Display buffer
    .dp(3'o0),             // Which segment to show the decimal point, 0 for none.
    .lum(brightness),            // Luminosity, display brightness, 0 to 15
    .an_mux(an),         // Seven seg anode driver
    .seg_mux(seg),        // [6:0] Seven seg cathode driver
    .dp_mux(dp)   
  );
  
  // Set the pulse speed based on the position of the input switches
  always @(posedge clk)
  begin
    pulse_speed_cylon <= (CLOCK_CYCLES_PER_PULSE >> speed);
  end
  
  // Increment the hex LED counter
  always @(posedge w_pulse_led)
  begin
    led_timer <= led_timer + 1'b1;
    pulse_speed_led <= (CLOCK_CYCLES_PER_SECOND >> speed);
  end
  
    // Increment the hex LED counter
  always @(posedge w_pulse_seconds)
  begin
    seconds_timer <= seconds_timer + 1'b1;
  end
  
  // Move the LEDs
  always @(posedge w_pulse_cylon)
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
