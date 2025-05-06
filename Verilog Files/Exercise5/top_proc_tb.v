`include "rom.v"
`include "ram.v"
`timescale 1ns/1ps

module top_proc_tb;
  
   reg clk, rst;
   wire [31:0] instr, dReadData, PC, dAddress, dWriteData, WriteBackData;
   wire MemRead, MemWrite; 
  
   top_proc top_proc_inst
   (
    .clk(clk),
    .rst(rst),
    .instr(instr), 
    .dReadData(dReadData),
    .PC(PC), 
    .dAddress(dAddress), 
    .dWriteData(dWriteData), 
    .MemRead(MemRead), 
    .MemWrite(MemWrite), 
    .WriteBackData(WriteBackData)
   );
                         
   DATA_MEMORY data_memory_inst
  (
    .clk(clk), 
    .we(MemWrite), 
    .addr(dAddress[8:0]), 
    .din(dWriteData),
    .dout(dReadData)
  );
                          
   INSTRUCTION_MEMORY instruction_memory_inst
  (
    .clk(clk),
    .addr(PC[8:0]), 
    .dout(instr)
  );
  
  initial begin
    clk = 0; // Initialize clock signal to 0.
    
    forever #10 clk = ~clk; //clock with a period of 10 time units
  end
  
  initial begin
    $dumpfile("top_proc_tb.vcd");
    $dumpvars(0,top_proc_tb);
    
    rst=1;
    #20
    rst=0;
    
    #2700;
    $finish;
  end   
endmodule
