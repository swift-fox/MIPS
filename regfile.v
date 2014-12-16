module regfile(_reset,clk,out0,out1,in,sel0,sel1,sel2);
output [31:0] out0,out1;
input [31:0] in;
input [4:0] sel0,sel1,sel2;
input _reset,clk;

reg[31:0] mem[1:31];

assign out0=sel0?mem[sel0]:0;
assign out1=sel1?mem[sel1]:0;

always@(_reset)
begin
	if(~_reset)
	begin
		{mem[1],mem[2],mem[3],mem[4],mem[5],mem[6],mem[7],mem[8],mem[9],mem[10],mem[11],mem[12],mem[13],mem[14],mem[15],mem[16],mem[17],mem[18],mem[19],mem[20],mem[21],mem[22],mem[23],mem[24],mem[25],mem[26],mem[27],mem[28],mem[29],mem[30],mem[31]}<=0;
	end
end

always@(negedge clk)
begin
	if(sel2&&in[0]!==1'bz) mem[sel2]<=in;
end

endmodule
