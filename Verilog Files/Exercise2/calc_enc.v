module calc_enc(input wire btnr, btnc, btnl, output wire [3:0] alu_op);
  
  wire btnr_n, btnc_n, btnl_n;
  wire m0,m1,m2,m3,m4,m5,m6,m8,m9,m10;
  
  not u1 (btnr_n, btnr);
  not u2 (btnc_n, btnc);
  not u3 (btnl_n, btnl);
  
  and u4 (m0, btnc_n, btnr);
  and u5 (m1, btnl, btnr);
  
  and u6 (m2, btnl_n, btnc);
  and u7 (m3, btnc, btnr_n);
  
  and u8 (m4, btnc, btnr);
  and u9 (m5, btnc_n, btnl);
  and u10 (m6, m5, btnr_n);
  
  and u11 (m7, btnl, btnc_n);
  and u12 (m8, m7, btnr);
  and u13 (m9, btnc, btnl);
  and u14 (m10, m9, btnr_n);

  or u15 (alu_op[0], m0, m1);
  or u16 (alu_op[1], m2, m3);
  or u17 (alu_op[2], m4, m6);
  or u18 (alu_op[3], m8, m10); 
endmodule
