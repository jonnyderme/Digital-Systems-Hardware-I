`timescale 1ns/1ps

module calc(
  input wire  clk, btnc, btnl, btnu, btnr, btnd,
  input wire  [15:0] sw,
 
  output reg [15:0] led
);
  
  wire [31:0] op1_calc, op2_calc;
  wire [3:0] alu_op_calc;
  wire zero_calc;
  wire [31:0] result_calc;
  reg [15:0] accumulator;
  
  
  // This gets the accumulator value and puts it into op1_calc
  assign op1_calc = {{16{accumulator[15]}} , accumulator};
    
  // This gets the sw values and puts it into the op2_calc
  assign op2_calc = {{16{sw[15]}} , sw};
  
  decoder Decoder (.btnrD(btnr), .btnlD(btnl), .btncD(btnc), 
                   .alu_opD(alu_op_calc)) ; 
    
  // This is where we are calling/using the alu module.
  alu ALUsystem (.op1(op1_calc), .op2(op2_calc), .alu_op(alu_op_calc),                            .zero(zero_calc), .result(result_calc));
  
  
  // Accumulator connected to clock input
  always @(posedge clk) begin
    // Reset accumulator to zero synchronously with btnu pressing
    if (btnu==1) begin
      accumulator <= 16'b0;
    end
    // Update accumulator every time "down" (btnd) is pressed
    else if (btnd==1) begin
      accumulator <= result_calc[15:0];
    end
  end
  
  initial begin 
    led <= 0 ; 
  end
  
  // Connect accumulator value to the LED outputs
  always@(posedge clk or accumulator) begin 
    led = accumulator ; 
  end 
endmodule
    
