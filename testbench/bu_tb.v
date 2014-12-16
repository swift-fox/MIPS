module bu_tb();
bu b(in0,in1,func,out);
reg[31:0] in0,in1;
reg[1:0] func;
wire out;

initial
begin
	in0='hafafafaf;
	in1='hafafafaf;

	func=0;	//eq
	#1
	if(out) $display("PASS");
	else $display("FAIL");

	func=1;	//ne
	#1
	if(out==0) $display("PASS");
	else $display("FAIL");

	func=2;	//le
	#1
	if(out) $display("PASS");
	else $display("FAIL");

	func=3;	//gt
	#1
	if(out==0) $display("PASS");
	else $display("FAIL");

	in0='hafafafaf;
	in1='hafafafae;

	func=0;	//eq
	#1
	if(out==0) $display("PASS");
	else $display("FAIL");

	func=1;	//ne
	#1
	if(out) $display("PASS");
	else $display("FAIL");

	func=2;	//le
	#1
	if(out==0) $display("PASS");
	else $display("FAIL");

	func=3;	//gt
	#1
	if(out) $display("PASS");
	else $display("FAIL");
end
endmodule
