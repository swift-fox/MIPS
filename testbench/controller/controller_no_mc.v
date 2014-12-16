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
reg rw;
reg [2:0] dfunc;
reg [1:0] bfunc;
reg [4:0] rsel0,rsel1,rsel2;
reg [5:0] func;
reg alu_op,reg_in,d_in;

wire [5:0] opcode;
wire [4:0] rs,rt,rd;
wire [4:0] shamt;
wire [5:0] funct;
wire signed [15:0] imme;
wire [25:0] offset;

initial
begin
	$readmemh("microcode.hex",opcode_mc);
	$readmemh("microcode.hex",special_mc);
end

always@(_reset)
begin
	if(~_reset)
	begin
		iaddr=30'h3fffffff;
		{dout,rw,dfunc,bfunc,rsel0,rsel1,rsel2,func,alu_op,reg_in,d_in,j_mode}=0;
	end
end

always@(posedge clk)
begin
	case(j_mode)
	0:iaddr=iaddr+1;
	1:iaddr=iaddr+(din[0]?imme:1);
	2:iaddr={iaddr[31:28],offset};
	3:iaddr=din[31:2];
	endcase
end

assign {opcode,rs,rt,rd,shamt,funct}=inst;
assign imme=inst[15:0];
assign offset=inst[25:0];

reg[63:0] opcode_mc[0:63];
reg[63:0] special_mc[0:63];

reg[1:0] j_mode;

wire special,regimm,j,jal,beq,bne,blez,bgtz,
addi,addiu,slti,sltiu,andi,ori,xori,lui,
cop0,cop1,r1,cop1x,r2,r3,r4,r5,
r6,r7,r8,r9,special2,r10,r11,r12,
lb,lh,lwl,lw,lbu,lhu,lwr,r13,
sb,sh,swl,sw,r14,r15,swr,cache,
ll,lwc1,r16,perf,r17,ldc1,r18,r19,
sc,swc1,r20,r21,r22,sdc1,r23,r24;

assign {special,regimm,j,jal,beq,bne,blez,bgtz,addi,addiu,slti,sltiu,andi,ori,xori,lui,cop0,cop1,r1,cop1x,r2,r3,r4,r5,r6,r7,r8,r9,special2,r10,r11,r12,lb,lh,lwl,lw,lbu,lhu,lwr,r13,sb,sh,swl,sw,r14,r15,swr,cache,ll,lwc1,r16,perf,r17,ldc1,r18,r19,sc,swc1,r20,r21,r22,sdc1,r23,r24}=opcode_mc[opcode];

wire sll,movci,srl,sra,sllv,r25,srlv,srav,
jr,jalr,movz,movn,syscall,break,r26,sync,
mfhi,mthi,mflo,mtlo,r27,r28,r29,r30,
mult,multu,div,divu,r31,r32,r33,r34,
add,addu,sub,subu,_and,_or,_xor,_nor,
r35,r36,slt,sltu,r37,r38,r39,r40,
tge,tgeu,tlt,tltu,teq,r41,tne,r42,
r43,r44,r45,r46,r47,r48,r49,r50;

assign {sll,movci,srl,sra,sllv,r25,srlv,srav,jr,jalr,movz,movn,syscall,break,r26,sync,mfhi,mthi,mflo,mtlo,r27,r28,r29,r30,mult,multu,div,divu,r31,r32,r33,r34,add,addu,sub,subu,_and,_or,_xor,_nor,r35,r36,slt,sltu,r37,r38,r39,r40,tge,tgeu,tlt,tltu,teq,r41,tne,r42,r43,r44,r45,r46,r47,r48,r49,r50}=(special?special_mc[funct]:0);

always@(*)
begin
	{dout,rw,dfunc,bfunc,rsel0,rsel1,rsel2,func,alu_op,reg_in,d_in,j_mode}=0;

	if(add||addu||sub||subu||_and||_nor||_or||sllv||slt||sltu||srav||srlv||_xor||div||divu||mult||multu||mfhi||mflo||mthi||mtlo||movn||movz||jalr||jr)
	begin
		rsel0=rs;
		rsel1=rt;
		rsel2=rd;
		func=funct;
	end

	if(sll||sra||srl)
	begin
		alu_op=1;
		rsel0=rt;
		rsel2=rd;
		func=funct;
		dout={27'b0,shamt};
	end

	if(addi||addiu||andi||ori||slti||sltiu||xori)
	begin
		alu_op=1;
		rsel0=rs;
		rsel2=rt;
		func={2'b10,(slti||sltiu)?1'b1:1'b0,opcode[2:0]};
	end

	if(addi||addiu||slti||sltiu)
	begin
		dout=imme;
	end

	if(andi||ori||xori)
	begin
		dout=imme[15:0];
	end

	if(lb||lbu||lh||lhu||lwl||lw||lwr||lui||sb||sh||swl||sw||swr)
	begin
		dout=imme[15:0];
		rsel0=rs;
		dfunc=opcode[2:0];
		if(sb||sh||swl||sw||swr)
		begin
			rsel1=rt;
			rw=1;
		end
		else
		begin
			rsel2=rt;
			reg_in=1;
		end
	end

	if(beq||bne||blez||bgtz)
	begin
		j_mode=1;
		rsel0=rs;
		rsel1=rt;
		bfunc=opcode[1:0];
		d_in=1;
	end

	if(j||jal)
	begin
		j_mode=2;
		if(jal)
		begin
			rsel2=31;
			func='b001001;
		end
	end

	if(jalr||jr) j_mode=3;

	if(jalr||jal)
	begin
		dout={iaddr+1'b1,2'b0};
		alu_op=1;
	end
end

endmodule
