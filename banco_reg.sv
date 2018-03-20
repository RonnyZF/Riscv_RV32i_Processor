`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2018 21:20:55
// Design Name: 
// Module Name: banco_reg
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

module banco_reg(rst,ReadData1, ReadData2, WriteData,ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk );
    output [31:0] ReadData1, ReadData2;
    input [31:0] WriteData;
    input rst;
    input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input [0:0] RegWrite, clk ;
    
	//output [31:0] ro;
/*
input RegWrite,
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,
    input clk,
	input rst,
    input [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
    */

    reg [31:0] Register [0:31];
	 
	 
    initial begin 
        Register[0] = 32'd0;
		Register[1] = 32'd0;
		Register[2] = 32'd0;
		Register[3] = 32'd0;
		Register[4] = 32'd0;
		Register[5] = 32'd0;
		Register[6] = 32'd0;
		Register[7] = 32'd0;
		Register[8] = 32'd0;
		Register[9] = 32'd0;
		Register[10] = 32'd0;
		Register[11] = 32'd0;
		Register[12] = 32'd0;
		Register[13] = 32'd0;
		Register[14] = 32'd0;
		Register[15] = 32'd0;
		Register[16] = 32'd0;
		Register[17] = 32'd0;
		Register[18] = 32'd0;
		Register[19] = 32'd0;
		Register[20] = 32'd0;
		Register[21] = 32'd0;
		Register[22] = 32'd0;
		Register[23] = 32'd0;
		Register[24] = 32'd0;
		Register[25] = 32'd0;
		Register[26] = 32'd0;
		Register[27] = 32'd0;
		Register[28] = 32'd0;
		Register[29] = 32'd0;
		Register[30] = 32'd0;
		Register[31] = 32'd0;
    end
	 
	 
    always @ (posedge clk) begin
        if (RegWrite) begin
            Register[WriteRegister] <= WriteData; 
        end

    end
    
    assign ReadData1 = Register[ReadRegister1];
    assign ReadData2 = Register[ReadRegister2];
	//assign ro=Register[4'd2];

endmodule