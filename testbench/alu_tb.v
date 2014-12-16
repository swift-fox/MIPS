module alu_tb();
alu a(out,in0,in1,func);
wire[31:0] out;
reg[31:0] in0,in1;
reg[5:0] func;

`define sll  'b000000
`define srl  'b000010
`define sra  'b000011
`define sllv 'b000100
`define srlv 'b000110
`define srav 'b000111
`define jr   'b001000
`define jalr 'b001001
`define movz 'b001010
`define movn 'b001011
`define mfhi 'b010000
`define mthi 'b010001
`define mflo 'b010010
`define mtlo 'b010011
`define mult 'b011000
`define multu 'b011001
`define div  'b011010
`define divu 'b011011
`define add  'b100000
`define addu 'b100001
`define sub  'b100010
`define subu 'b100011
`define _and 'b100100
`define _or  'b100101
`define _xor 'b100110
`define _nor 'b100111
`define slt  'b101010
`define sltu 'b101011

initial
begin
	in0='h4;
	in1='h11111111;

	func=`sll;
	#1
	if(out=='h11111110) $display("PASS");
	else $display("FAIL sll  %h",out);

	func=`srl;
	#1
	if(out=='h01111111) $display("PASS");
	else $display("FAIL srl  %h",out);

	func=`sra;
	#1
	if(out=='h01111111) $display("PASS");
	else $display("FAIL sra  %h",out);

	func=`sllv;
	#1
	if(out=='h11111110) $display("PASS");
	else $display("FAIL sllv %h",out);

	func=`srlv;
	#1
	if(out=='h01111111) $display("PASS");
	else $display("FAIL srlv %h",out);

	func=`srav;
	#1
	if(out=='h01111111) $display("PASS");
	else $display("FAIL srav %h",out);

	in1='h80000000;
	#1
	if(out=='hf8000000) $display("PASS");
	else $display("FAIL srav %h",out);

	func=`jr;
	#1
	if(out=='hf8000000) $display("PASS");
	else $display("FAIL jr   %h",out);

	func=`jalr;
	#1
	if(out=='h4) $display("PASS");
	else $display("FAIL jalr %h",out);

	in0='h11111111;
	func=`movz;
	in1=0;
	#1
	if(out=='h11111111) $display("PASS");
	else $display("FAIL movz %h",out);

	in1=1;
	#1
	if(out[0]===1'bz) $display("PASS");
	else $display("FAIL movz %b",out);

	func=`movn;
	in1=1;
	#1
	if(out=='h11111111) $display("PASS");
	else $display("FAIL movn %h",out);

	in1=0;
	#1
	if(out[0]===1'bz) $display("PASS");
	else $display("FAIL movn %b",out);

	in0='hffffffff;
	in1=2;
	func=`mult;
	#1
	func=`mfhi;
	#1
	if(out=='hffffffff) $display("PASS");
	else $display("FAIL mult %h",out);

	func=`mflo;
	#1
	if(out=='hfffffffe) $display("PASS");
	else $display("FAIL mult %h",out);

	func=`multu;
	#1
	func=`mfhi;
	#1
	if(out=='h1) $display("PASS");
	else $display("FAIL multu %h",out);

	func=`mflo;
	#1
	if(out=='hfffffffe) $display("PASS");
	else $display("FAIL multu %h",out);

	in0=-5;
	in1=2;
	func=`div;
	#1
	func=`mfhi;
	#1
	if(out==-1) $display("PASS");
	else $display("FAIL div  %h",out);

	func=`mflo;
	#1
	if(out==-2) $display("PASS");
	else $display("FAIL div  %h",out);

	func=`divu;
	#1
	func=`mfhi;
	#1
	if(out==1) $display("PASS");
	else $display("FAIL divu %h",out);

	func=`mflo;
	#1
	if(out=='h7ffffffd) $display("PASS");
	else $display("FAIL divu %h",out);

	in0='hafafafaf;
	func=`mthi;
	#1
	func=`mfhi;
	#1
	if(out=='hafafafaf) $display("PASS");
	else $display("FAIL mthi %h",out);

	func=`mtlo;
	#1
	func=`mflo;
	#1
	if(out=='hafafafaf) $display("PASS");
	else $display("FAIL mtlo %h",out);

	in0='h11111111;
	in1='h22222222;

	func=`add;
	#1
	if(out=='h33333333) $display("PASS");
	else $display("FAIL add  %h",out);

	func=`addu;
	#1
	if(out=='h33333333) $display("PASS");
	else $display("FAIL addu %h",out);

	func=`sub;
	#1
	if(out=='b11101110_11101110_11101110_11101111) $display("PASS");
	else $display("FAIL sub  %h",out);

	func=`subu;
	#1
	if(out=='b11101110_11101110_11101110_11101111) $display("PASS");
	else $display("FAIL subu %h",out);

	func=`_and;
	#1
	if(out==0) $display("PASS");
	else $display("FAIL and  %h",out);

	func=`_or;
	#1
	if(out=='h33333333) $display("PASS");
	else $display("FAIL or   %h",out);

	func=`_xor;
	#1
	if(out=='h33333333) $display("PASS");
	else $display("FAIL xor  %h",out);

	func=`_nor;
	#1
	if(out=='hcccccccc) $display("PASS");
	else $display("FAIL nor  %h",out);

	func=`slt;
	#1
	if(out=='h1) $display("PASS");
	else $display("FAIL slt  %h",out);

	in0='h33333333;
	func=`sltu;
	#1
	if(out=='h0) $display("PASS");
	else $display("FAIL sltu %h",out);
end

endmodule
