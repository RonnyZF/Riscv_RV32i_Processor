`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:23:36
// Design Name: 
// Module Name: FETCH
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module FETCH(
    input clk,
    input rst,
    input [31:0] PC_MEM,
    input MUX_CRT,
    output [31:0] PC_OUT,
    output [31:0] DATA_OUT
    );
    reg [31:0] PC_FETCH;
    reg [31:0] PC_MUX;
    reg [31:0] DATA;
    
    InstructionMem INST_MEM (.clk(clk),.Address(PC_MUX[31:0]),.Word(DATA));
    
    always @ (posedge clk) 
    begin
       case (MUX_CRT)
         1'b0: PC_MUX <= PC_FETCH;
         1'b1: PC_MUX <= PC_MEM;
       endcase
   end  

    always @ (posedge clk)
    begin
        if (rst)
            PC_FETCH = 32'd0;
        else
            PC_FETCH = PC_MUX + 32'd4;
    end
            
    assign DATA_OUT = DATA;
    assign PC_OUT = PC_MUX;
    
endmodule
