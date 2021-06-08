module move(
	clk,
	rst,
	vld,
	way,
	
	x,
	y,
	length,
	pixel_done,
	is_end,
	is_queue,
	bite_self,
	vld_t
);

parameter H_LOGIC_MAX		= 5'd31;
parameter V_LOGIC_MAX 		= 5'd23;
parameter H_LOGIC_WIDTH 	= 5;
parameter V_LOGIC_WIDTH 	= 5;

input										clk, rst, vld;
input [3:0] 							way; 
input [9:0]								length;
input 									pixel_done;
output reg [H_LOGIC_WIDTH-1:0] 	x;
output reg [V_LOGIC_WIDTH-1:0] 	y;
output reg 								is_end;
output reg 								is_queue;
output reg 								bite_self;
output reg								vld_t;

reg [H_LOGIC_WIDTH-1:0] 			x_logic[200:0];
reg [V_LOGIC_WIDTH-1:0] 			y_logic[200:0];
reg [H_LOGIC_WIDTH-1:0]	   		oldx_logic[200:0];
reg [V_LOGIC_WIDTH-1:0] 			oldy_logic[200:0];
reg										vld_t_reg;
reg [9:0] 								i;
wire										bite_self_vld;

always @(posedge clk) begin
	 if (!vld && pixel_done && i<length+1) begin
		vld_t_reg <= 1;
	 end else vld_t_reg <= 0;
end  
//Snake's head
always @(posedge clk) begin
    if (rst) begin
			is_end = 0;
			is_queue = 0;
			i = 1;
			x_logic[0] = 5'd1;
			y_logic[0] <= 0;
			oldx_logic[0] = 0;
			oldy_logic[0] = 0;
			x = 1;
			y = 0;
    end
    else if (vld && !bite_self) begin
			i = 1;
			is_end = 0;
			oldx_logic[0] = x_logic[0];
			oldy_logic[0] = y_logic[0];
			//RIGHT
			if (way==4'b1000) begin
				x_logic[0] = (x_logic[0] == H_LOGIC_MAX) ? 0 : x_logic[0] + 1'b1;
				y_logic[0]= y_logic[0];
			end
			else
			//LEFT
			if (way==4'b0100) begin
				x_logic[0] = (x_logic[0] == 0) ? H_LOGIC_MAX : x_logic[0] - 1'b1;
				y_logic[0] = y_logic[0];
			end
			else
			//UP				
			if (way==4'b0010) begin
				x_logic[0] = x_logic[0];
				y_logic[0] = (y_logic[0] == 0) ? V_LOGIC_MAX : y_logic[0] - 1'b1;
			end
			else
			//DOWN		
			if (way==4'b0001) begin
				x_logic[0] = x_logic[0];					
				y_logic[0] = (y_logic[0] == V_LOGIC_MAX) ? 0 : y_logic[0] + 1'b1;
			end
			x = x_logic[0];
			y = y_logic[0];
    end else
//Snake's body
			if (vld_t_reg) begin
				oldx_logic[i] = x_logic[i];
				oldy_logic[i] = y_logic[i];
				x_logic[i] = oldx_logic[i-1];
				y_logic[i] = oldy_logic[i-1];
				
				x = (i==length)? oldx_logic[i-1] : x_logic[i];
				y = (i==length)? oldy_logic[i-1] : y_logic[i];
				
				is_end	 = (i==length)? 1 : 0;
				is_queue  = (x_logic[0]==x_logic[length-1] && y_logic[0]==y_logic[length-1] && length>3)? 1 : 0;
				
				i = i + 1;
			end
end

assign bite_self_vld = (x_logic[0]==x_logic[i] && y_logic[0]==y_logic[i] && length>5  && i!=length )? 1 : 0;
always @ (posedge clk) begin
	vld_t <= vld_t_reg;
end

always @ (posedge clk) begin
	if (rst) begin
		bite_self <= 0;
	end
	else if (bite_self_vld) begin
		bite_self <= 1;
	end
end


endmodule

