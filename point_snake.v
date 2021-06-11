module point_snake(
clock,
reset,
length,
LED1,
LED2,
LED3  
);
parameter H_LOGIC_WIDTH     = 5;
parameter V_LOGIC_WIDTH     = 5;

parameter H_LOGIC_MAX       = 5'd31;
parameter V_LOGIC_MAX       = 5'd23;

parameter H_PHY_WIDTH     = 10;
parameter V_PHY_WIDTH     = 9;

parameter H_PHY_MAX       = 10'd639;
parameter V_PHY_MAX       = 9'd479;
	
input clock;
input reset;
input[9:0] length;


output[6:0] LED1;
output[6:0] LED2;
output[6:0] LED3;

reg [3:0] first;
reg [3:0] second;
reg [3:0] third;

reg [9:0]length_second;



always @ (*) begin
if(reset) begin
	first<=0;
	second<=0;
	third<=0;
end
else begin
	if(length==200) begin
		first<=0;
		second<=0;
		third<=2;
		end
	else begin
		third=(length>9'd100) ? 1:0;
		if(third==1) length_second<=length-100;
		else length_second<=length;
		if(length_second<10) begin
		second<=0;
		first<=length_second;
		end
		else if(length_second<20) begin
		second<=1;
		first=length_second-10;
		end
		else if(length_second<30) begin
		second<=2;
		first=length_second-20;
		end
		else if(length_second<40) begin
		second<=3;
		first=length_second-30;
		end
		else if(length_second<50) begin 
		second<=4;
		first=length_second-40;
		end
		else if(length_second<60) begin
		second<=5;
		first=length_second-50;
		end
		else if(length_second<70) begin
		second<=6;
		first=length_second-60;
		end
		else if(length_second<80) begin
		second<=7;
		first=length_second-70;
		end
		else if(length_second<90) begin
		second<=8;
		first=length_second-80;
		end
		else begin
		second<=9;
		first=length_second-90;
		end		
		end
	end
end

decimaltoLED hdv(first,reset,LED1);
decimaltoLED hch(second,reset,LED2);
decimaltoLED htr(third,reset,LED3);

endmodule
