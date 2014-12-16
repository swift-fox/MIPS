module icache_tb();
icache i(addr,data);
reg[31:2] addr;
wire[31:0] data;
initial
begin
	for(addr=0;addr<16;addr=addr+1)
	#1
	$display("%h",data);
end
endmodule
