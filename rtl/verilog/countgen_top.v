
module countgen(
		    // 8bit WISHBONE bus slave interface
		    clk_i,         // clock
		    rst_i,         // reset (asynchronous active low)
		    cyc_i,         // cycle
		    stb_i,         // strobe
		    adr_i,         // address
		    we_i,          // write enable
		    dat_i,         // data input
		    dat_o,         // data output
		    ack_o,         // normal bus termination

                    countgen_io
                    );

  parameter num_io_pins = 8; /* Number of pins */
  /* 
   * address   -   meaning
   *     0x0   -   direction bitmask
   *     0x1   -   clock period in wb clock ticks for pin 0
   *     0xn   -   clock period in wb clock ticks for pin n - 1
   */

  input  wire 	    clk_i;         // clock
  input  wire 	    rst_i;         // reset (asynchronous active low)
  input  wire 	    cyc_i;         // cycle
  input  wire 	    stb_i;         // strobe
  input  wire [3:0] adr_i;         // address
  input  wire 	     we_i;          // write enable
  input  wire [31:0] dat_i;         // data input
  output reg [31:0]  dat_o;         // data output
  output wire 	     ack_o;         // normal bus termination


  inout [num_io_pins-1:0] countgen_io;

  reg [num_io_pins-1:0] countgen_dir;
  reg [31:0] countgen_genfreq[num_io_pins-1:0];
  wire [31:0] countgen_counters[num_io_pins-1:0];

  wire [num_io_pins-1:0] countgen_in;
  wire [num_io_pins-1:0] countgen_out;

  genvar i;
  generate
    for (i=0;i<num_io_pins;i=i+1) begin: iopins
      assign countgen_io[i] = (countgen_dir[i]) ? countgen_out[i]: 1'bz;
      assign countgen_in[i] = (countgen_dir[i]) ? countgen_out[i] : countgen_io[i];
      countgen_generator generators(clk_i, rst_i, countgen_out[i], countgen_genfreq[i]);
      countgen_counter counters(clk_i, rst_i, countgen_in[i], countgen_counters[i]);
    end
  endgenerate

  always @(posedge clk_i)
    if (rst_i) begin
      countgen_dir <= 0;
    end else 
      if (stb_i & cyc_i & ~we_i) 
        dat_o <= (adr_i == 0) ? countgen_dir : countgen_counters[adr_i - 1];
      else if (stb_i & cyc_i & we_i) begin
        if (adr_i > 0) 
          countgen_genfreq[adr_i - 1] = dat_i;
        else
          countgen_dir <= dat_i[num_io_pins-1:0];
      end

  assign ack_o = cyc_i & stb_i;
endmodule
