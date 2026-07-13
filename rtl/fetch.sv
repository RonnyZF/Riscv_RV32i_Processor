`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
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
    
    InstructionMem INST_MEM (.clk(clk),.Address(PC_FETCH),.Word(DATA_OUT));
    assign PC_OUT = PC_FETCH;
       
    always @ (posedge clk)
    begin
        if (rst)
            PC_FETCH <= 32'd0;  
        else if (MUX_CRT==1'b1)
            PC_FETCH <= PC_MEM;
        else
            PC_FETCH <= PC_FETCH + 32'd4;
    end
endmodule