`timescale 1ns/1ps

module decoder( 
  output wire [3:0] alu_opD,
  
  input wire btnrD, 
  input wire btnlD,
  input wire btncD
);
 
  
  // internal nets
  wire btnrNOT , btnlNOT , btncNOT ; 
  wire A0,A1,A2,A3,A4,A5,A6 ; 
  wire B0,B1,B2,B3,B4 ; 
  
  
  // Production of alu_op[0] 
  not U0 (btnrNOT,btnrD) ; 
  and U1 (A0,btnlD,btnrNOT) ; 
  xor U2 (B0,btnlD,btncD) ; 
  and U3 (A1,B0,btnrD) ;
  
  or Result1 (alu_opD[0],A0,A1) ;
  
  // Production of alu_op[1] 
  not U4 (btnlNOT,btnlD) ;
  not U5 (btncNOT,btncD) ;
  and U6 (A2,btnrD,btnlD) ; 
  and U7 (A3,btnlNOT,btncNOT) ;
  
  or Result2 (alu_opD[1],A2,A3) ;
  
  // Production of alu_op[2] 
  and U8 (B1,btnrD,btnlD) ;
  xor U9 (B2,btnrD,btnlD) ; 
  not U10 (A5,btncD) ;
  or U11 (A4,B1,B2) ;
  
  and Result3 (alu_opD[2],A4,A5) ; 
  
  // Production of alu_op[3] 
  not U12 (btnrNOT,btnrD) ;
  xnor U13 (B3,btnrD,btncD) ;
  and U14 (B4,btnrNOT,btncD) ; 
  or U15 (A6,B3,B4) ;
  
  and Result3 (alu_opD[3],A6,btnlD) ;
  
endmodule
