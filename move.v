module move(
	clk,
	DLY_RST,
	vld,
	way,
	
	x,
	y,
	length,
	pixel_done,
	is_end,
	is_queue
);

parameter H_LOGIC_MAX		= 5'd31;
parameter V_LOGIC_MAX 		= 5'd23;
parameter H_LOGIC_WIDTH 	= 5;
parameter V_LOGIC_WIDTH 	= 5;

input										clk, DLY_RST, vld;
input [3:0] 							way; 
input [9:0]								length;
input 									pixel_done;
output reg [H_LOGIC_WIDTH-1:0] 	x;
output reg [V_LOGIC_WIDTH-1:0] 	y;
output reg 								is_end;
output reg 								is_queue;

reg [H_LOGIC_WIDTH-1:0] 			x_logic[200];
reg [V_LOGIC_WIDTH-1:0] 			y_logic[200];
reg [H_LOGIC_WIDTH-1:0]	   		oldx_logic[200];
reg [V_LOGIC_WIDTH-1:0] 			oldy_logic[200];
reg										vld_t;
reg [9:0] 								i;

always @(posedge clk) begin
	 if (!vld && pixel_done && i<length+1) begin
		vld_t <= 1;
	 end else vld_t <= 0;
end  
//Snake's head
always @(posedge clk) begin
    if (!DLY_RST) begin
		  is_end <= 0;
		  i <= 1;
        x_logic[0] <= H_LOGIC_MAX;
        y_logic[0] <= V_LOGIC_MAX;
        oldx_logic[0] <= 0;
		  oldy_logic[0] <= 0;
    end
    else if (vld) begin
			i <= 1;
			is_end <= 0;
			//RIGHT
			if (way==4'b1000) begin
				x_logic[0] <= (x_logic[0] == H_LOGIC_MAX) ? 0 : x_logic[0] + 1'b1;
				y_logic[0] <= y_logic[0];
			end
			else
			//LEFT
			if (way==4'b0100) begin
				x_logic[0] <= (x_logic[0] == 0) ? H_LOGIC_MAX : x_logic[0] - 1'b1;
				y_logic[0] <= y_logic[0];
			end
			else
			//UP				
			if (way==4'b0010) begin
				x_logic[0] <= x_logic[0];
				y_logic[0] <= (y_logic[0] == 0) ? V_LOGIC_MAX : y_logic[0] - 1'b1;
			end
			else
			//DOWN		
			if (way==4'b0001) begin
				x_logic[0] <= x_logic[0];					
				y_logic[0] <= (y_logic[0] == V_LOGIC_MAX) ? 0 : y_logic[0] + 1'b1;
			end
			oldx_logic[0] <= x_logic[0];
			oldy_logic[0] <= y_logic[0];
			x <= x_logic[0];
			y <= y_logic[0];
    end else
//Snake's body
			if (vld_t) begin
				oldx_logic[i] <= x_logic[i];
				oldy_logic[i] <= y_logic[i];
				x_logic[i] <= oldx_logic[i-1];
				y_logic[i] <= oldy_logic[i-1];
		 
				x <= (i==length)? oldx_logic[i-1] : x_logic[i];
				y <= (i==length)? oldy_logic[i-1] : y_logic[i];
				
				is_end	= (i==length)? 1 : 0;
				is_queue = (x_logic[0]==x_logic[length-1] && y_logic[0]==y_logic[length-1] && length>8)? 1 : 0;
				
				i <= i + 1;
			end
end

endmodule

