`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: None (Allderdice)
// Engineer: Landon Colaresi
// 
// Create Date:    18:24:26 01/21/2020 
// Design Name: ARPAS-FPGA
// module Name:    arpasverilog 
// Project Name: ARPAS
// Target Devices: Numato Mimas (XC6SLX9-3TQG144)
// Tool versions: 
// Description: 
//   Adaptive Resolution Phased Array SONAR
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module arpasverilog(
    output FWRWRDD,
    input REGDATA,
    input REGCLKS,
    input PADORUN,
    input AREGSEL,
    input PHAMUXA,
    input PHAMUXB,
    input RSTALLD,
    output NEXTSIG,
    input ISYSCLK
    );


endmodule

module srl(
    input s, 
    input r, 
    output q);
    
    wire qt;
    wire qnt;
    assign qnt = ~(s&qt);
    assign qt = ~(r&qnt);
    assign q = qt;
endmodule

module dff(
    input d, 
    input c, 
    output q);
    
    wire sd;
    wire rd;
    assign sd = ~(d&c);
    assign rd = ~((~d)&c);
    srl dffsrl1(sd,rd,q);
endmodule

module rdff(
    input d, 
    input c, 
    output q);
    
    wire tao;
    wire fsd;
    wire frd;
    wire mt;
    wire tt;
    srl rdffsrl1(tt,c,mt);
    assign tao = mt&c;
    srl rdffsrl2(d,tao,fsd);
    assign frd = mt;
    srl rdffsrl3(fsd,frd,q);
endmodule

module tff(
    input tfft, 
    output tffq);
    
    wire qn;
    rdff rdff1(qn,tfft,tffq);
    assign qn = ~tffq;
endmodule

module pamux(
    input a, 
    input b, 
    input ia,
    input ib,
    input ic,
    input id,
    output oa,
    output ob,
    output oc,
    output od);
    
    wire iaoa;
    wire iaob;
    wire iaoc;
    wire iaod;
    assign iaoa = ia&((~a)&(~b));
    assign iaob = ib&((a)&(~b));
    assign iaoc = ic&((~a)&(b));
    assign iaod = id&(a&b);
    assign oa = (iaoa|iaob)|(iaoc|iaod);
    wire iboa;
    wire ibob;
    wire iboc;
    wire ibod;
    assign iboa = ib&((~a)&(~b));
    assign ibob = ia&((a)&(~b));
    assign iboc = id&((~a)&(b));
    assign ibod = ic&(a&b);
    assign ob = (iboa|ibob)|(iboc|ibod);
    wire icoa;
    wire icob;
    wire icoc;
    wire icod;
    assign icoa = ic&((~a)&(~b));
    assign icob = id&((a)&(~b));
    assign icoc = ia&((~a)&(b));
    assign icod = ib&(a&b);
    assign oc = (icoa|icob)|(icoc|icod);
    wire idoa;
    wire idob;
    wire idoc;
    wire idod;
    assign daoa = id&((~a)&(~b));
    assign idob = ic((a)&(~b));
    assign idoc = ib&((~a)&(b));
    assign idod = ia&(a&b);
    assign od = (idoa|idob)|(idoc|idod);

endmodule

module bceighteen(
    input i,
    output coa,
	 output cob,
	 output coc,
	 output cod,
	 output coe,
	 output cof,
	 output cog,
	 output coh,
	 output coi
	 output coj,
	 output cok,
	 output col,
	 output com,
	 output con,
	 output coo,
	 output cop,
	 output coq);
    
    wire tcoa;
	 wire tcob;
	 wire tcoc;
	 wire tcod;
	 wire tcoe;
	 wire tcof;
	 wire tcog;
	 wire tcoh;
	 wire tcoi;
	 wire tcoj;
	 wire tcok;
	 wire tcol;
	 wire tcom;
	 wire tcon;
	 wire tcoo;
	 wire tcop;
	 wire tcoq;
	 dff cdff1(i,tcoa);
	 dff cdff2(tcoa,tcob);
	 dff cdff2(tcoa,tcob);
    dff cdff3(tcob,tcoc);
    dff cdff4(tcoc,tcod);
    dff cdff5(tcod,tcoe);
    dff cdff6(tcoe,tcof);
    dff cdff7(tcof,tcog);
    dff cdff8(tcog,tcoh);
    dff cdff9(tcoh,tcoi);
    dff cdff10(tcoi,tcoj);
    dff cdff11(tcoj,tcok);
    dff cdff12(tcok,tcol);
    dff cdff13(tcol,tcom);
    dff cdff14(tcom,tcon);
    dff cdff15(tcon,tcoo);
    dff cdff16(tcoo,tcop);
    dff cdff17(tcop,tcoq);
	 assign coa = tcoa;
	 assign cob = tcob;
	 assign coc = tcoc;
	 assign cod = tcod;
	 assign coe = tcoe;
	 assign cof = tcof;
	 assign cog = tcog;
	 assign coh = tcoh;
	 assign coi = tcoi;
	 assign coj = tcoj;
	 assign cok = tcok;
	 assign col = tcol;
	 assign com = tcom;
	 assign con = tcon;
	 assign coo = tcoo;
	 assign cop = tcop;
	 assign coq = tcoq;

endmodule
