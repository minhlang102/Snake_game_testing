module decimaltoLED(
number,
reset,
LED
);
input [2:0] number;
input reset;

output [6:0] LED;
assign LED = (reset)? 7'b1000000://0
 (number==0)? 7'b1000000: //0
 (number==1)? 7'b1111001: //1
 (number==2)? 7'b0100100: //2
 (number==3)? 7'b0110000: //3
 (number==4)? 7'b0011001: //4
 (number==5)? 7'b0010010: //5
 (number==6)? 7'b0000010: //6
 (number==7)? 7'b1111000: //7
 (number==8)? 7'b0000000: //8
 (number==9)? 7'b0010000: //9
 7'b0111111; //dash

endmodule
