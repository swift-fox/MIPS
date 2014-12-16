module bu(in0,in1,func,out);
input signed [31:0] in0,in1;
input [1:0] func;
output out;

reg out;

`define eq 'b00
`define ne 'b01
`define le 'b10
`define gt 'b11

always@(func,in0,in1)
begin
	case(func)
	`eq: out=(in0==in1);
	`ne: out=(in0!=in1);
	`le: out=(in0<=in1);
	`gt: out=(in0>in1);
	endcase
end

endmodule
