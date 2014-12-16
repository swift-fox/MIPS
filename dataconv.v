module dataconv(base,offset,func,rin,din,out,addr,rw);
input [31:0] rin,din;
input signed [31:0] base;
input signed [15:0] offset;
input [2:0] func;
input rw;
output [31:0] out;
output [31:2] addr;

reg [31:0] out;

wire [31:0] _addr,in,_in;
wire signed [15:0] halfword;
wire signed [7:0] byte;

assign in=rw?rin:din;
assign _in=rw?din:rin;

assign _addr=base+offset;
assign addr=_addr[31:2];

assign halfword=_addr[1]?in[31:16]:in[15:0];
assign byte=_addr[0]?halfword[15:8]:halfword[7:0];

`define b  'b000
`define h  'b001
`define wl 'b010
`define w  'b011
`define bu 'b100
`define hu 'b101
`define wr 'b110
`define ui 'b111

always@(func,offset,byte,halfword,in,_in,_addr[1:0],rw)
begin
	case(func)
	`b:
	if(rw)
		case(_addr[1:0])
		0: out<={_in[31:8],in[7:0]};
		1: out<={_in[31:16],in[7:0],_in[7:0]};
		2: out<={_in[31:24],in[7:0],_in[15:0]};
		3: out<={in[7:0],_in[23:0]};
		endcase
	else out<=byte;
	`h:
	if(rw) out<=_addr[1]?{in[15:0],_in[15:0]}:{_in[31:16],in[15:0]};
	else out<=halfword;
	`wl:
	begin
		if(rw)
			case(_addr[1:0])
			0: out<={_in[31:8],in[31:24]};
			1: out<={_in[31:16],in[31:16]};
			2: out<={_in[31:24],in[31:8]};
			3: out<=in[31:0];
			endcase
		else
			case(_addr[1:0])
			0: out<={in[7:0],_in[23:0]};
			1: out<={in[15:0],_in[15:0]};
			2: out<={in[23:0],_in[7:0]};
			3: out<=in[31:0];
			endcase
	end
	`w:  out<=in;
	`bu: out<=byte[7:0];
	`hu: out<=halfword[15:0];
	`wr:
	begin
		if(rw)
			case(_addr[1:0])
			0: out<=in[31:0];
			1: out<={in[23:0],_in[7:0]};
			2: out<={in[15:0],_in[15:0]};
			3: out<={in[7:0],_in[23:0]};
			endcase
		else
			case(_addr[1:0])
			0: out<=in[31:0];
			1: out<={_in[31:24],in[31:8]};
			2: out<={_in[31:16],in[31:16]};
			3: out<={_in[31:8],in[31:24]};
			endcase
	end
	`ui: out<={offset,16'b0};
	endcase
end

endmodule
