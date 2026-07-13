`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 22:03:10
// Design Name: 
// Module Name: MEM_WB_PIPELINE
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
module MEM_WB_PIPELINE(
    input rst,
    input clk,
    input [1:0]  CRT_WB_IN,
    input [31:0] READ_DATA_IN,
    input [31:0] ALU_RESULT_IN,
    input [4:0]  INST_IN,
    
    output reg  [1:0]  CRT_WB_OUT,   
    output reg  [31:0] READ_DATA_OUT,
    output reg  [31:0] ALU_RESULT_OUT,
    output reg  [4:0]  INST_OUT
    );      
    
    always @ (posedge clk)
      begin
        if (rst)
            begin
            CRT_WB_OUT = 2'd0;    
            READ_DATA_OUT = 32'd0; 
            ALU_RESULT_OUT = 32'd0;
            INST_OUT = 5'd0;      
            end     
        else
            begin
            CRT_WB_OUT = CRT_WB_IN;     
            READ_DATA_OUT = READ_DATA_IN;  
            ALU_RESULT_OUT = ALU_RESULT_IN; 
            INST_OUT = INST_IN;       
            end  
        end    

endmodule

