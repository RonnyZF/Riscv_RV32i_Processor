`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:01:38
// Design Name: 
// Module Name: MemDatos
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


module MemDatos
	#(
parameter NUM_REGS = 256, 
parameter SIZE = 32
)(
input clk,
input rst,
input  [31:0]  Address,
input         MemWrite,
input MemRead,
input  [31:0] WriteData,
output logic [31:0] ReadData

);

logic [SIZE-1:0] mem [NUM_REGS-1:0];

integer i;
 always_ff @ (negedge clk) begin
  if (rst)
        for (i = 0; i < NUM_REGS-1; i = i + 1)
            mem[i] <= 0;
    else  if (MemWrite)
    mem[Address] <= WriteData;
    
end

always_comb begin
    if (MemRead)
     ReadData = mem[Address];
    else ReadData = 0;
 end

endmodule

 
