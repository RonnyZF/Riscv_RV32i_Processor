`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:51:25
// Design Name: 
// Module Name: Memoria
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


module Memoria(clk,Reset,MemoryAddress,memWD,memRD,DataOut,DataIn);
	output reg [31:0] DataOut;
	input [31:0] MemoryAddress,DataIn;
   input memRD, memWD,Reset,clk;
	
	
	
	reg [6:0] Memory [0:60348];
	

	
	
	always @ (posedge clk)begin
		if (memRD)begin
			DataOut[6:0]=Memory[MemoryAddress];
			DataOut[31:7]=25'd0;
		end
		else if (memWD)begin
			Memory[MemoryAddress]=DataIn;
			DataOut=32'd0;
		end
		else  DataOut=MemoryAddress;

	end
endmodule