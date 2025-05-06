`timescale 1ns/1ps

module datapath (
    input wire clk,
    input wire rst,
    input wire [31:0] instr,
    input wire PCSrc,
    input wire ALUSrc,
    input wire RegWrite,
    input wire MemtoReg,
    input wire [3:0] ALUCtrl,
    input wire loadPC,
    input wire [31:0] dReadData,
    
    output reg [31:0] PC,
    output reg Zero,
    output reg [31:0] dAddress,
    output reg [31:0] dWriteData,
    output reg [31:0] WriteBackData
);
  
  reg [4:0] readReg1_data ;
  reg [4:0] readReg2_data ;
  reg [4:0] writeReg_data ;

  // Parameter
  parameter [31:0] INITIAL_PC = 32'h00400000 ;
  parameter [31:0] PC_UPDATE = 32'h00000004 ;
  parameter SIGN_EXTEND_VALUE = 20 ;
  
  wire ZeroALU ;
  
  initial begin 
    Zero = 0 ;
  end 
  
  always@(posedge clk) begin 
    Zero <= ZeroALU ;
  end 
  
  // Decoding logic to specify the values in the address ports of the register  file
  initial 
    begin 
      readReg1_data = instr[19:15] ;
      readReg2_data = instr[24:20] ;
      writeReg_data = instr[11:7] ;
    end  
  
  always @(posedge clk or instr)
    begin
      readReg1_data = instr[19:15] ;
      readReg2_data = instr[24:20] ;
      writeReg_data = instr[11:7] ;
    end
  
  reg [31:0] immI, immS, immB;
     
  // This gets the immediate data for type I and type S
  initial 
     begin 
      immI = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[31:20]};
      immS = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[31:25],   
               instr[11:7]} ;
      immB = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[7], 
               instr[31:25], instr[11:8], 1'b0} ; 
     end
  
  always @(instr)
    begin
      immI = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[31:20]};
      immS = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[31:25],   
               instr[11:7]} ;
      immB = {{SIGN_EXTEND_VALUE{instr[31]}}, instr[7], 
               instr[31:25], instr[11:8], 1'b0} ; 
    end

  
   // This is where PC gets its initial values if rst goes high
   // This is also where PC gets updated according the loadPC and PCSrc
  always @(posedge clk or rst)
   begin
     if (rst)
        begin
           PC <= INITIAL_PC;
        end
     else if (loadPC)
        begin
           if (PCSrc)
              begin
                PC <= PC + immB ;
              end
            else
              begin
                PC <= PC + PC_UPDATE;
              end
        end        
    end
  
  
  wire [31:0] outReadData1, outReadData2 ;
    
  // This is where regfile is called
  regfile RegisterFile (.clk(clk), 
                        .readReg1(readReg1_data), 
                        .readReg2(readReg2_data),  
                        .writeReg(writeReg_data), 
                        .writeData(WriteBackData), 
                        .write(RegWrite), 
                        .readData1(outReadData1), 
                        .readData2(outReadData2) );
  
  reg [31:0] op1_ALU ; 
  reg [31:0] op2_ALU ;
  
   // Multiplexer to select between outReadData2 and toOp2 based on ALUSrc
  always @(posedge clk or outReadData2 or op2_ALU)
    begin
      if (ALUSrc==1)
          op2_ALU= immI ;
      else
          op2_ALU = outReadData2 ;
    end
    
  wire [31:0] aluResult;
  
  // This is where alu is called
  alu myALU (
       .alu_op(ALUCtrl),
       .op1(outReadData1),
       .op2(op2_ALU),
       .zero(ZeroALU),
       .result(aluResult)
    );
  
  // Set dAddress to aluResult and dWriteData to outReadData2
  always @(posedge clk)
    begin
        dAddress = aluResult ;
        dWriteData = outReadData2 ;
    end
    
    // This is the multiplexer that gives writebackdata the correct value according to memtoreg value 
  always @(posedge clk)
    begin
        if(MemtoReg)
            WriteBackData <= dReadData ;
        else 
            WriteBackData <= aluResult ;    
    end
  
endmodule