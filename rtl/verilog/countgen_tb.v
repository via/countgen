module countgen_tb();

  reg clk, rst, cyc, stb, we;
  reg [3:0] adr;
  reg [31:0] dat_i;
  wire [31:0] dat_o; 
  wire ack;


  wire [7:0] gens;

  reg [31:0] period;

  countgen cg(.clk_i(clk), .rst_i(rst), .cyc_i(cyc),
              .stb_i(stb), .adr_i(adr), .we_i(we),
              .dat_i(dat_i), .dat_o(dat_o), .ack_o(ack),
              .countgen_io(gens));

  assign gens[7] = gens[0];
  initial begin
    $dumpfile("countgen_tb.vcd");
    $dumpvars();
    clk = 0;
    rst = 1;
    adr = 0;
    cyc = 0;
    stb = 0;
    we = 0;
    dat_i = 8'h7F;
    #10 rst = 0;
    #10 $display("starting");  
    rst = 0;
    we = 1;
    stb = 1;
    cyc = 1;
    #4 cyc = 0;
    stb = 0;
    #10 we = 0;
    adr = 1;
    dat_i = 32'd300;
    we = 1;
    stb = 1;
    cyc = 1; 
    #4 cyc = 0;
    stb = 0;
    #5000 we = 0;
    adr = 1;
    dat_i = 32'd280;
    we = 1;
    stb = 1;
    cyc = 1; 
    #4 cyc = 0;
    stb = 0;
    #5000 we = 0;
    adr = 1;
    dat_i = 32'd272;
    we = 1;
    stb = 1;
    cyc = 1; 
    #4 cyc = 0;
    stb = 0;
    #5000 we = 0;
    $finish; 
  end

  always #2 clk = ~clk;

endmodule
