module countgen_counter(
  clk,
  rst,
  in,
  period);

  parameter scan_window = 128;
  parameter stable_window = 16;

  input wire clk;
  input wire rst;
  input wire in;
  output reg [31:0] period;

  reg [scan_window-1:0] past;
  reg [31:0] counter;

  always @(posedge clk) begin
    if (rst) begin
      period <= 0;
      past <= ~0;
    end else begin
      if (& past[stable_window-1:0] && ~(|past[scan_window-1:scan_window-stable_window])) begin
        period <= counter + 1;
        counter <= 0;
        past <= ~0;
      end else begin
        past <= {past[scan_window - 2:0], in};
       counter <= counter + 1;      
      end
    end

  end
       
endmodule
                
