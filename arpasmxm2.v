`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:58 05/18/2020 
// Design Name: 
// Module Name:    arpasmxm2 
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
module arpasmxm2(
    input sig,
    input inc,
    output out00,
    output out01,
    output out10,
    output out11
    );
	 wire bit1;
	 wire bit2;
	 bincount2 bincounter (inc,bit1,bit2);
	 wire a;
	 wire b;
	 wire c;
	 wire d;
	 bit2mux arpas_2mux (bit1,bit2,a,b,c,d);
	 wire reswhena;
	 wire reswhenb;
	 wire reswhenc;
	 wire reswhend;
	 andarray res_andarray (a,b,c,d,sig,reswhena,reswhenb,reswhenc,reswhend);
	 assign out00 = reswhena;
	 assign out01 = reswhenb;
	 assign out10 = reswhenc;
	 assign out11 = reswhend;

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

module bincount2(
	 input inc,
	 output bit1,
	 output bit2
	 );
	 wire w12;
	 wire w2o;
	 tff bctff1 (inc,w12);
	 tff bctff2 (w12,w2o);
	 assign bit1 = w12;
	 assign bit2 = w2o;
	 
endmodule

module bit2mux (
	 input bit1,
	 input bit2,
	 output a,
	 output b,
	 output c,
	 output d
	 );
	 wire isa;
	 wire isb;
	 wire isc;
	 wire isd;
	 assign isa = (~bit1)&(~bit2);
	 assign isb = (bit1)&(~bit2);
	 assign isc = (~bit1)&(bit2);
	 assign isd = (bit1)&(bit2);
	 assign a = isa;
	 assign b = isb;
	 assign c = isc;
	 assign d = isd;

endmodule

module andarray(
	 input a1,
	 input b1,
	 input c1,
	 input d1,
	 input a2,
	 output oa,
	 output ob,
	 output oc,
	 output od
	 );
	 wire toa;
	 wire tob;
	 wire toc;
	 wire tod;
	 assign toa = a1&a2;
	 assign tob = b1&a2;
	 assign toc = c1&a2;
	 assign tod = d1&a2;
	 assign oa = toa;
	 assign ob = tob;
	 assign oc = toc;
	 assign od =tod;

endmodule
