`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Allderedice HS
// Engineer: Landon Colaresi
// 
// Create Date:    11:57:15 05/25/2020 
// Design Name: ARPAS FPGA v4
// Module Name:    arpasmxm4 
// Project Name: ARPAS
// Target Devices: Numato Mimas
// Tool versions: Xilinx ISE 14.7
// Description:
// Adaptive
// Resolution
// Phased
// Array
// SONAR
// Dependencies: 
// None
// Revision: v4.0.01
// Revision 0.01 - File Created
// Additional Comments: 
// None
//////////////////////////////////////////////////////////////////////////////////
module arpasmxm4(
    input left,
    input right,
    output first
    );
	 wire srlout;
	 wire either;
	 wire toout;
	 wire b1mux0;
	 wire b1mux1;
	 wire swap0;
	 wire swap1;
	 wire tordff;
	 srl arpassrl (left,right,srlout);
	 bit1mux arpasbit1mux (srlout,b1mux0,b1mux1);
	 swap arpasswap (b1mux0,b1mux1,swap0,swap1);
	 k arpask (swap0,swap1,tordff);
	 assign either = left|right;
	 rdff arpasrdff (tordff,either,toout);
	 assign first = toout;

endmodule

module srl(
    input s, 
    input r, 
    output q
    );
    wire qt;
    wire qnt;
	 wire inrace;
	 wire atqnt;
	 assign inrace = qt&qnt;
	 assign atqnt = r|inrace;
    assign qnt = ~(atqnt&qt);
    assign qt = ~(s&qnt);
    assign q = qt;
	 
endmodule

module rdff(
    input d, 
    input c, 
    output q
    );
	 wire ca;
	 wire tdb;
	 wire cb;
	 wire trdffq;
	 wire invclk;
	 assign invclk = ~c;
	 assign ca = invclk;
	 assign cb = ~invclk;
	 dff rdffdff1 (d,ca,tdb);
	 dff rdffdff2 (tdb,cb,trdffq);
	 assign q = trdffq;
	 
endmodule

module dff(
	 input d,
	 input c,
	 output q
	 );
	 wire srl1;
	 wire srl2;
	 wire tq;
	 assign srl1 = (d&c);
	 assign srl2 = ((~d)&c);
	 srl dffsrl (srl1,srl2,tq);
	 assign q = tq;
	 
endmodule

module bit1mux (
	 input bit1,
	 output a,
	 output b
	 );
	 wire isa;
	 wire isb;
	 assign isa = (~bit1);
	 assign isb = (bit1);
	 assign a = isa;
	 assign b = isb;

endmodule

module k (
	 input x,
	 input y,
	 output q
	 );
	 wire toq;
	 assign toq = x;
	 assign q = toq;
	 
endmodule

module swap (
	 input ia,
	 input ib,
	 output oa,
	 output ob
	 );
	 wire toa;
	 wire tob;
	 assign toa = ib;
	 assign tob = ia;
	 assign oa = toa;
	 assign ob = tob;

endmodule
