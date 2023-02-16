module test;
  reg clk, reset;
  wire out;

  // Instantiate the clock divider module
  clock_divider uut (
    .clk(clk),
    .reset(reset),
    .sclk(out)
  );

  // Drive the clock signal
  always #5 clk = ~clk;

  // Drive the reset signal
  initial begin
    reset = 1;
    #10 reset = 0;
  end

  // Display the output
  always @(posedge clk) $display("out = %b", out);
endmodule
