module clock_divider(
  input clk,
  input reset,
  output reg sclk
);

  reg [31:0] count;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
      count <= 32'd0;
      sclk <= 1'b0;
    end else begin
      if (count == 32'd9000000) begin
        count <= 32'd0;
        sclk <= ~sclk;
      end else begin
        count <= count + 1;
      end
    end
  end
  
  always @(posedge clk) begin
    $display("sclk = %b", sclk);
  end
  
endmodule

module clock_divider_tb;
  reg clk, reset;
  wire sclk;
  
  clock_divider uut (
    .clk(clk),
    .reset(reset),
    .sclk(sclk)
  );
  
  initial begin
    clk = 1'b0;
    reset = 1'b0;
    
    #5 reset = 1'b1;
    #10 reset = 1'b0;
    #50 $finish;
  end
  
  always #5 clk = ~clk;
  
endmodule
