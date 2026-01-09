/*
 * Copyright (c) 2024 Alexander Singer, 
 * SPDX-License-Identifier: Apache-2.0
 */

// contact me on discord @entropicentity

`default_nettype none

module tt_um_entropicentity_Safe_ASIC (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = 0;
  assign uio_oe  = 8'b00111111; // uio[5:0] are outputs, uio[7:6] are inputs

  // Internal wires
  wire c1, c2;              // Alternating clocks from clockboss
  wire lock, green, blue;   // Safe control outputs
  wire [3:0] dataline;      // Data from membranedriver to safecontrol

  // Assign outputs
  assign uio_out[3] = lock;
  assign uio_out[4] = green;
  assign uio_out[5] = blue;
  assign uio_out[7:6] = 2'b00;

  // List all unused inputs to prevent warnings
  wire _unused = &{ui_in, ena, 1'b0};

  // Clock divider - generates alternating clocks
  clockboss u_clockboss (
    .clk(clk),
    .rst(~rst_n),
    .c1(c1),
    .c2(c2)
  );

  // Keypad scanner - scans matrix keypad and outputs digit codes
  membranedriver u_membranedriver (
    .clk(c1),
    .rst(~rst_n),
    .in0(uio_in[0]),
    .in1(uio_in[1]),
    .in2(uio_in[2]),
    .in3(uio_in[3]),
    .out0(uio_out[0]),
    .out1(uio_out[1]),
    .out2(uio_out[2]),
    .data_out(dataline)
  );

  // Safe controller - manages unlock codes and LED status
  safecontrol u_safecontrol (
    .clk(c2),
    .rst(~rst_n),
    .invalue(dataline),
    .lock(lock),
    .green(green),
    .blue(blue)
  );

endmodule
