module icache(addr,data);
input[31:2] addr;
output[31:0] data;

reg[31:0] mem[0:1023];

assign data=mem[addr];

initial
begin
	$readmemb("inst.bin",mem);
end

endmodule
