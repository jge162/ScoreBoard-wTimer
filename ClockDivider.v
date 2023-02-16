module clock_divider(
  input clk,
  output reg sclk
);

  reg [31:0] count;
  
  always @(posedge clk) begin
    if (count == 31'd0) begin
      sclk <= ~sclk;
      count <= 31'd1;
    end else begin
      count <= count + 1;
    end
    $display("sclk = %b", sclk);
  end
  
endmodule


module testbench;
  reg clk = 0;
  always #5 clk = ~clk;

  reg reset = 1;
  wire sclk;

  clock_divider dut(
    .clk(clk),
    .reset(reset),
    .sclk(sclk)
  );

  initial begin
    #10 reset = 0;
  end

  always @(posedge clk) begin
    $display("sclk = %b", sclk);
  end

endmodule
