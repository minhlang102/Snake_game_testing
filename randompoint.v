module randompoint(clk1,clk2, randomX, randomY);
input clk1, clk2;
output reg [4:0]randomX=0;
output reg [4:0]randomY=0;
always @(posedge clk1 )begin
   randomX = randomX + 5;
	if ( randomX >= 31)begin
	     randomX = 15;
		  end
end
always @(posedge clk2)begin
   randomY = randomY + 8;
	if ( randomY >= 23)begin
	     randomY = 10;
		  end
end
endmodule


