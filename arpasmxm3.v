`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:20:27 05/19/2020 
// Design Name: 
// Module Name:    arpasmxm3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module arpasmxm3(
    input sig,
    input inc,
    input rev,
    output left,
    output right
    );
	 wire stateout;
	 reversabletff statertff (inc,rev,stateout);
	 wire state0;
	 wire state1;
	 bit1mux statemux (stateout,state0,state1);
	 wire reswhen0;
	 wire reswhen1;
	 andarray mxarray (state0,state1,sig,reswhen0,reswhen1);
	 assign left = reswhen0;
	 assign right = reswhen1;

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

module tff(
	 input t,
	 output q
	 );
	 wire rev;
	 wire toq;
	 rdff trdff (rev,t,toq);
	 assign rev = ~toq;
	 assign q = toq;
	 
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

module andarray(
	 input a1,
	 input b1,
	 input a2,
	 output oa,
	 output ob
	 );
	 wire toa;
	 wire tob;
	 assign toa = a1&a2;
	 assign tob = b1&a2;
	 assign oa = toa;
	 assign ob = tob;

endmodule

module reversabletff(
	 input t,
	 input reversed,
	 output q
	 );
	 wire reswhen0;
	 wire reswhen1;
	 tff rtfftff (t,reswhen0);
	 assign reswhen1 = ~reswhen0;
	 wire reversed0;
	 wire reversed1;
	 bit1mux rtffmux (reversed,reversed0,reversed1);
	 wire outwhen0;
	 wire outwhen1;
	 assign outwhen0 = reversed0&reswhen0;
	 assign outwhen1 = reversed1&reswhen1;
	 wire out;
	 assign out = outwhen1|outwhen0;
	 assign q = out;
	 
endmodule
