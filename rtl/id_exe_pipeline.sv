`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 21:49:38
// Design Name: 
// Module Name: ID_EXE_PIPELINE
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
module ID_EXE_PIPELINE(
    input rst,
    input clk,
    input [1:0]  CRT_WB_IN,
    input [4:0]  CRT_MEM_IN,
    input [2:0]  CRT_EXE_IN,
//    input [31:0] PC_IN,
    input [31:0] DATA_A_IN,
    input [31:0] DATA_B_IN,
    input [31:0] DATA_SE_IN,
    input [4:0]  INST_IN,
    input [6:0]  FUNCT7_IN,
    input [2:0]  FUNCT3_IN,
    
    output reg [1:0]  CRT_WB_OUT,
    output reg [4:0]  CRT_MEM_OUT,
    output reg [2:0]  CRT_EXE_OUT,
//    output reg [31:0] PC_OUT,
    output reg [31:0] DATA_A_OUT,
    output reg [31:0] DATA_B_OUT,
    output reg [31:0] DATA_SE_OUT,
    output reg [4:0]  INST_OUT, 
    output reg [6:0] FUNCT7_OUT,
    output reg [2:0] FUNCT3_OUT   
    );
    
    always @ (posedge clk)
        if(rst)
            begin
            CRT_WB_OUT  <= 2'd0;   
            CRT_MEM_OUT <= 3'd0;   
            CRT_EXE_OUT <= 3'd0;  
//            PC_OUT      <= 32'd0;  
            DATA_A_OUT  <= 32'd0;  
            DATA_B_OUT  <= 32'd0;  
            DATA_SE_OUT <= 32'd0;  
            INST_OUT    <= 5'd0; 
            FUNCT7_OUT  <= 7'd0; 
            FUNCT3_OUT  <= 3'd0;
            end
        else
            begin
            CRT_WB_OUT  <= CRT_WB_IN;    
            CRT_MEM_OUT <= CRT_MEM_IN;   
            CRT_EXE_OUT <= CRT_EXE_IN;  
//            PC_OUT      <= PC_IN;       
            DATA_A_OUT  <= DATA_A_IN;   
            DATA_B_OUT  <= DATA_B_IN;   
            DATA_SE_OUT <= DATA_SE_IN;  
            INST_OUT    <= INST_IN;    
            FUNCT7_OUT  <= FUNCT7_IN;  
            FUNCT3_OUT  <= FUNCT3_IN;      
            end

endmodule
