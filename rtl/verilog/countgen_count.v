module countgen_counter(
  clk,
  rst,
  in,
  period);

  input wire clk;
  input wire rst;
  input wire in;
  output reg [31:0] period;

  reg [31:0] counter;


  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      period <= 0;
    end else begin
      counter <= 0;
      period <= 0;
    end
      

  end
       
endmodule
                
