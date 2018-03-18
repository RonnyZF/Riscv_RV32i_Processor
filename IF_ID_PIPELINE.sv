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
    input [31:0] PC_IN, DATA_IN,
    output [31:0] PC_OUT, DATA_OUT
    );

    reg [31:0] PC_PIPELINE, DATA_PIPELINE;
    reg [31:0] PC_DATA; 
    reg [31:0] DATA;
    always @ (negedge clk )
     if (rst == 1)
        begin
        PC_DATA <= 32'b00000000000000000000000000000000;
        DATA <= 32'b00000000000000000000000000000000;
        end
    else
            begin
                PC_PIPELINE <= PC_IN;
                DATA_PIPELINE <= DATA_IN;
            end


    always @ (posedge clk)
        begin
            PC_DATA <= PC_PIPELINE;
            DATA <= DATA_PIPELINE;
        end
assign PC_OUT = PC_DATA;
assign DATA_OUT = DATA;



endmodule