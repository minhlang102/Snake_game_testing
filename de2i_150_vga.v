module de2i_150_vga(
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

parameter VGA_ADDR_WIDTH    = 19;
parameter H_LOGIC_WIDTH     = 5;
parameter V_LOGIC_WIDTH     = 5;

parameter H_LOGIC_MAX       = 5'd31;
parameter V_LOGIC_MAX       = 5'd23;

parameter H_PHY_WIDTH    	 = 10;
parameter V_PHY_WIDTH     	 = 9;

parameter H_PHY_MAX      	 = 10'd639;
parameter V_PHY_MAX      	 = 9'd479;

parameter COLOR_ID_WIDTH  	 = 8;

input			 SW;
input        CLOCK_50;
input  [3:0] KEY;
output [7:0] VGA_B;
output       VGA_BLANK_N;
output       VGA_CLK;
output [7:0] VGA_G;
output       VGA_HS;
output [7:0] VGA_R;
output       VGA_SYNC_N;
output       VGA_VS;

wire			VGA_CTRL_CLK;
wire  [9:0]	mVGA_R;
wire  [9:0]	mVGA_G;
wire  [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;
wire			DLY_RST;

//	For VGA Controller
wire        mVGA_CLK;
wire  [9:0] mRed;
wire  [9:0] mGree;
wire  [9:0] mBlue;
wire        VGA_Rea;	//	VGA data request

wire  [9:0] recon_VGA_R;
wire  [9:0] recon_VGA_G;
wire  [9:0] recon_VGA_B;

wire clk;
reg rst=0;

reg	vld_apple=0;
wire	bite_self=0;

assign clk = CLOCK_50;
always @ (posedge clk) begin
	rst <= (vld_apple && bite_self)? 1 : ~DLY_RST;
end

Reset_Delay r0	(
    .iCLK(clk),
    .oRESET(DLY_RST),
    .iRST_n(SW) 	
    );

reg vga_clk_reg=0;
always @(posedge clk)
	vga_clk_reg = !vga_clk_reg;

assign VGA_CTRL_CLK = vga_clk_reg;

//	VGA Controller
//assign VGA_BLANK_N = !cDEN;
assign VGA_CLK = ~VGA_CTRL_CLK;


wire [VGA_ADDR_WIDTH - 1 : 0] addr;
wire [COLOR_ID_WIDTH - 1 : 0] data;
wire                          wren;

vga_controller_mod u4(
    .iRST_n     (DLY_RST),
    .iVGA_CLK   (VGA_CTRL_CLK),
    .iclk       (clk),
    .iwren      (wren),
    .idata      (data),
    .iaddr      (addr),
    .oBLANK_n   (VGA_BLANK_N),
    .oHS        (VGA_HS),
    .oVS        (VGA_VS),
    .b_data     (VGA_B),
    .g_data     (VGA_G),
    .r_data     (VGA_R)
    ); 
//// Display a superpixel move left to right, top to down

wire [H_LOGIC_WIDTH - 1 : 0] 	x_logic;
wire [V_LOGIC_WIDTH - 1 : 0] 	y_logic;

wire [H_PHY_WIDTH - 1 : 0]		x_physic;
wire [V_PHY_WIDTH - 1 : 0]		y_physic;

localparam	VLD_1HZ_CNT_MAX = 25'd24999999;
localparam	VLD_0_5HZ_CNT_MAX = 25'd12499999;
localparam  FOR_TEST = 11'd2000;
reg  [10:0]  vld_cnt=0;
reg        vld=0;
reg        vld_start=0;

// Update interval time
always @(vld_cnt) begin
	vld = (vld_cnt == FOR_TEST);
	vld_start = (vld_cnt == 11'b0);
end

always @(posedge clk) begin
    if (!DLY_RST) begin
        vld_cnt <= 0;
    end
    else begin
        vld_cnt <= (vld) ? 0 : vld_cnt + 1'b1;
    end
end

// Control Snake
reg [3:0] way=1000;
always @(negedge KEY[0], negedge KEY[1], negedge KEY[2], negedge KEY[3], posedge clk) begin
		way<=~KEY;
end

// Snake moves
reg [9:0]	length=1;
wire			is_eat=0;
wire 			is_queue=0;	 
wire			is_end;
wire [H_LOGIC_WIDTH - 1 : 0]  pixel_x_logic;
wire [V_LOGIC_WIDTH - 1 : 0]  pixel_y_logic;
wire [COLOR_ID_WIDTH - 1 : 0] pixel_color;
wire                          pixel_done;

move 
	#(
	.H_LOGIC_MAX	(H_LOGIC_MAX),
	.V_LOGIC_MAX	(V_LOGIC_MAX),
	.H_LOGIC_WIDTH	(H_LOGIC_WIDTH),
	.V_LOGIC_WIDTH	(V_LOGIC_WIDTH)
	)
mv(
	.clk				(clk),
	.rst				(rst),
	.vld				(vld),
	.way				(way),
	.x					(x_logic),
	.y					(y_logic),
	.length			(length),
	.pixel_done		(pixel_done),
	.is_end			(is_end),
	.is_queue		(is_queue),
	.bite_self		(bite_self),
	.vld_t			(vld_t)
	);
	
// Eat apple
wire [H_LOGIC_WIDTH - 1 : 0] appleX_logic;
wire [V_LOGIC_WIDTH - 1 : 0] appleY_logic;
Apple 
	#(
	.H_LOGIC_MAX	(H_LOGIC_MAX),
	.V_LOGIC_MAX	(V_LOGIC_MAX),
	.H_LOGIC_WIDTH	(H_LOGIC_WIDTH),
	.V_LOGIC_WIDTH	(V_LOGIC_WIDTH)
	)
eat(
	.clk				(clk),
	.rst				(rst),
	.x_snake			(x_logic),
	.y_snake			(y_logic),
	.is_eat			(is_eat),
	.appleX			(appleX_logic),
	.appleY			(appleY_logic),
	.length			(length)
	);

always @ (posedge clk) begin
	if (is_eat) begin
		length <= length + 10'd1;
	end
end

draw_superpixel 
    #(
    .SPIXEL_X_WIDTH    (H_LOGIC_WIDTH),
    .SPIXEL_Y_WIDTH    (V_LOGIC_WIDTH),
    .SPIXEL_X_MAX      (H_LOGIC_MAX),
    .SPIXEL_Y_MAX      (V_LOGIC_MAX),
    .PIXEL_X_WIDTH     (H_PHY_WIDTH),
    .PIXEL_Y_WIDTH     (V_PHY_WIDTH),
    .PIXEL_X_MAX       (H_PHY_MAX),
    .PIXEL_Y_MAX       (V_PHY_MAX)
    )
pixel
    (
    .clk        (clk),
    .rst        (rst),
    // USER IF
    .x          (pixel_x_logic),
    .y          (pixel_y_logic),
    .idata      (pixel_color),
    .idata_vld  (pixel_vld),
	 .odone		 (pixel_done),
    // VGA RAM IF
    .oaddr      (addr),
    .odata      (data),
    .owren      (wren)
    );
	 
always @ (posedge clk) begin
	if (pixel_done && is_end) begin
		vld_apple <= 1;
	end
	else 
	if (vld || rst) begin
		vld_apple <= 0;
	end
end

assign pixel_vld = vld_start || vld_t || vld_apple; 
assign pixel_x_logic = (vld_apple)? appleX_logic : x_logic;
assign pixel_y_logic = (vld_apple)? appleY_logic : y_logic;
assign pixel_color 	= (vld_apple)? 8'hf9 : (is_end && !is_queue)? 8'hff : 8'h0f;

endmodule 