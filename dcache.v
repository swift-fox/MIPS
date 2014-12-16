module dcache(clk,rw,addr,in,out);
input[31:2] addr;
input[31:0] in;
input clk,rw;
output[31:0] out;

reg[31:0] mem[0:512*512-1];

assign out=mem[addr];

always@(negedge clk)
begin
	if(rw) mem[addr]=in;
end

initial
begin
	$readmemh("data.hex",mem);
end

endmodule
