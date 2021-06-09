 module Apple(
	clk,
	rst,
	is_eat,
	x_snake_cur,
	y_snake_cur,
	appleX,
	appleY,
	length,
	is_end,
	pixel_done,
	vld,
	vld_start,
	vld_t,
	good
);

parameter H_LOGIC_WIDTH     = 5;
parameter V_LOGIC_WIDTH     = 5;

parameter H_LOGIC_MAX       = 5'd31;
parameter V_LOGIC_MAX       = 5'd23;

parameter H_PHY_WIDTH     = 10;
parameter V_PHY_WIDTH     = 9;

parameter H_PHY_MAX       = 10'd639;
parameter V_PHY_MAX       = 9'd479;

input 							clk, rst;			
input [H_LOGIC_WIDTH-1:0] 	x_snake_cur;
input [V_LOGIC_WIDTH-1:0] 	y_snake_cur;
input [9:0] 					length;
input 							is_end;
input 							pixel_done;
input								vld;
input 							vld_start;
input 							vld_t;
output reg						is_eat;
output reg [4:0] 				appleX;
output reg [4:0] 				appleY;
output reg						good;

reg 								bad_collision;
reg								vld_check;
reg								is_eat_reg;
wire [4:0]						rand_X;
wire [4:0]						rand_Y;
wire 								clk1;
reg 								clk2=0;
reg [5:0] 						count=0;
reg [H_LOGIC_WIDTH-1:0] 	x_snake[200:0];
reg [V_LOGIC_WIDTH-1:0] 	y_snake[200:0];
localparam 						delay = 3'd3; 
reg [200:0] collision;
reg [9:0] i;
reg [9:0] j;
//Create clk1, clk2
assign clk1 = clk;

always @ (posedge clk) begin
	if (count == delay*2) count <= 0;
	if (count < delay) clk2 <= 1;
	else clk2 <= 0;
	count <= count + 1;
end

randompoint rand(clk1,clk2,rand_X, rand_Y);

//Assign x_snake, y_snake
always @ (posedge vld_start, posedge vld_t, posedge rst) begin
	if (rst) begin
		x_snake[0] = x_snake_cur;
		y_snake[0] = y_snake_cur;
	end else	
	if (!is_end) begin	
		x_snake[i] = x_snake_cur;
		y_snake[i] = y_snake_cur;
	end	
end
//
always @ (posedge clk) begin
	if (rst) begin
		appleX <= 10'd3;
		appleY <= 9'd0;
	end else
	if (rst || vld) begin
		i<=0;
		j<=0;
	end else
	if ((vld || pixel_done) && !is_end) begin
		i<=i+1;
	end
end

always @ (posedge bad_collision ,posedge is_eat_reg) begin
//FOR TEST
	/*if (length==1) begin
		appleX <= 5'd4;
		appleY <= 5'd0;
	end else
	if (length==2) begin
		appleX <= 5'd3;
		appleY <= 5'd0;
	end else
		appleX <= rand_X;
		appleY <= 5'd0;*/
		
		appleX <= rand_X;
		appleY <= rand_Y;
		
end

//Check conditions
always @ (posedge clk) begin
	if (vld || rst) begin
		vld_check <= 0;
	end else
	if (pixel_done && is_end) begin
		vld_check <= 1;
	end
end

always @ (posedge clk) begin
	if (vld || rst) begin
		is_eat_reg <= 0;
		bad_collision <= 0;
	end else
	if (x_snake[0]==appleX && y_snake[0]==appleY && vld_check) begin	
		is_eat_reg <= 1;
	end else is_eat_reg <=0;
end

always @ (posedge clk) begin
	if (rst || bad_collision) collision <= 201'd0;
	if ((vld_check && is_eat)) begin
		for (j=0; j<length; j=j+1) begin
			collision[j] <= (x_snake[j]==appleX && y_snake[j]==appleY);
		end
	end
end

always @ (is_eat_reg) begin
	is_eat <= is_eat_reg;
end

always @ (collision) begin
	bad_collision = |collision;
end

reg temp;
always @ (posedge clk) begin
	if (rst || vld) temp<=0;
	if (is_eat) temp<=1;
end

always @ (posedge clk) begin
	if (rst || vld) good<=0;
	if (temp && !bad_collision) good<=1;
	else good<=0;
end

endmodule
