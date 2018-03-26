`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:59:49
// Design Name: 
// Module Name: EXE_MEM_PIPELINE
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

module EXE_MEN_PIPELINE(
    input rst,
    input clk,
    input [1:0]  CRT_WB_IN,
    input [2:0]  CRT_MEM_IN,
    input [31:0] PC_IN,
    input        ZERO_IN,
    input [31:0] ALU_RESULT_IN,
    input [31:0] DATO_B_IN,
    input [4:0]  INST_IN,
    
    output reg [1:0]  CRT_WB_OUT,
    output reg [2:0]  CRT_MEM_OUT,
    output reg [31:0] PC_OUT,
    output reg        ZERO_OUT,
    output reg [31:0] ALU_RESULT_OUT,
    output reg [31:0] DATO_B_OUT,
    output reg [4:0]  INST_OUT
    );
      
    always @ (negedge clk)
      begin
          if (rst)
              begin
             CRT_WB_OUT = 2'd0;
             CRT_MEM_OUT = 3'd0;
             PC_OUT = 32'd0;
             ZERO_OUT = 0;
             ALU_RESULT_OUT = 32'd0;
             DATO_B_OUT = 32'd0;
             INST_OUT = 5'd0;
              end
          else
             begin
             CRT_WB_OUT = CRT_WB_IN;    
             CRT_MEM_OUT = CRT_MEM_IN;   
             PC_OUT = PC_IN;        
             ZERO_OUT = ZERO_IN;      
             ALU_RESULT_OUT = ALU_RESULT_IN;
             DATO_B_OUT = DATO_B_IN;    
             INST_OUT = INST_IN;      
             end
     end
      
endmodule