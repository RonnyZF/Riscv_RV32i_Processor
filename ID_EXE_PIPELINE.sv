`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    input [1:0] CRT_WB_IN,
    input [2:0] CRT_MEM_IN,
    input [2:0] CRT_EXE_IN,
    input [31:0] PC_IN,
    input [31:0] DATA_A_IN,
    input [31:0] DATA_B_IN,
    input [31:0] DATA_SE_IN,
    input [4:0] INST_IN,
    
    input [6:0] FUNCT7_IN,
    input [2:0] FUNCT3_IN,
    
    output reg [1:0]  CRT_WB_OUT,
    output reg [2:0]  CRT_MEM_OUT,
    output reg [2:0]  CRT_EXE_OUT,
    output reg [31:0] PC_OUT,
    output reg [31:0] DATA_A_OUT,
    output reg [31:0] DATA_B_OUT,
    output reg [31:0] DATA_SE_OUT,
    output reg [4:0]  INST_OUT, 
    
    output reg [6:0] FUNCT7_OUT,
    output reg [2:0] FUNCT3_OUT   
    );
    
    reg  [1:0] CRT_WB_PIPELINE;
    reg  [2:0] CRT_MEM_PIPELINE;
    reg  [2:0] CRT_EXE_PIPELINE;
    reg  [31:0] PC_IN_PIPELINE;
    reg  [31:0] DATA_A_PIPELINE;
    reg  [31:0] DATA_B_PIPELINE;
    reg  [31:0] DATA_SE_PIPELINE;
    reg  [4:0] INST_PIPELINE;
    
    reg [6:0] FUNCT7_PIPELINE;
    reg [2:0] FUNCT3_PIPELINE;
    
    
    always @ (negedge clk)
    begin
        if (rst==1)
        begin
        CRT_WB_PIPELINE <= 2'd0;
        CRT_MEM_PIPELINE <= 3'b000;
        CRT_EXE_PIPELINE <= 3'd0;
        PC_IN_PIPELINE <= 32'd0;
        DATA_A_PIPELINE <= 32'd0;
        DATA_B_PIPELINE <= 32'd0;
        DATA_SE_PIPELINE <= 16'd0;
        INST_PIPELINE  <= 5'd0;
        FUNCT7_PIPELINE <= 7'd0;
        FUNCT3_PIPELINE <= 3'd0;
        end
        else
            begin
            CRT_WB_PIPELINE  <= CRT_WB_IN;    
            CRT_MEM_PIPELINE <= CRT_MEM_IN;   
            CRT_EXE_PIPELINE <= CRT_EXE_IN;   
            PC_IN_PIPELINE   <= PC_IN;    
            DATA_A_PIPELINE  <= DATA_A_IN;   
            DATA_B_PIPELINE  <= DATA_B_IN;   
            DATA_SE_PIPELINE <= DATA_SE_IN;  
            INST_PIPELINE    <= INST_IN;
            FUNCT7_PIPELINE <= FUNCT7_IN;
            FUNCT3_PIPELINE <= FUNCT3_IN;
            end    
        end  
    always @ (posedge clk)
 
        begin
        CRT_WB_OUT  <= CRT_WB_PIPELINE;    
        CRT_MEM_OUT <= CRT_MEM_PIPELINE;   
        CRT_EXE_OUT <= CRT_EXE_PIPELINE;  
        PC_OUT   <= PC_IN_PIPELINE;    
        DATA_A_OUT  <= DATA_A_PIPELINE;   
        DATA_B_OUT  <= DATA_B_PIPELINE;   
        DATA_SE_OUT <= DATA_SE_PIPELINE;  
        INST_OUT    <= INST_PIPELINE;
        FUNCT7_OUT <= FUNCT7_PIPELINE;
        FUNCT3_OUT <= FUNCT3_PIPELINE;      
    end

endmodule
