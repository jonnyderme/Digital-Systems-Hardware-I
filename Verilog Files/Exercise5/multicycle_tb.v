`timescale 1ns/1ps

module tb_multicycle;

  reg clk, rst;
  reg [31:0] instr, dReadData;
  wire [31:0] PC, dAddress, dWriteData, WriteBackData;
  wire MemRead, MemWrite, Zero;
  
  
  // Clock generation
  initial begin
    clk = 1'b0;
  end
  
  always begin 
    #5 clk = ~clk ;  
  end

  // Reset generation
  initial
    begin
      rst = 1;
      #5 rst = 0;
      #10 rst = 0;
    end
  
  
  
   // **************INSTRUCTION MEMORY*************//
  // ROM Memory
  wire [31:0] Instruction ; 
  reg [8:0] addrROM ; 
  
  initial begin 
    addrROM <= PC[8:0] ; 
  end 
  
  always @(PC) // @(posedge clk)
    begin
      addrROM <= PC[8:0] ; 
     // $display(addrROM) ; 
    end
  
  // Instantiate ROM Memory 
  INSTRUCTION_MEMORY ROM_Memory (.clk(clk), 
                                 .addr(addrROM), 
                                 .dout(Instruction)) ;
  reg [6:0] op ;
  always @(posedge clk)
    begin
      op = Instruction[6:0];
    end
  
  // *************DATA MEMORY**************//
  // RAM Memory
  
  reg weRAM ; 
  
  always @(posedge clk) 
    begin
      if(MemRead)
        weRAM <= 0 ;
      else if (MemWrite)
        weRAM <= 1 ; 
    end
  
  
  wire [31:0] dReadDataRAM ;
  reg [8:0] addrRAM ;
  
  initial begin 
    addrRAM <= dAddress[8:0] ; 
  end 
  
  always @(posedge clk) 
    begin
      addrRAM <= dAddress[8:0] ; 
    end
  
  // Instantiate RAM Memory 
  DATA_MEMORY RAM_Memory (.clk(clk), 
                          .we(weRAM), 
                          .addr(addrRAM),     
                          .din(dWriteData), 
                          .dout(dReadDataRAM)) ;
  
  assign dReadDataRAM = dReadData ;
      
  multicycle myMulticycle (
    .clk(clk),
    .rst(rst),
    .instr(Instruction),
    .dReadData(dReadData),
    
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .WriteBackData(WriteBackData)  
  );

  

  // Test scenario
  initial
    begin

      dReadData = 10 ; 

     // #50  ;
    //  dReadData = 20 ;
    // #50 ; 
     // dReadData = 25 ;
    //  #50 ; 
   //   dReadData = 30 ; 
   //   #50 ; 
   //   dReadData = 35 ; 
      

      
    end
 
  
  initial begin
  	$dumpfile("dump.vcd");
  	$dumpvars(1);
  end
  
  initial begin
     #1200 $finish;
  end

endmodule
