module dcache_tb();
dcache d(clk,rw,addr,in,out);
reg[31:2] addr;
reg[31:0] in;
reg clk,rw;
wire[31:0] out;
initial
begin
	rw=0;
	clk=0;
	for(addr=0;addr<16;addr=addr+1)
	#1
	$display("%h",out);

	in='hafafafaf;
	addr='ha;
	rw=1;
	#1
	$display("%h",out);
	clk=1;
	#1
	$display("%h",out);
end
endmodule

