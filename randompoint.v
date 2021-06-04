module randompoint(clk1,clk2, randomX, randomY);
input clk1, clk2;
output reg [9:0]randomX = 70;
output reg [8:0]randomY = 90;
always @(posedge clk1 )begin
   randomX = randomX + 30;
	if ( randomX >= 570)begin
	     randomX = 40;
		  end
end
always @(posedge clk2)begin
   randomY = randomY + 20;
	if ( randomY >= 420)begin
	     randomY = 40;
		  end
end
endmodule


