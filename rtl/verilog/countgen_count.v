module countgen_counter(
  clk,
  rst,
  in,
  period);

  parameter scan_window = 64;

  input wire clk;
  input wire rst;
  input wire in;
  output reg [31:0] period;

  reg [scan_window-1:0] past;
  reg [31:0] counter;
  reg state;

  always @(posedge clk) begin
    if (rst) begin
      period <= 0;
      past <= 0;
      state <= 0;
    end else begin
      past = {past[scan_window-2:0], in};
      if (& past[scan_window-1:0] && ~state) begin
        period <= counter + 1;
        counter <= 0;
        state <= 1;
      end else if (~|past[scan_window-1:0] && state) begin
        state <= 0;
        counter <= counter + 1;      
      end else begin
       counter <= counter + 1;      
      end
    end

  end
       
endmodule
                
