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
