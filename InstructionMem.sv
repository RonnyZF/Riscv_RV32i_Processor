`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:46:47
// Design Name: 
// Module Name: InstructionMem
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
module InstructionMem(
    input clk,
    input logic [31:0] Address,
    output logic [31:0] Word
    );

	 always @ (posedge clk)  
	 begin
	case (Address[31:0])
    		     4: Word = 32'h00100093; //Addi r1,zero,1
                8: Word = 32'h00200113; //Addi r2,zero,2 
                12: Word = 32'h00300193; //Addi r3,zero,3
                16: Word = 32'h00400213; //Addi r4,zero,4
            default Word = 32'h00000000;
	endcase 
end



endmodule

