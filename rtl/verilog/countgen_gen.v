module countgen_generator(
  clk,
  rst,
  out,
  period);

  input wire clk;
  input wire rst;
  output reg out;
  input wire [31:0] period;

  reg [31:0] counter;


  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      out <= 0;
    end else begin
      if (counter < period >> 1) begin
        counter <= counter + 1;
        out <= out;
      end else begin
        counter <= 0;
        out <= ~out;
      end
    end
  end
       
endmodule
                
