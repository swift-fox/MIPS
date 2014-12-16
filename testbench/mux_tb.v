module mux_tb();
mux m(out,in0,in1,sel);
reg[31:0] in0,in1;
reg sel;
wire[31:0] out;

initial
begin
	in0='h00001111;
	in1='h1111000z;

	sel=0;
	#1
	$display("%h",out);

	sel=1;
	#1
	$display("%h",out);
end
endmodule
