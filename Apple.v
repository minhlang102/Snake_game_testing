 module Apple(
	clk,
	rst,
	is_eat,
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

input clk, rst;			
input [H_LOGIC_WIDTH-1:0] 	x_snake;
input [V_LOGIC_WIDTH-1:0] 	y_snake;
input [9:0] length;
output is_eat;
output reg [4:0] appleX;
output reg [4:0] appleY;

wire apple_t;
reg bad_collision;
wire [4:0]rand_X;
wire [4:0]rand_Y;
wire clk1;
reg clk2=0;
reg [5:0] count=0;
localparam delay = 25;

//Create clk1, clk2
assign clk1 = clk;

always @ (posedge clk) begin
	if (count == delay*2) count <= 0;
	if (count < delay) clk2 <= 1;
	else clk2 <= 0;
	count <= count + 1;
end

randompoint rand(clk1,clk2,rand_X, rand_Y);

//
always @ (posedge clk) begin
	if (rst) begin
		appleX <= 10'd15;
		appleY <= 9'd15;
	end
	else
	if (bad_collision || apple_t)begin
		appleX <= rand_X;
		appleY <= rand_Y;
	end
end

//Check conditions
always @ (rand_X, rand_Y) begin
	bad_collision = (rand_X == x_snake && rand_Y == y_snake)? 1 : 0;
end

assign apple_t = (x_snake == appleX && y_snake == appleY)? 1 : 0;
assign is_eat = (apple_t)? 1 : 0;

endmodule
