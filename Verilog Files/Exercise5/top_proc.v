`include "datapath.v"

module top_proc #(parameter [31:0] INITIAL_PC = 32'h00400000)
  (
    input wire clk, 
    input wire rst, 
    input wire [31:0] instr, 
    input wire [31:0] dReadData, 
    output wire [31:0] PC, 
    output wire [31:0] dAddress, 
    output wire [31:0] dWriteData, 
    output reg MemRead, 
    output reg MemWrite, 
    output wire [31:0] WriteBackData
  );
  
  wire zero; 
  reg loadPC, RegWrite, PCSrc, MemtoReg;
  reg [3:0] ALUCtrl;
  wire ALUSrc;
  
  datapath Datapath_int
  (
    .PC(PC),
    .instr(instr),
    .dAddress(dAddress),
    .dReadData(dReadData),
    .dWriteData(dWriteData),
    .clk(clk),
    .rst(rst),
    .ALUCtrl(ALUCtrl),
    .ALUSrc(ALUSrc),
    .WriteBackData(WriteBackData),
    .MemToReg(MemToReg),
    .PCSrc(PCSrc),
    .loadPC(loadPC),
    .RegWrite(RegWrite),
    .Zero(zero)
  );
  
  //ALUCtrl
  
  always @(instr)begin
  	if (instr[6:0]==7'b1100011) //BEQ (-)
    	ALUCtrl=4'b0110;
    else if (instr[6:0]==7'b0000011) //LW (+)
    	ALUCtrl=4'b0010; 
    else if (instr[6:0]==7'b0100011)  //SW(+)
    	ALUCtrl=4'b0010;
    else if (instr[6:0]==7'b0010011)begin
      if (instr[14:12]==3'b000) //ADDI
        	ALUCtrl=4'b0010;
      else if (instr[14:12]==3'b010)  //SLTI
            ALUCtrl=4'b0100;
      else if (instr[14:12]==3'b100) //XORI
            ALUCtrl=4'b0101;
      else if (instr[14:12]==3'b110)  //ORI
            ALUCtrl=4'b0001;
      else if (instr[14:12]==3'b111)  //ANDI  
                ALUCtrl=4'b0000;
      else if (instr[14:12]==3'b001)  //SLLI  
                ALUCtrl=4'b1001;
      else if (instr[14:12]==3'b101) begin 
                if (instr[31:25]==7'b0000000) //SRLI 
                    ALUCtrl=4'b1000;
      			else if (instr[31:25]==7'b0100000) //SRAI
                    ALUCtrl=4'b1010;
            	end
      end    	
	else if (instr[6:0]==7'b0110011) begin
    	if (instr[14:12]==3'b000) begin  
        	if (instr[31:25]==7'b0000000) //ADD
            	ALUCtrl=4'b0010;
            else if (instr[31:25]==7'b0100000) //SUB
                ALUCtrl=4'b0110;    
            end 
            else if (instr[14:12]==3'b001)  //SLL 
                ALUCtrl=4'b1001;
            else if (instr[14:12]==3'b010)  //SLT
                ALUCtrl=4'b0100;
            else if (instr[14:12]==3'b100) //XOR
                ALUCtrl=4'b0101;  
            else if (instr[14:12]==3'b101) begin
                if (instr[31:25]==7'b0000000)//SRL
                	ALUCtrl=4'b1000;
                else if (instr[31:25]==7'b0100000) //SRA   
                    ALUCtrl=4'b1010; 
            	end         
            else if (instr[14:12]==3'b110) //OR
            	ALUCtrl=4'b0001;
            else if (instr[14:12]==3'b111) //AND
            	ALUCtrl=4'b0000;  
        end
	end  
  
  //ALUSrc
  
  assign ALUSrc = (instr[6:0] == 7'b0010011) || 
                  (instr[6:0] == 7'b0000011) || 
                  (instr[6:0] == 7'b0100011);
      
  //FSM
      
  reg [2:0] current_state, next_state;
  parameter [2:0]  IF=3'b001, ID=3'b011, EX=3'b010, MEM=3'b110, WB=3'b111;
 
      
  //State Transition Logic 
      
  always @(posedge clk) begin
    if(rst) 
       current_state <= IF;
    else
       current_state <= next_state;
  end
   
  //Next State logic 
    
  always @(*) begin
    case(current_state)
      IF: next_state = ID;
      ID: next_state = EX;
      EX: next_state = MEM;
      MEM: next_state = WB;
      WB: next_state = IF;
      default: next_state = IF;
    endcase
  end
 
  //Output logic
    
  always @(*) begin
    
    case(current_state)
        
      IF: 
        begin
          loadPC <= 0;
          RegWrite <= 0;
          PCSrc <= 0;
          MemtoReg <= 0;
        end
              
      MEM:
        begin
          if (instr[6:0] == 7'b0000011) begin //Load
            MemRead <= 1;
            MemWrite <= 0;
          end else if (instr[6:0]== 7'b0100011) begin //Store
            MemWrite <= 1;
            MemRead <= 0;
          end
        end
      WB:
        begin
          loadPC <= 1;
          RegWrite = 1; //All of the instructions write back to the regfile besides BEQ and SW
         
          if((instr[6:0]==7'b1100011) || (instr[6:0]==7'b0100011))
            RegWrite <= 0;
         
          if(instr[6:0]==7'b0000011) //MemtoReg changes only if load is executed and only in the WB state 
            MemtoReg <= 1;
          else
            MemtoReg <= 0; 
      
          if((instr[6:0]==7'b1100011) && (zero == 1)) //PCSrc is set to 1 only when zero = 1 and the current instruction is a BEQ one
            PCSrc <= 1;
          else 
            PCSrc <= 0;
      
        end    
    endcase
  end
      
endmodule
