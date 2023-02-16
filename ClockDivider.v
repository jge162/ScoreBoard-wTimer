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
