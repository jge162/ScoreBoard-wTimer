/*module clock_divider(
  input clk,
  input reset,
  output reg sclk
);

  reg [31:0] count = 0;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
      count <= 32'd0;
      sclk <= 1'b0;
    end else begin
      if (count == 32'd5000000) begin
        count <= 32'd0;
        sclk <= ~sclk;
      end else begin
        count <= count + 1;
      end
    end
  end
  
  always @(posedge clk) begin
    $display("count = %d, sclk = %b", count, sclk);
  end
  
endmodule

module tb_clock_divider;
  reg clk;
  reg reset;
  wire sclk;
  
  clock_divider dut(.clk(clk), .reset(reset), .sclk(sclk));
  
  initial begin
    clk = 0;
    reset = 1;
    
    #10 reset = 0;
    
    #100 $finish;
  end
  
  always #5 clk = ~clk;
endmodule*/
module half_adder
(
    input wire a, b,
    output wire sum, carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

module half_adder_tb;

    reg a, b;
    wire sum, carry;

    // duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns
    localparam period = 20;  

    half_adder UUT (.a(a), .b(b), .sum(sum), .carry(carry));
    
    initial // initial block executes only once
        begin
            // values for a and b
            a = 0;
            b = 0;
            #period; // wait for period 

            a = 0;
            b = 1;
            #period;

            a = 1;
            b = 0;
            #period;

            a = 1;
            b = 1;
            #period;
        end
endmodule
