`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Allderdice
// Engineer: Landon Colaresi
// 
// Create Date:    20:07:25 03/11/2020 
// Design Name: 	 ARPAS PAS Timer
// Module Name:    arpaspast 
// Project Name: 	 Adaptive Resolution Phased Array SONAR
// Target Devices: Numato Mimas Spartan 6 FPGA
// Tool versions:  Xilinx ISE 14.7
// Description: 
//	Phased Array Timing Module
// Dependencies: 
// None
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//	See all docs at github.com/lcol3117/arpas
//////////////////////////////////////////////////////////////////////////////////
module arpaspast(
    input sysclk,
    input pdorun,
    input regdat,
    input regclk,
    input regsla,
    input regslb,
    input rstall,
    output allout
    );
	 wire dra;
	 wire drb;
	 wire drc;
	 wire ftmao;
	 wire ftmbo;
	 wire ftmco;
	 assign drac = (regclk&(~regsla)&(~regslb));
	 assign drbc = (regclk&regsla&(~regslb));
	 assign drcc = (regclk&(~regsla)&regslb);
	 fltmr flmtra (sysclk,pdorun,regdat,drac,rstall,ftmao);
	 fltmr flmtrb (sysclk,pdorun,regdat,drbc,rstall,ftmbo);
	 fltmr flmtrc (sysclk,pdorun,regdat,drcc,rstall,ftmco);
	 assign allout = (pdorun^ftmao)^(ftmbo^ftmco);
	 
endmodule

module srl(
    input s, 
    input r, 
    output q
    );
    wire qt;
    wire qnt;
	 wire inrace;
	 wire tqnt;
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

module bcfour(
	 input i,
	 output soa,
	 output sob,
	 output soc,
	 output sod
	 );
	 wire fab;
	 wire fbc;
	 wire fcd;
	 wire tod;
	 tff fctff1 (i,fab);
	 tff fctff2 (fab,fbc);
	 tff fctff3 (fbc,fcd);
	 tff fctff4 (fcd,tod);
	 assign soa = fab;
	 assign sob = fbc;
	 assign soc = fcd;
	 assign sod = tod;
	 
endmodule

module rbcfour(
	 input si,
	 input srst,
	 input syclk,
	 output sfoa,
	 output sfob,
	 output sfoc,
	 output sfod
	 );
	 wire cnrst;
	 wire crst;
	 wire acbcfd;
	 wire snrstd;
	 wire fsfoa;
	 wire fsfob;
	 wire fsfoc;
	 wire fsfod;
	 assign cnsrt = (~srst)&si;
	 assign crst = srst&(syclk&(snrstd));
	 assign acbcfd = crst|cnrst;
	 bcfour sfrbcf (acbcfd,fsfoa,fsfob,fsfoc,fsfod);
	 assign snrstd = (fsfoa|fsfob)|(fsfoc|fsfod);
	 assign sfoa = fsfoa;
	 assign sfob = fsfob;
	 assign sfoc = fsfoc;
	 assign sfod = fsfod;
	 
endmodule

module bcthirteen(
	 input i,
	 output soa,
	 output sob,
	 output soc,
	 output sod,
	 output soe,
	 output sof,
	 output sog,
	 output soh,
	 output soi,
	 output soj,
	 output sok,
	 output sol,
	 output som
	 );
	 wire fab;
	 wire fbc;
	 wire fcd;
	 wire fde;
	 wire fef;
	 wire ffg;
	 wire fgh;
	 wire fhi;
	 wire fij;
	 wire fjk;
	 wire fkl;
	 wire flm;
	 wire tom;
	 tff fctff1 (i,fab);
	 tff tctff2 (fab,fbc);
	 tff tctff3 (fbc,fcd);
	 tff tctff4 (fcd,fde);
	 tff tctff5 (fde,fef);
	 tff tctff6 (fef,ffg);
	 tff tctff7 (ffg,fgh);
	 tff tctff8 (fgh,fhi);
	 tff tctff9 (fhi,fij);
	 tff tctff10 (fij,fjk);
	 tff tctff11 (fjk,fkl);
	 tff tctff12 (fkl,flm);;
	 tff fctff4 (flm,tom);
	 assign soa = fab;
	 assign sob = fbc;
	 assign soc = fcd;
	 assign sod = fde;
	 assign soe = fef;
	 assign sof = ffg;
	 assign sog = fgh;
	 assign soh = fhi;
	 assign soi = fij;
	 assign soj = fjk;
	 assign sok = fkl;
	 assign sol = flm;
	 assign som = tom;
	 
endmodule

module rbcthirteen(
	 input si,
	 input srst,
	 input syclk,
	 output sfoa,
	 output sfob,
	 output sfoc,
	 output sfod,
	 output sfoe,
	 output sfof,
	 output sfog,
	 output sfoh,
	 output sfoi,
	 output sfoj,
	 output sfok,
	 output sfol,
	 output sfom
	 );
	 wire cnrst;
	 wire crst;
	 wire acbcfd;
	 wire snrstd;
	 wire fsfoa;
	 wire fsfob;
	 wire fsfoc;
	 wire fsfod;
	 wire fsfoe;
	 wire fsfof;
	 wire fsfog;
	 wire fsfoh;
	 wire fsfoi;
	 wire fsfoj;
	 wire fsfok;
	 wire fsfol;
	 wire fsfom;
	 assign cnsrt = (~srst)&si;
	 assign crst = srst&(syclk&(snrstd));
	 assign acbcfd = crst|cnrst;
	 bcthirteen sfrbcf (acbcfd,sfsoa,sfsob,sfsoc,sfsod,sfsoe,sfsof,sfsog,sfsoh,sfsoi,sfsoj,sfsok,sfsol,sfsom);
	 assign snrstd = (sfsoa|sfsob|sfsoc|sfsod|sfsoe|sfsof|sfsog|sfsoh|sfsoi|sfsoj|sfsok|sfsol|sfsom);
	 assign sfoa = fsfoa;
	 assign sfob = fsfob;
	 assign sfoc = fsfoc;
	 assign sfod = fsfod;
	 assign sfoe = fsfoe;
	 assign sfof = fsfof;
	 assign sfog = fsfog;
	 assign sfoh = fsfoh;
	 assign sfoi = fsfoi;
	 assign sfoj = fsfoj;
	 assign sfok = fsfok;
	 assign sfol = fsfol;
	 assign sfom = fsfom;
	 
endmodule

module regthirteen(
	 input sdat,
	 input sclk,
	 input srst,
	 input rsysclk,
	 output a,
	 output b,
	 output c,
	 output d, 
	 output e,
	 output f,
	 output g,
	 output h,
	 output i,
	 output j,
	 output k,
	 output l,
	 output m
	 );
	 wire ta;
	 wire tda;
	 wire tb;
	 wire tdb;
	 wire tc;
	 wire tdc;
	 wire td;
	 wire tdd;
	 wire te;
	 wire tde;
	 wire tf;
	 wire tdf;
	 wire tg;
	 wire tdg;
	 wire th;
	 wire tdh;
	 wire ti;
	 wire tdi;
	 wire tj;
	 wire tdj;
	 wire tk;
	 wire tdk;
	 wire tl;
	 wire tdl;
	 wire tm;
	 wire tdm;
	 wire cdcoa;
	 wire cdcob;
	 wire cdcoc;
	 wire cdcod;
	 rbcfour cdbc (sclk,srst,rsysclk,cdcoa,cdcob,cdcoc,cdcod);
	 assign tda = (~cdcoa)&(~cdcob)&(~cdcoc)&(~cdcod);
	 assign tdb = (~cdcoa)&(~cdcob)&(~cdcoc)&(cdcod);
	 assign tdc = (~cdcoa)&(~cdcob)&(cdcoc)&(~cdcod);
	 assign tdd = (~cdcoa)&(~cdcob)&(cdcoc)&(cdcod);
	 assign tde = (~cdcoa)&(cdcob)&(~cdcoc)&(~cdcod);
	 assign tdf = (~cdcoa)&(cdcob)&(~cdcoc)&(cdcod);
	 assign tdg = (~cdcoa)&(cdcob)&(cdcoc)&(~cdcod);
	 assign tdh = (~cdcoa)&(cdcob)&(cdcoc)&(cdcod);
	 assign tdi = (cdcoa)&(~cdcob)&(~cdcoc)&(~cdcod);
	 assign tdj = (cdcoa)&(~cdcob)&(~cdcoc)&(cdcod);
	 assign tdk = (cdcoa)&(~cdcob)&(cdcoc)&(~cdcod);
	 assign tdl = (cdcoa)&(~cdcob)&(cdcoc)&(cdcod);
	 assign tdm = (cdcoa)&(cdcob)&(~cdcoc)&(~cdcod);
	 dff da (sdat,tda,ta);
	 dff db (sdat,tdb,tb);
	 dff dc (sdat,tdc,tc);
	 dff dd (sdat,tdd,td);
	 dff de (sdat,tde,te);
	 dff df (sdat,tdf,tf);
	 dff dg (sdat,tdg,tg);
	 dff dh (sdat,tdh,th);
	 dff di (sdat,tdi,ti);
	 dff dj (sdat,tdj,tj);
	 dff dk (sdat,tdk,tk);
	 dff dl (sdat,tdl,tl);
	 dff dm (sdat,tdm,tm);
	 assign a = ta;
	 assign b = tb;
	 assign c = tc;
	 assign d = td;
	 assign e = te;
	 assign f = tf;
	 assign g = tg;
	 assign h = th;
	 assign i = ti;
	 assign j = tj;
	 assign k = tk;
	 assign l = tl;
	 assign m = tm;

endmodule

module tmcntr(
	 input tsysclk,
	 input tdorun,
	 input trst,
	 output a,
	 output b,
	 output c,
	 output d,
	 output e,
	 output f,
	 output g,
	 output h,
	 output i,
	 output j,
	 output k,
	 output l,
	 output m
	 );
	 wire ta;
	 wire tb;
	 wire tc;
	 wire td;
	 wire te;
	 wire tf;
	 wire tg;
	 wire th;
	 wire ti;
	 wire tj;
	 wire tk;
	 wire tl;
	 wire tm;
	 wire accdin;
	 assign accdin = tsysclk&tdorun;
	 rbcthirteen tmrbc (accdin,trst,tsysclk,ta,tb,tc,td,te,tf,tg,th,ti,tj,tk,tl,tm);
	 assign a = ta;
	 assign b = tb;
	 assign c = tc;
	 assign d = td;
	 assign e = te;
	 assign f = tf;
	 assign g = tg;
	 assign h = th;
	 assign i = ti;
	 assign j = tj;
	 assign k = tk;
	 assign l = tl;
	 assign m = tm;

endmodule

module fltmr(
	 input ftsysclk,
	 input ftdorun,
	 input ftrdat,
	 input fdrclk,
	 input fdrstall,
	 output thisout
	 );
	 wire roa;
	 wire rob;
	 wire roc;
	 wire rod;
	 wire roe;
	 wire rof;
	 wire rog;
	 wire roh;
	 wire roi;
	 wire roj;
	 wire rok;
	 wire rol;
	 wire litrom;
	 wire tmoa;
	 wire tmob;
	 wire tmoc;
	 wire tmod;
	 wire tmoe;
	 wire tmof;
	 wire tmog;
	 wire tmoh;
	 wire tmoi;
	 wire tmoj;
	 wire tmok;
	 wire tmol;
	 wire tmom;
	 wire xnoroa;
	 wire xnorob;
	 wire xnoroc;
	 wire xnorod;
	 wire xnoroe;
	 wire xnorof;
	 wire xnorog;
	 wire xnoroh;
	 wire xnoroi;
	 wire xnoroj;
	 wire xnorok;
	 wire xnorol;
	 wire xnolitrom;
	 tmcntr fttmcntr (ftsysclk,ftdorun,ftrstall,tmoa,tmob,tmoc,tmod,tmoe,tmof,tmog,tmoh,tmoi,tmoj,tmok,tmol,tmom);
	 regthirteen ftreg (ftrdat,ftrclk,ftrstall,ftsysclk,roa,rob,roc,rod,roe,rof,rog,roh,roi,roj,rok,rol,litrom);
	 assign xnoroa = ~(roa^tmoa);
	 assign xnorob = ~(rob^tmob);
	 assign xnoroc = ~(roc^tmoc);
	 assign xnorod = ~(rod^tmod);
	 assign xnoroe = ~(roe^tmoe);
	 assign xnorof = ~(rof^tmof);
	 assign xnorog = ~(rog^tmog);
	 assign xnoroh = ~(roh^tmoh);
	 assign xnoroi = ~(roi^tmoi);
	 assign xnoroj = ~(roj^tmoj);
	 assign xnorok = ~(rok^tmok);
	 assign xnorol = ~(rol^tmol);
	 assign xnolitrom = ~(litrom^tmom);
	 assign thisout = (xnoroa&xnorob&xnoroc&xnorod&xnoroe&xnorof&xnorog&xnoroh&xnoroi&xnoroj&xnorok&xnorol&xnolitrom);
	 
endmodule

//END
