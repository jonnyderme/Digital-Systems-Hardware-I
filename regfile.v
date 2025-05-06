`timescale 1ns/1ps

module regfile(
    input wire clk,
    input wire [4:0] readReg1,
    input wire [4:0] readReg2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    input wire write,
    
    output reg [31:0] readData1,
    output reg [31:0] readData2
);

  // Register file (32 words, length 32 bits)
  reg [31:0] register [0:31];
   
  // Initialize the 32 words to zero
  integer i;
  initial begin
     for (i=0; i<32; i=i+1)
         register[i] = 0;
  end
  
  always @(posedge clk) begin
      readData1 <= register[readReg1];
      readData2 <= register[readReg2];
     
      if (write && writeReg != 0) 
        begin
          register[writeReg] <= writeData;
          if (readReg1 == writeReg)
             readData1 <= writeData;
          if (readReg2 == writeReg)
             readData2 <= writeData;
        end
  end
  
endmodule  
  