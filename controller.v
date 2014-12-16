module controller(
	_reset,clk,
	inst,iaddr,
	rw,dfunc,bfunc,
	rsel0,rsel1,rsel2,func,
	alu_op,reg_in,d_in,
	dout,din
);
input _reset,clk;
input [31:0] inst,din;
output [31:2] iaddr;
output [31:0] dout;
output rw;
output [2:0] dfunc;
output [1:0] bfunc;
output [4:0] rsel0,rsel1,rsel2;
output [5:0] func;
output alu_op,reg_in,d_in;

reg [31:2] iaddr;
reg [31:0] dout;
wire [2:0] dfunc;
wire [1:0] bfunc;
wire [4:0] rsel0,rsel1;
reg [4:0] rsel2;
reg [5:0] func;

wire [5:0] opcode;
wire [4:0] rs,rt,rd;
wire [4:0] shamt;
wire [5:0] funct;
wire signed [15:0] imme;
wire [25:0] offset;

reg special,rsel0_src;
reg [1:0] rsel2_src,func_src;
reg reg_in,d_in,alu_op,rw;
reg [1:0] dout_src,j_mode;

reg [13:0] mc;

always@(clk)
begin
	if(clk)
	begin
		if(~_reset) iaddr=30'h3fffffff;
		else case(j_mode)
			default:iaddr=iaddr+1;
			1:iaddr=iaddr+(din[0]?{{16{imme[15]}},imme}:1);
			2:iaddr={iaddr[31:28],offset};
			3:iaddr=din[31:2];
		endcase
	end
end

assign {opcode,rs,rt,rd,shamt,funct}=inst;
assign imme=inst[15:0];
assign offset=inst[25:0];

/*
Microcode Fields
0	special		0:	1:ALU
1	rsel0_src	0:rs	1:rt
2:3	rsel2_src	00:0		01:rd		10:rt			11:31
4:5	func_src	00:funct	01:6'b001001	10:{3'b100,opcode[2:0]}	11:{3'b101,opcode[2:0]}
6	reg_in		0:alu	1:dataconv
7	d_in		0:reg	1:bu
8	alu_op		0:reg	1:dout
9	rw		0:r	1:w
10:11	dout_src	0:shamt	01:unsign imme	10:sign imme	11:iaddr+1
12:13	j_mode		0:norm	01:b	10:j	11:jr
*/

