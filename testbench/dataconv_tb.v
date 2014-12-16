module dataconv_tb();
dataconv dc(base,offset,func,rin,din,out,addr,rw);
reg[31:0] base,rin,din;
reg[15:0] offset;
reg[2:0] func;
reg rw;
wire[31:0] out;
wire[31:2] addr;

`define b  'b000
`define h  'b001
`define wl 'b010
`define w  'b011
`define bu 'b100
`define hu 'b101
`define wr 'b110
`define ui 'b111

initial
begin
	base='hfffffffc;
	offset=4;
	#1
	if(addr==0) $display("PASS");
	else $display("FAIL %h",addr);

	offset=-4;
	#1
	if(addr=='h3ffffffe) $display("PASS");
	else $display("FAIL %h",addr);

	rw=0;
	din='hf10245f0;

	base=4;
	func=`b;

	offset=0;
	#1
	if(out=='hfffffff0) $display("PASS");
	else $display("FAIL b  %h",out);

	offset=1;
	#1
	if(out=='h00000045) $display("PASS");
	else $display("FAIL b  %h",out);

	offset=2;
	#1
	if(out=='h00000002) $display("PASS");
	else $display("FAIL b  %h",out);

	offset=3;
	#1
	if(out=='hfffffff1) $display("PASS");
	else $display("FAIL b  %h",out);

	func=`bu;

	offset=0;
	#1
	if(out=='h000000f0) $display("PASS");
	else $display("FAIL bu %h",out);

	offset=1;
	#1
	if(out=='h00000045) $display("PASS");
	else $display("FAIL bu %h",out);

	offset=2;
	#1
	if(out=='h00000002) $display("PASS");
	else $display("FAIL bu %h",out);

	offset=3;
	#1
	if(out=='h000000f1) $display("PASS");
	else $display("FAIL bu %h",out);

	func=`h;

	offset=0;
	#1
	if(out=='h000045f0) $display("PASS");
	else $display("FAIL h  %h",out);

	offset=1;
	#1
	if(out=='h000045f0) $display("PASS");
	else $display("FAIL h  %h",out);

	offset=2;
	#1
	if(out=='hfffff102) $display("PASS");
	else $display("FAIL h  %h",out);

	offset=3;
	#1
	if(out=='hfffff102) $display("PASS");
	else $display("FAIL h  %h",out);

	func=`hu;

	offset=0;
	#1
	if(out=='h000045f0) $display("PASS");
	else $display("FAIL hu %h",out);

	offset=1;
	#1
	if(out=='h000045f0) $display("PASS");
	else $display("FAIL hu %h",out);

	offset=2;
	#1
	if(out=='h0000f102) $display("PASS");
	else $display("FAIL hu %h",out);

	offset=3;
	#1
	if(out=='h0000f102) $display("PASS");
	else $display("FAIL hu %h",out);

	func=`w;
	offset=0;
	#1
	if(out=='hf10245f0) $display("PASS");
	else $display("FAIL w  %h",out);

	offset=1;
	#1
	if(out=='hf10245f0) $display("PASS");
	else $display("FAIL w  %h",out);

	din='h11223344;
	rin='haabbccdd;
	func=`wl;
	offset=0;
	#1
	if(out=='h44bbccdd) $display("PASS");
	else $display("FAIL wl %h",out);

	offset=1;
	#1
	if(out=='h3344ccdd) $display("PASS");
	else $display("FAIL wl %h",out);

	offset=2;
	#1
	if(out=='h223344dd) $display("PASS");
	else $display("FAIL wl %h",out);

	offset=3;
	#1
	if(out=='h11223344) $display("PASS");
	else $display("FAIL wl %h",out);

	func=`wr;
	offset=0;
	#1
	if(out=='h11223344) $display("PASS");
	else $display("FAIL wr %h",out);

	offset=1;
	#1
	if(out=='haa112233) $display("PASS");
	else $display("FAIL wr %h",out);

	offset=2;
	#1
	if(out=='haabb1122) $display("PASS");
	else $display("FAIL wr %h",out);

	offset=3;
	#1
	if(out=='haabbcc11) $display("PASS");
	else $display("FAIL wr %h",out);

	func=`ui;
	offset='h1234;
	#1
	if(out=='h12340000) $display("PASS");
	else $display("FAIL ui %h",out);

	rw=1;
	rin='haaaaaaaa;
	din='hbbbbbbbb;
	func=`w;
	#1
	if(out=='haaaaaaaa) $display("PASS");
	else $display("FAIL rw %h",out);
end
endmodule
