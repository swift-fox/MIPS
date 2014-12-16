module processor_tb();
reg _reset,clk;

processor MIPS(_reset,clk);

always #2 clk=~clk;

initial
begin
	//$dumpfile("test.vcd");
	//$dumpvars(0,MIPS);

	clk=0;
	_reset=0;
	#3
	_reset=1;

	//#11000000
	#40000
	$writememh("dump.hex",MIPS.d.mem);
	$finish;
end

endmodule
