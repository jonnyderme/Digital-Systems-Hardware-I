`timescale 1ns/1ps

module calc_tb;
  reg clk_tb, btnc, btnl, btnu, btnr, btnd ;
  reg [15:0] sw ;
  wire [15:0] led ; 
 
  // Initialization of the buttons
  initial begin 
    btnc <= 0 ;
    btnl <= 0 ; 
    btnr <= 0 ; 
    btnd <= 0 ;
  end
  
  
  // Instantiate the calculator module
  calc my_calculator (
    .clk(clk_tb), .btnc(btnc), .btnl(btnl), .btnu(btnu), .btnr(btnr), .btnd(btnd), .sw(sw), .led(led)
  );
  

  // Clock generation
  initial begin
    clk_tb = 1'b0;
  end
  
  always begin 
    #5 clk_tb = ~clk_tb ;  
  end
  
  // Initial values
  initial begin
    btnu = 1; // Reset button initially pressed
    #10;      // Wait for a few clock cycles
    btnu = 0; // Release reset
        // Wait for a few clock cycles before starting the sequence
  end
  
  initial begin 
    btnd = 0 ; 
    #10 ; 
    btnd = 1 ; 
  end

  // Test sequence
  initial  begin
    // Test case 0 
    #10 ;
    $display("Test Case 0: Expected Result 0x0, Actual Result %h", led);

    // Test case 1
    btnl = 0; btnc = 1; btnr = 1; btnd = 1; // OR operation
    sw = 16'h1234 ;
    #10 ; 
    $display("Test Case 1: Expected Result 0x1234, Actual Result %h", led);
    
     // Test case 2
    btnl = 0; btnc = 1; btnr = 0; // AND operation
    sw = 16'h0ff0;
    #10 ;
    $display("Test Case 2: Expected Result 0x0230, Actual Result %h", led);

    
     // Test case 3
    btnl = 0; btnc = 0; btnr = 0; // ADD operation
    sw = 16'h324f;
    #10;
    $display("Test Case 3: Expected Result 0X347F, Actual Result %h", led);
    
     // Test case 4
    btnl = 0; btnc = 0; btnr = 1; // SUB operation
    sw = 16'h2d31;
    #10;
    $display("Test Case 4: Expected Result 0x074e, Actual Result %h", led);
    
     // Test case 5
    btnl = 1; btnc = 0; btnr = 0; // XOR operation
    sw = 16'hffff;
    #10;
    $display("Test Case 5: Expected Result 0xf8b1, Actual Result %h", led);
    
    // Test case 6
    btnl = 1; btnc = 0; btnr = 1; // Less Than operation
    sw = 16'h7346;
    #10;
    $display("Test Case 6: Expected Result 0x0001, Actual Result %h", led);


    // Test case 7
    btnl = 1; btnc = 1; btnr = 0; // Shift Left Logical operation
    sw = 16'h0004;
    #10;
    $display("Test Case 7: Expected Result 0x0010, Actual Result %h", led);


    // Test case 8
    btnl = 1; btnc = 1; btnr = 1; // Shift Right Arithmetic operation
    sw = 16'h0004;
    #10 ;
    $display("Test Case 8: Expected Result 0x0001, Actual Result %h", led);


    // Test case 9
    btnl = 1; btnc = 0; btnr = 1; // Less Than operation
    sw = 16'hffff;
    #10 ;
    $display("Test Case 9: Expected Result 0x0000, Actual Result %h", led);

  end
  
  initial begin
  	$dumpfile("dump.vcd");
  	$dumpvars(1);
  end
  
  initial begin
     #140 $finish;
  end
    
    
endmodule
