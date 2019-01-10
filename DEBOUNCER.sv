`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 20.03.2018 18:30:13
// Design Name: 
// Module Name: DEBOUNCER
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


module DEBOUNCER(
    input wire 	Clock,
    input wire  btn_in,
    output wire btn_out
    );

    parameter numTicks = 12500;

    reg step;
    reg stepPrev;
    reg [$clog2(numTicks)-1:0] counter;

    assign btn_out = step && !stepPrev;

    initial begin
        step = 0;
        stepPrev = 0;
        counter = 0;
    end

    always @ (posedge Clock) begin
        if (counter == numTicks) begin
            counter <= 0;
            step <= btn_in;
        end else begin
            counter <= counter + 1'b1;
        end
        stepPrev <= step;
    end
endmodule
