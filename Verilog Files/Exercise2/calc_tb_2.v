module calc_tb;

  reg clk, btnc, btnl, btnu, btnr, btnd;
  reg [15:0] sw;
  wire [15:0] led;
  
  // Initialize waveforms
  initial begin
    $dumpfile("calc.vcd"); // Specify the name of the VCD file
    $dumpvars(0, calc_tb);     // Dump all variables in the testbench
  end

  calc uut (
    .clk(clk),
    .btnc(btnc),
    .btnl(btnl),
    .btnu(btnu),
    .btnr(btnr),
    .btnd(btnd),
    .sw(sw),
    .led(led)
  );
  
  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    btnc = 0;
    btnl = 0;
    btnu = 0;
    btnr = 0;
    btnd = 0;
    sw = 16'h0;

    // Setting to zero
    #5 btnu = 1; 
    #10 btnu = 0;
    
    #10 btnd = 1; 
    #10 btnd = 0;
    
    $display("Expected value: 0x0, Got: %h", led);

    // First test case (ADD)
    sw = 16'h354a;
    btnc = 1; btnr = 0; btnl = 0;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x0354a, Got: %h", led);
    
    // Second test case (SUB)
    sw = 16'h1234;
    btnc = 1; btnr = 1; btnl = 0;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x2316, Got: %h", led);
    
    //Third test case (OR)
    sw = 16'h1001;
    btnc = 0; btnr = 1; btnl = 0;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x3317, Got: %h", led);

    //Fourth test case (AND)
    sw = 16'hf0f0;
    btnc = 0; btnr = 0; btnl = 0;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x3010, Got: %h", led);
    
    //Fifth test case (XOR)
    sw = 16'h1fa2;
    btnc = 1; btnr = 1; btnl = 1;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x2fb2, Got: %h", led);
    
    //Sixth test case (ADD)
    sw = 16'h6aa2;
    btnc = 1; btnr = 0; btnl = 0;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x9a54, Got: %h", led);
    
    //Seventh test case (LSL)
    sw = 16'h0004;
    btnc = 0; btnr = 1; btnl = 1;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0xa540, Got: %h", led);
    
    //Eighth test case (SAR)
    sw = 16'h0001;
    btnc = 1; btnr = 0; btnl = 1;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0xd2a0, Got: %h", led);
    
    //Ninth test case (LN)
    sw = 16'h46ff;
    btnc = 0; btnr = 0; btnl = 1;
    #10 btnd = 1; 
    #10 btnd = 0;
    #50;
    $display("Expected value: 0x0001, Got: %h", led);

    // Finish simulation
    #1000 $finish;
  end
endmodule
