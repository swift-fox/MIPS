module alu(out,in0,in1,func);
output [31:0] out;
input signed [31:0] in0,in1;
input [5:0] func;

reg [31:0] out;
reg [31:0] hi,lo;

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

always@(func,in0,in1)
begin
	case(func)
	`sll:  out=in0<<in1;
	`srl:  out=in0>>in1;
	`sra:  out=in0>>>in1;
	`sllv: out=in1<<in0;
	`srlv: out=in1>>in0;
	`srav: out=in1>>>in0;
	`jr:   ;
	`jalr: out=in1;
	`movz: out=(in1==0)?in0:32'bz;
	`movn: out=(in1!=0)?in0:32'bz;
	`mfhi: out=hi;
	`mthi: hi=in0;
	`mflo: out=lo;
	`mtlo: lo=in0;
	`mult: {hi,lo}=in0*in1;
	`multu: {hi,lo}={1'b0,in0}*{1'b0,in1};
	`div:
	begin
		hi=in0%in1;
		lo=in0/in1;
	end
	`divu:
	begin
		hi={1'b0,in0}%{1'b0,in1};
		lo={1'b0,in0}/{1'b0,in1};
	end
	`add:  out=in0+in1;
	`addu: out=in0+in1;
	`sub:  out=in0-in1;
	`subu: out=in0-in1;
	`_and: out=in0&in1;
	`_or:  out=in0|in1;
	`_xor: out=in0^in1;
	`_nor: out=~(in0|in1);
	`slt:  out=(in0<in1);
	`sltu: out=(in0[31:0]<in1[31:0]);
	default: out=0;
	endcase
end

endmodule
