`timescale 1ns / 1ps

module tb_pipeline_flush;
    logic clk = 1'b0;
    logic rst;
    logic flush;
    logic [31:0] pc_in;
    logic [31:0] instruction_in;
    logic [31:0] pc_if_id;
    logic [31:0] instruction_if_id;
    logic [1:0] wb_out;
    logic [4:0] mem_out;
    logic [2:0] exe_out;
    logic [31:0] pc_id_ex;
    logic [31:0] data_a_out;
    logic [31:0] data_b_out;
    logic [31:0] immediate_out;
    logic [4:0] rd_out;
    logic [6:0] funct7_out;
    logic [2:0] funct3_out;

    IF_ID_PIPELINE if_id (
        .rst(rst), .clk(clk), .flush(flush), .PC_IN(pc_in),
        .DATA_IN(instruction_in), .PC_OUT(pc_if_id),
        .DATA_OUT(instruction_if_id)
    );

    ID_EXE_PIPELINE id_ex (
        .rst(rst), .clk(clk), .flush(flush), .CRT_WB_IN(2'b11),
        .CRT_MEM_IN(5'b11111), .CRT_EXE_IN(3'b111), .PC_IN(pc_if_id),
        .DATA_A_IN(32'h11111111), .DATA_B_IN(32'h22222222),
        .DATA_SE_IN(32'h33333333), .INST_IN(5'd31),
        .FUNCT7_IN(7'h7f), .FUNCT3_IN(3'b111), .CRT_WB_OUT(wb_out),
        .CRT_MEM_OUT(mem_out), .CRT_EXE_OUT(exe_out), .PC_OUT(pc_id_ex),
        .DATA_A_OUT(data_a_out), .DATA_B_OUT(data_b_out),
        .DATA_SE_OUT(immediate_out), .INST_OUT(rd_out),
        .FUNCT7_OUT(funct7_out), .FUNCT3_OUT(funct3_out)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        flush = 1'b0;
        pc_in = 32'd0;
        instruction_in = 32'd0;
        @(posedge clk);

        rst = 1'b0;
        pc_in = 32'd64;
        instruction_in = 32'h00100093;
        @(posedge clk);
        #1;
        if (pc_if_id !== 32'd64 || instruction_if_id !== 32'h00100093)
            $fatal(1, "IF/ID must capture the fetched instruction");

        flush = 1'b1;
        @(posedge clk);
        #1;
        if (pc_if_id !== 32'd0 || instruction_if_id !== 32'd0)
            $fatal(1, "IF/ID must be cleared on a taken branch");
        if (wb_out !== 2'd0 || mem_out !== 5'd0 || exe_out !== 3'd0 ||
            pc_id_ex !== 32'd0 || data_a_out !== 32'd0 ||
            data_b_out !== 32'd0 || immediate_out !== 32'd0 ||
            rd_out !== 5'd0 || funct7_out !== 7'd0 || funct3_out !== 3'd0)
            $fatal(1, "ID/EX must become a bubble on a taken branch");

        $display("tb_pipeline_flush passed");
        $finish;
    end
endmodule
