`timescale 1ns/1ps

module alu(
   input wire [31:0] op1,op2,  // ALU 32-bit Inputs                 
   input wire [3:0] alu_op,     // ALU Selection
   
   output reg [31:0] result,    // ALU 32-bit Output
   output reg zero 
);
  
  parameter [3:0] ALUOP_AND = 4'b0000 ; 
  parameter [3:0] ALUOP_OR = 4'b0001 ;
  parameter [3:0] ALUOP_ADD = 4'b0010 ;
  parameter [3:0] ALUOP_SUB = 4'b0110 ;
  parameter [3:0] ALUOP_LESS = 4'b0111 ;
  parameter [3:0] ALUOP_LRSHIFT = 4'b1000 ; 
  parameter [3:0] ALUOP_LLSHIFT = 4'b1001 ;
  parameter [3:0] ALUOP_NRSHIFT = 4'b1010 ; 
  parameter [3:0] ALUOP_XOR = 4'b1101 ; 
    
  
  always @(alu_op or op1 or op2)
    begin
      case(alu_op)
        ALUOP_AND: // Logic AND
           result = op1 & op2 ; 
        ALUOP_OR: // Logic OR
           result = op1 | op2 ; 
        ALUOP_ADD: // Signed Addition 
           result = op1 + op2 ;
        ALUOP_SUB: // Signed Substraction
           result = op1 - op2 ;
        ALUOP_LESS: // Less than
           result = $signed(op1) < $signed(op2);
        ALUOP_LLSHIFT: // Logical shift left
          result = op1 << op2[4:0] ;
        ALUOP_LRSHIFT: // Logical shift right
          result = op1 >> op2[4:0] ;
        ALUOP_NRSHIFT: // Numerical shift right
          result = $unsigned($signed(op1) >>> op2[4:0]);
        ALUOP_XOR: // Logic XOR
          result = op1 ^ op2 ;
        default: 
          result = 0 ;
       endcase
    end
       
  // if result is value 0 then set zero to high
  // else set it to low
  always @(result) 
    begin
      if (result == 0)
         zero = 1 ; 
      else
         zero = 0 ; 
  end
endmodule
