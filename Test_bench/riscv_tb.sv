`timescale 1ns/1ps

module riscv_top_tb;

    logic clk;
    logic rest;

    int cycle_count = 0;
    int error_count = 0;

    logic [31:0] prev_pc;


    // DUT

    riscv_top dut (
        .clk(clk),
        .rest(rest)
    );
    // CLOCK (100 MHz)
 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // RESET
    initial begin
        rest = 1;
        prev_pc = 0;
        #20;
        rest = 0;

        $display("\n[%0t] RESET RELEASED\n", $time);
    end

    // MAIN MONITOR
    always @(posedge clk) begin
        if (!rest) begin
            cycle_count++;

            // TRACE (for TCL + waveform)

            if (!$isunknown(dut.pc_out) && !$isunknown(dut.instruction)) begin
                $display("Cycle=%0d | PC=0x%08h | Instr=0x%08h",
                         cycle_count, dut.pc_out, dut.instruction);
            end

            // ERROR CHECKS

            // 1. PC unknown
            if ($isunknown(dut.pc_out)) begin
                $display(" ERROR: PC is UNKNOWN at cycle %0d", cycle_count);
                error_count++;
            end
            // 2. Instruction unknown
            if ($isunknown(dut.instruction)) begin
                $display(" ERROR: Instruction is UNKNOWN at cycle %0d", cycle_count);
                error_count++;
            end
            // 3. PC alignment check (must be word aligned)
            if (dut.pc_out[1:0] != 2'b00) begin
                $display(" ERROR: PC MISALIGNED at cycle %0d | PC=%h",
                         cycle_count, dut.pc_out);
                error_count++;
            end
            // 4. Infinite loop detection (soft warning)
            if (cycle_count > 5 && dut.pc_out == prev_pc) begin
                $display(" WARNING: PC not changing (possible loop)");
            end
            // Update previous PC
            prev_pc <= dut.pc_out;
        end
    end

    // SIMULATION END
    initial begin
        #3000;

        $display("\n==============================");
        $display("TOTAL CYCLES = %0d", cycle_count);
        $display("TOTAL ERRORS = %0d", error_count);
        if (error_count == 0)
            $display(" TEST PASSED");
        else
            $display(" TEST FAILED");

        $display("==============================\n");

        $finish;
    end
endmodule
