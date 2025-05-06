`timescale 1ns/1ps

module regfile #(parameter DATAWIDTH = 32, parameter NumRegs = 32)(
    input wire clk,
    input wire [4:0] readReg1,
    input wire [4:0] readReg2,
    input wire [4:0] writeReg,
    input wire [DATAWIDTH - 1:0] writeData,
    input wire write,
  
    output reg [DATAWIDTH - 1:0] readData1,
    output reg [DATAWIDTH - 1:0] readData2
);

  // Register file (32 words, length 32 bits)
  reg [DATAWIDTH - 1:0] registers [0:NumRegs - 1]; 
  integer i;
  
  initial begin 
    for (i = 0; i < NumRegs; i++) 
      registers [i] = 0; //Initialize registers to 0 
  end 
  
  always @(posedge clk) begin
      
      //Reading the register values from every output
      readData1 <= register[readReg1];
      readData2 <= register[readReg2];
     
      if (write && writeReg != 0) 
        begin
          register[writeReg] <= writeData;
          
            if (readReg1 == writeReg)    //If write address is the same as read address1
             readData1 <= writeData;
            if (readReg2 == writeReg)    //If write address is the same as read address2
             readData2 <= writeData;
        end
  end
  
endmodule  
  
