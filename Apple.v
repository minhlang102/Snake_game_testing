module Apple(
	clk,
	rst,
	collision,
	apple,
	x_snake,
	y_snake,
	appleX,
	appleY,
	length
);

parameter H_LOGIC_WIDTH     = 5;
parameter V_LOGIC_WIDTH     = 5;

parameter H_LOGIC_MAX       = 5'd31;
parameter V_LOGIC_MAX       = 5'd23;

parameter H_PHY_WIDTH     = 10;
parameter V_PHY_WIDTH     = 9;

parameter H_PHY_MAX       = 10'd639;
parameter V_PHY_MAX       = 9'd479;

input clk,collision, rst;			
input [H_LOGIC_WIDTH-1:0] 	x_snake;
input [V_LOGIC_WIDTH-1:0] 	y_snake;
input [9:0] length;

output apple;
	
output reg [9:0] appleX;
output reg [8:0] appleY;
reg apple_inX;
reg apple_inY;
wire [9:0]rand_X;
wire [8:0]rand_Y;
wire clk1;
reg clk2;
assign clk1 = clk;
localparam delay = 25;
reg [5:0] count;
reg i;

always @ (posedge clk) begin
	if (count == delay*2) count <= 0;
	if (count < delay) clk2 <= 1;
	else clk2 <= 0;
	count <= count + 1;
end

randompoint(clk1,clk2,rand_X, rand_Y);

always @ (posedge clk) begin
	if (rst) begin
		appleX <= 15;
		appleY <= 15;
	end
	else
	if (collision || apple == 1)begin
		appleX <= rand_X;
		appleY <= rand_Y;
	end
end

assign apple = (x_snake == appleX && y_snake == appleY)? 1 : 0;
endmodule