always@(opcode,funct)
begin
	case(opcode)
	0:  mc=14'b1_0_00_00_0_0_0_0_00_00;	//special
	2:  mc=14'b0_0_00_00_0_0_0_0_00_10;	//j
	3:  mc=14'b0_0_11_01_0_0_1_0_11_10;	//jal
	4:  mc=14'b0_0_00_00_0_1_0_0_00_01;	//beq
	5:  mc=14'b0_0_00_00_0_1_0_0_00_01;	//bne
	6:  mc=14'b0_0_00_00_0_1_0_0_00_01;	//blez
	7:  mc=14'b0_0_00_00_0_1_0_0_00_01;	//bgtz
	8:  mc=14'b0_0_10_10_0_0_1_0_10_00;	//addi
	9:  mc=14'b0_0_10_10_0_0_1_0_10_00;	//addiu
	10: mc=14'b0_0_10_11_0_0_1_0_10_00;	//slti
	11: mc=14'b0_0_10_11_0_0_1_0_10_00;	//sltiu
	12: mc=14'b0_0_10_10_0_0_1_0_01_00;	//andi
	13: mc=14'b0_0_10_10_0_0_1_0_01_00;	//ori
	14: mc=14'b0_0_10_10_0_0_1_0_01_00;	//xori
	15: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lui
	32: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lb
	33: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lh
	34: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lwl
	35: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lw
	36: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lbu
	37: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lhu
	38: mc=14'b0_0_10_00_1_0_0_0_01_00;	//lwr
	40: mc=14'b0_0_00_00_0_0_0_1_01_00;	//sb
	41: mc=14'b0_0_00_00_0_0_0_1_01_00;	//sh
	42: mc=14'b0_0_00_00_0_0_0_1_01_00;	//swl
	43: mc=14'b0_0_00_00_0_0_0_1_01_00;	//sw
	46: mc=14'b0_0_00_00_0_0_0_1_01_00;	//swr
	default: mc=14'b0_0_00_00_0_0_0_0_00_00;
	endcase

	{special,rsel0_src,rsel2_src,func_src,reg_in,d_in,alu_op,rw,dout_src,j_mode}=mc;

	if(special)
	begin 
	case(funct)
	0: mc= 14'b1_1_01_00_0_0_1_0_00_00;	//sll
	2: mc= 14'b1_1_01_00_0_0_1_0_00_00;	//srl
	3: mc= 14'b1_1_01_00_0_0_1_0_00_00;	//sra
	4: mc= 14'b1_0_01_00_0_0_0_0_00_00;	//sllv
	6: mc= 14'b1_0_01_00_0_0_0_0_00_00;	//srlv
	7: mc= 14'b1_0_01_00_0_0_0_0_00_00;	//srav
	8: mc= 14'b1_0_01_00_0_0_0_0_00_11;	//jr
	9: mc= 14'b1_0_01_00_0_0_1_0_11_11;	//jalr
	16: mc=14'b1_0_01_00_0_0_0_0_00_00;	//mfhi
	17: mc=14'b1_0_01_00_0_0_0_0_00_00;	//mthi
	18: mc=14'b1_0_01_00_0_0_0_0_00_00;	//mflo
	19: mc=14'b1_0_01_00_0_0_0_0_00_00;	//mtlo
	24: mc=14'b1_0_01_00_0_0_0_0_00_00;	//mult
	25: mc=14'b1_0_01_00_0_0_0_0_00_00;	//multu
	26: mc=14'b1_0_01_00_0_0_0_0_00_00;	//div
	27: mc=14'b1_0_01_00_0_0_0_0_00_00;	//divu
	32: mc=14'b1_0_01_00_0_0_0_0_00_00;	//add
	33: mc=14'b1_0_01_00_0_0_0_0_00_00;	//addu
	34: mc=14'b1_0_01_00_0_0_0_0_00_00;	//sub
	35: mc=14'b1_0_01_00_0_0_0_0_00_00;	//subu
	36: mc=14'b1_0_01_00_0_0_0_0_00_00;	//and
	37: mc=14'b1_0_01_00_0_0_0_0_00_00;	//or
	38: mc=14'b1_0_01_00_0_0_0_0_00_00;	//xor
	39: mc=14'b1_0_01_00_0_0_0_0_00_00;	//nor
	42: mc=14'b1_0_01_00_0_0_0_0_00_00;	//slt
	43: mc=14'b1_0_01_00_0_0_0_0_00_00;	//sltu
	default: mc=14'b1_0_00_00_0_0_0_0_00_00;
	endcase

	{special,rsel0_src,rsel2_src,func_src,reg_in,d_in,alu_op,rw,dout_src,j_mode}=mc;
	end
end

assign rsel0=rsel0_src?rt:rs;
assign rsel1=rt;

always@(rsel2_src,rd,rt)
begin
	case(rsel2_src)
		0:rsel2=0;
		1:rsel2=rd;
		2:rsel2=rt;
		3:rsel2=31;
	endcase
end

always@(func_src,funct,opcode[2:0])
begin
	case(func_src)
		0:func=funct;
		1:func=6'b001001;
		2:func={3'b100,opcode[2:0]};
		3:func={3'b101,opcode[2:0]};
	endcase
end

always@(dout_src,shamt,imme,iaddr)
begin
	case(dout_src)
		0:dout=shamt;
		1:dout={16'b0,imme};
		2:dout=imme;
		3:dout={iaddr+1'b1,2'b0};
	endcase
end

assign dfunc=opcode[2:0];
assign bfunc=opcode[1:0];

endmodule
