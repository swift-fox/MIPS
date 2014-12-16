module regfile_tb();
regfile r(clk,out0,out1,in,sel0,sel1,sel2);
wire [31:0] out0,out1;
reg [31:0] in;
reg [4:0] sel0,sel1,sel2;
reg clk;

initial
begin
	clk=0;
	sel0=0;
	sel1=0;
	sel2=0;
	in='hafafafaf;

	for(sel2=0;sel2<31;sel2=sel2+1)
	begin
		clk=1;
		#1
		clk=0;
	end

	in='b11110000_11110000_11110000_1111000z;
	for(sel2=0;sel2<31;sel2=sel2+1)
	begin
		clk=1;
		#1
		clk=0;
	end

	for(sel0=0;sel0<31;sel0=sel0+1)
	begin
		#1
		$display("%h",out0);
	end

	//Simultaneous read and write
	sel0=1;
	sel1=1;
	sel2=1;
	clk=0;
	in='h01010101;

	#1
	if(out0!='hafafafaf) $display("FAIL");

	clk=1;
	#1
	if(out0=='h01010101&&out1=='h01010101) $display("PASS");
end
endmodule
