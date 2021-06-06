`timescale 1ps/1ps
module de2i_150_vga_tb;
	reg CLOCK_50, SW;
	reg [3:0] KEY;
	wire [7:0] VGA_B, VGA_G, VGA_R;
	wire VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;
	
	de2i_150_vga UUT(
	 CLOCK_50,
	 SW,
    KEY,
    VGA_B,
    VGA_BLANK_N,
    VGA_CLK,
    VGA_G,
    VGA_HS,
    VGA_R,
    VGA_SYNC_N,
    VGA_VS
	 );
	
	initial begin
		CLOCK_50 = 0;
	end
	
	always #5 CLOCK_50 = ~CLOCK_50; 

	initial begin
		SW = 0;
		KEY = 4'b0111;
		#30;
		SW = 1;
		#10;
	end
	
endmodule
		
	