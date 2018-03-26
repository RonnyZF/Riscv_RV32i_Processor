`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:25:19
// Design Name: 
// Module Name: IF_ID_PIPELINE
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

module IF_ID_PIPELINE(
    input rst,
    input clk,
    input reg [31:0] PC_IN, DATA_IN,
    output reg [31:0] PC_OUT, DATA_OUT
    );

    always @ (posedge clk)
        if(rst)
            begin
            PC_OUT <= 32'd0;
            DATA_OUT <= 32'd0;        
            end
        else
            begin
                PC_OUT <= PC_IN;
                DATA_OUT <= DATA_IN;
            end
endmodule