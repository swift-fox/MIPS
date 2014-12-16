module processor(_reset,clk);
input _reset,clk;

wire[31:0] idata,dout,din,r0,r1,r2,alu_out,alu_in1,dc_out,dc_din;
wire[31:2] iaddr,daddr;
wire[5:0] afunc;
wire[4:0] rsel0,rsel1,rsel2;
wire[2:0] dfunc;
wire[1:0] bfunc;
wire rw,alu_op,reg_in,d_in,bu_out;

controller c(_reset,clk,idata,iaddr,rw,dfunc,bfunc,rsel0,rsel1,rsel2,afunc,alu_op,reg_in,d_in,dout,din);
regfile r(_reset,clk,r0,r1,r2,rsel0,rsel1,rsel2);
alu a(alu_out,r0,alu_in1,afunc);
bu b(r0,r1,bfunc,bu_out);
dataconv dc(r0,dout[15:0],dfunc,r1,dc_din,dc_out,daddr,rw);
icache i(iaddr,idata);
dcache d(clk,rw,daddr,dc_out,dc_din);
mux m_reg(r2,alu_out,dc_out,reg_in);
mux m_din(din,r0,{31'b0,bu_out},d_in);
mux m_alu(alu_in1,r1,dout,alu_op);

endmodule
