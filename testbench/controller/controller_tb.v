module controller_tb();
controller c(_reset,clk,inst,iaddr,rw,dfunc,bfunc,rsel0,rsel1,rsel2,func,alu_op,reg_in,d_in,dout,din);
icache i(_iaddr,inst);
reg _reset,clk;
reg [31:0] din;
reg [31:2] _iaddr;
wire [31:2] iaddr;
wire [31:0] dout,inst;
wire rw;
wire [2:0] dfunc;
wire [1:0] bfunc;
wire [4:0] rsel0,rsel1,rsel2;
wire [5:0] func;
wire alu_op,reg_in,d_in;

always
begin
#2
clk=~clk;
end

always@(posedge clk)
begin
_iaddr=_iaddr+1;
end

initial
begin
	clk=0;
	_iaddr=30'h3fffffff;

	_reset=0;
	#1
	_reset=1;

	@(posedge clk)
	$display("add r1,r2,r3");

	@(posedge clk)
	$display("sll 5,r2,r3");

	@(posedge clk)
	$display("addi -32761,r1,r2");

	@(posedge clk)
	$display("addi 7,r1,r2");

	@(posedge clk)
	$display("lbu r1+7,r2");

	@(posedge clk)
	$display("lui 7,r2");

	@(posedge clk)
	$display("sb r1+1,r2");

	@(posedge clk)
	$display("bne r7,r8,-9");

	#3 din=0;

	@(posedge clk)
	$display("blez r7,9");

	#3 din=1;

	@(posedge clk)
	$display("j 3fffff");

	@(posedge clk)
	$display("j 000000");

	@(posedge clk)
	$display("j 3fffff");

	@(posedge clk)
	$display("jal 000fff");

	@(posedge clk)
	$display("jalr r3,r7");

	#3 din=32'hbf800000;

	@(posedge clk)
	$display("jr r5");

	@(posedge clk);

	@(posedge clk)
	$finish();
end

always@(posedge clk)
begin
	#1
	$display("inst: %b_%d_%d_%d_%d_%b imme %d",c.opcode,c.rs,c.rt,c.rd,c.shamt,c.funct,c.imme);
	$display("reg: rs %d rt %d rd %d",rsel0,rsel1,rsel2);
	$display("func: a %b b %b d %b",func,bfunc,dfunc);
	$display("mux: alu_op %b reg_in %b d_in %b",alu_op,reg_in,d_in);
	$display("rw: %b",rw);
	$display("iaddr: %h",{iaddr,2'b0});
	$display("j_mode: %h din: %h",c.j_mode,c.din);
	$display("dout: %h",dout);
	$display("");
end

endmodule
