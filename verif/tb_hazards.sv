`timescale 1ns / 1ps

module tb_hazards;
    logic clk = 1'b0;
    logic [31:0] data_a;
    logic [31:0] data_b;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [31:0] ex_mem_result;
    logic [4:0] ex_mem_rd;
    logic ex_mem_reg_write;
    logic ex_mem_mem_to_reg;
    logic [31:0] mem_wb_data;
    logic [4:0] mem_wb_rd;
    logic mem_wb_reg_write;
    logic [31:0] alu_result;
    logic [31:0] store_data;
    logic [31:0] id_instruction;
    logic id_ex_mem_read;
    logic [4:0] id_ex_rd;
    logic stall;

    EXE execute (
        .clk(clk), .DATO_A_IN(data_a), .DATO_B_IN(data_b),
        .DATO_SIGN_EXT_IN(32'd0), .PC_IN(32'd0), .RS1_IN(rs1),
        .RS2_IN(rs2), .INST_IN(5'd0), .CRT_MEM_IN(5'd0),
        .CRT_WB_IN(2'd0), .CRT_EXE_IN(3'b000), .FUNCT7_IN(7'd0),
        .FUNCT3_IN(3'b000), .EX_MEM_RESULT_IN(ex_mem_result),
        .EX_MEM_RD_IN(ex_mem_rd), .EX_MEM_REG_WRITE_IN(ex_mem_reg_write),
        .EX_MEM_MEM_TO_REG_IN(ex_mem_mem_to_reg),
        .MEM_WB_DATA_IN(mem_wb_data), .MEM_WB_RD_IN(mem_wb_rd),
        .MEM_WB_REG_WRITE_IN(mem_wb_reg_write), .CRT_MEM_OUT(),
        .CRT_WB_OUT(), .PC_NEXT_OUT(), .BRANCH_TAKEN_OUT(), .ZERO_OUT(),
        .ALU_RESULT(alu_result), .DATO_B_OUT(store_data), .INST_OUT()
    );

    HAZARD_UNIT hazard (
        .ID_INSTRUCTION(id_instruction), .ID_EX_MEM_READ(id_ex_mem_read),
        .ID_EX_RD(id_ex_rd), .STALL(stall)
    );

    always #5 clk = ~clk;

    initial begin
        data_a = 32'd1;
        data_b = 32'd2;
        rs1 = 5'd5;
        rs2 = 5'd6;
        ex_mem_result = 32'd10;
        ex_mem_rd = 5'd5;
        ex_mem_reg_write = 1'b1;
        ex_mem_mem_to_reg = 1'b0;
        mem_wb_data = 32'd20;
        mem_wb_rd = 5'd6;
        mem_wb_reg_write = 1'b1;
        id_ex_mem_read = 1'b1;
        id_ex_rd = 5'd5;
        #1;
        if (alu_result !== 32'd30 || store_data !== 32'd20)
            $fatal(1, "EX/MEM and MEM/WB values must be forwarded to EX");

        mem_wb_data = 32'd99;
        mem_wb_rd = 5'd5;
        #1;
        if (alu_result !== 32'd12)
            $fatal(1, "EX/MEM forwarding must have priority over MEM/WB");

        ex_mem_mem_to_reg = 1'b1;
        ex_mem_result = 32'd0;
        data_b = 32'd0;
        rs2 = 5'd0;
        #1;
        if (alu_result !== 32'd99)
            $fatal(1, "A load result must be forwarded from MEM/WB");

        id_instruction = 32'h00228333;
        #1;
        if (!stall)
            $fatal(1, "A load-use dependency must stall the pipeline");

        id_instruction = 32'h00500313;
        #1;
        if (stall)
            $fatal(1, "An immediate field must not be treated as rs2");

        id_instruction = 32'h0012a023;
        #1;
        if (!stall)
            $fatal(1, "A store using a loaded base register must stall");

        $display("tb_hazards passed");
        $finish;
    end
endmodule
