`timescale 1ns / 1ps

module tb_fetch;
    logic clk = 1'b0;
    logic rst;
    logic [31:0] pc_mem;
    logic mux_crt;
    logic [31:0] data_out;

    FETCH dut (
        .clk(clk),
        .rst(rst),
        .PC_MEM(pc_mem),
        .MUX_CRT(mux_crt),
        .DATA_OUT(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        pc_mem = 32'd0;
        mux_crt = 1'b0;

        repeat (2) @(posedge clk);
        #1;
        if (dut.PC_FETCH !== 32'd0)
            $fatal(1, "PC must reset to zero");
        if (data_out !== 32'h00000000)
            $fatal(1, "Reset PC must read the default ROM instruction");

        rst = 1'b0;
        @(posedge clk);
        #1;
        if (dut.PC_FETCH !== 32'd4)
            $fatal(1, "PC must advance by four bytes");

        @(negedge clk);
        pc_mem = 32'd148;
        mux_crt = 1'b1;
        @(posedge clk);
        #1;
        if (dut.PC_FETCH !== 32'd148)
            $fatal(1, "Taken branch must redirect the PC");
        if (data_out !== 32'h00000513)
            $fatal(1, "Redirected PC must read the target instruction");

        @(negedge clk);
        mux_crt = 1'b0;
        @(posedge clk);
        #1;
        if (dut.PC_FETCH !== 32'd152)
            $fatal(1, "PC must resume sequential execution after a branch");
        if (data_out !== 32'h00000593)
            $fatal(1, "Sequential PC must read the next instruction");

        $display("tb_fetch passed");
        $finish;
    end
endmodule
