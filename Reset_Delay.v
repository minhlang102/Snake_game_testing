module Reset_Delay(iCLK,oRESET,iRST_n);
input       iCLK;
input       iRST_n;
output reg  oRESET;
//reg	[19:0]  Cont=0;
reg	[2:0]   Cont_tb=0; 

always@(posedge iCLK)
begin
    if(Cont_tb!=3'd7)
    begin
        Cont_tb	<=	Cont_tb+1;
        oRESET	<=	1'b0;
    end
    else
    oRESET	<=	iRST_n;
end

endmodule