`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:00:43
// Design Name: 
// Module Name: MEM
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
module MEM(

    // Entradas control
    input clk,
    input rst,
    input [2:0] CRT_MEM_IN,
    input [1:0] CRT_WB_IN,
    // Datos
    input [31:0] ADDRESS_IN, 
    input  [31:0] DATA_IN,
    input ZERO_IN,
    input [4:0] INST_IN,
    
    output [1:0] CRT_WB_OUT,    
    output [31:0] DATA_OUT,
    output logic [31:0] ReadData,
    output [4:0] INST_OUT,
    output BRANCH_OUT
    );

    //Registros intermedios
    reg [31:0] DATA;
    reg [2:0] CRT_MEM;
    reg Branch;
    reg [4:0] INST;
    reg [2:0] CRT_WB;
    
    // Intanciar Memoria
   MemDatos DATA_MEM(.clk(clk), .rst(rst),.Address(ADDRESS_IN),
                       .MemWrite(CRT_MEM[2]),.MemRead(CRT_MEM[1]),
                       .WriteData(DATA_IN), .ReadData(DATA));
                       
    assign CRT_MEM = CRT_MEM_IN;
    assign INST = INST_IN;
    assign CRT_WB = CRT_WB_IN;
    always @ (posedge clk)
      if (CRT_MEM[0])
        begin
            Branch = ZERO_IN & CRT_MEM[0];
        end
     else
        begin
          Branch = 1'b0;
        end
        
    assign DATA_OUT = ADDRESS_IN;
    assign ReadData = DATA;    
    assign BRANCH_OUT = Branch;              
    assign INST_OUT = INST;
    assign CRT_WB_OUT = CRT_WB;
endmodule
