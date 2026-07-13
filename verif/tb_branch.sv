`timescale 1ns / 1ps

module tb_branch;
    logic clk = 1'b0;
    logic rst = 1'b0;
    logic [31:0] instruction;
    logic [31:0] data_a;
    logic [31:0] data_b;
    logic [31:0] immediate;
    logic [31:0] pc_in;
    logic [4:0] crt_mem;
    logic [2:0] funct3;
    logic branch_taken;
    logic [31:0] branch_target;
    logic [31:0] decoded_immediate;
    logic [4:0] unused_inst;
    logic [1:0] unused_wb;
    logic [4:0] unused_mem;
    logic [2:0] unused_exe;
    logic [6:0] unused_funct7;
    logic [2:0] unused_funct3;
    logic [31:0] unused_data_a;
    logic [31:0] unused_data_b;
    logic [4:0] unused_inst_out;
    logic [1:0] unused_wb_out;
    logic [4:0] unused_mem_out;
    logic [2:0] unused_exe_out;
    logic [6:0] unused_funct7_out;
    logic [2:0] unused_funct3_out;

    DECO decoder (
        .rst(rst), .clk(clk), .INSTRUCTION(instruction), .WRITE_DATA(32'd0),
        .INST(5'd0), .CRT_WB_IN(1'b0), .DATA_A_OUT(unused_data_a),
        .DATA_B_OUT(unused_data_b), .DATA_SE_OUT(decoded_immediate),
        .RS1_OUT(), .RS2_OUT(),
        .INST_OUT(unused_inst), .CRT_WB_OUT(unused_wb),
        .CRT_MEM_OUT(unused_mem), .CRT_EXE_OUT(unused_exe),
        .FUNCT7_OUT(unused_funct7), .FUNCT3_OUT(unused_funct3)
    );

    EXE execute (
        .clk(clk), .DATO_A_IN(data_a), .DATO_B_IN(data_b),
        .DATO_SIGN_EXT_IN(immediate), .PC_IN(pc_in), .RS1_IN(5'd0),
        .RS2_IN(5'd0), .INST_IN(5'd0),
        .CRT_MEM_IN(crt_mem), .CRT_WB_IN(2'd0), .CRT_EXE_IN(3'd0),
        .FUNCT7_IN(7'd0), .FUNCT3_IN(funct3), .EX_MEM_RESULT_IN(32'd0),
        .EX_MEM_RD_IN(5'd0), .EX_MEM_REG_WRITE_IN(1'b0),
        .EX_MEM_MEM_TO_REG_IN(1'b0), .MEM_WB_DATA_IN(32'd0),
        .MEM_WB_RD_IN(5'd0), .MEM_WB_REG_WRITE_IN(1'b0),
        .CRT_MEM_OUT(unused_mem_out),
        .CRT_WB_OUT(unused_wb_out), .PC_NEXT_OUT(branch_target),
        .BRANCH_TAKEN_OUT(branch_taken), .ZERO_OUT(), .ALU_RESULT(),
        .DATO_B_OUT(), .INST_OUT(unused_inst_out)
    );

    always #5 clk = ~clk;

    initial begin
        instruction = 32'h00208863;
        data_a = 32'd7;
        data_b = 32'd7;
        immediate = 32'd8;
        pc_in = 32'd100;
        crt_mem = 5'b00001;
        funct3 = 3'b000;
        #1;
        if (decoded_immediate !== 32'd8)
            $fatal(1, "BEQ immediate must decode before the implicit low zero bit");
        if (!branch_taken || branch_target !== 32'd116)
            $fatal(1, "Taken BEQ must branch to PC plus its signed offset");

        data_b = 32'd8;
        #1;
        if (branch_taken)
            $fatal(1, "BEQ with different operands must not branch");

        funct3 = 3'b100;
        data_a = 32'hffffffff;
        data_b = 32'd1;
        #1;
        if (!branch_taken)
            $fatal(1, "BLT must use signed comparison");

        funct3 = 3'b110;
        #1;
        if (branch_taken)
            $fatal(1, "BLTU must use unsigned comparison");

        instruction = 32'hfe209ee3;
        #1;
        if (decoded_immediate !== -32'sd2)
            $fatal(1, "Negative branch immediate must be sign extended");

        $display("tb_branch passed");
        $finish;
    end
endmodule
