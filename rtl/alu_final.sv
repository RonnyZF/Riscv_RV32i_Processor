`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 21:53:09
// Design Name: 
// Module Name: ALU_FINAL
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



module ALU_FINAL(
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [1:0] Alu_op,
    input [6:0] funct7,
    input [2:0] funct3,
    output zero,
    output [31:0] result
    );
	 
	 reg [3:0] control;
	 
	 ALU A1(
	 .a(a),
	 .b(b),
	 .ctrl(control),
	 .zero (zero),
	 .result (result)
	 );
	 
	 Alu_ctrl C2(
	 .clk(clk),
	 .Alu_op(Alu_op),
	 .funct7(funct7),
	 .funct3(funct3),
	 .ctrl(control)
	 );


endmodule