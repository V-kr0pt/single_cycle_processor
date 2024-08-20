module control_unit_tb;

    // Inputs
    reg [9:0] instruction;

    // Outputs
    wire [2:0] reg_a_select;
    wire [2:0] reg_b_select;
    wire [7:0] write_enable;
    wire [3:0] g_select;
    wire mem_read;
    wire mem_write;
    wire [1:0] mb_select;
    wire mf_select;
    wire md_select;
    wire load;
    wire [7:0] set_value;
    wire [7:0] constant_in;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .instruction(instruction),
        .reg_a_select(reg_a_select),
        .reg_b_select(reg_b_select),
        .write_enable(write_enable),
        .g_select(g_select),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mb_select(mb_select),
        .mf_select(mf_select),
        .md_select(md_select),
        .load(load),
        .set_value(set_value),
        .constant_in(constant_in)
    );

    initial begin
        // Initialize Inputs
        instruction = 10'b0000000000;
        #50;

        // Test ADD instruction (opcode 0000)
        instruction = 10'b0000000101; // reg_a_select = 001, reg_b_select = 101
        #50;
        $display("ADD: reg_a_select=%b, reg_b_select=%b, write_enable=%b, g_select=%b", reg_a_select, reg_b_select, write_enable, g_select);

        // Test SUB instruction (opcode 0001)
        instruction = 10'b0001001101; // reg_a_select = 011, reg_b_select = 101
        #50;
        $display("SUB: reg_a_select=%b, reg_b_select=%b, write_enable=%b, g_select=%b", reg_a_select, reg_b_select, write_enable, g_select);

        // Test ADDI instruction (opcode 0010)
        instruction = 10'b0010101011; // reg_a_select = 010, constant_in = 011
        #50;
        $display("ADDI: reg_a_select=%b, constant_in=%b, write_enable=%b, g_select=%b", reg_a_select, constant_in, write_enable, g_select);

        // Test SUBI instruction (opcode 0011)
        instruction = 10'b0011101010; // reg_a_select = 101, constant_in = 010
        #50;
        $display("SUBI: reg_a_select=%b, constant_in=%b, write_enable=%b, g_select=%b", reg_a_select, constant_in, write_enable, g_select);

        // Test MUL2 instruction (opcode 0100)
        instruction = 10'b0100110100; // reg_a_select = 011 (dummy, as MUL2 doesn't use this)
        #50;
        $display("MUL2: reg_a_select=%b, write_enable=%b, g_select=%b", reg_a_select, write_enable, g_select);

        // Test DIV2 instruction (opcode 0101)
        instruction = 10'b0101101100; // reg_a_select = 011 (dummy, as DIV2 doesn't use this)
        #50;
        $display("DIV2: reg_a_select=%b, write_enable=%b, g_select=%b", reg_a_select, write_enable, g_select);

        // Test CLR instruction (opcode 0110)
        instruction = 10'b0110011000; // reg_a_select = 001
        #50;
        $display("CLR: reg_a_select=%b, write_enable=%b", reg_a_select, write_enable);

        // Test RST instruction (opcode 0111)
        instruction = 10'b0111000000; // All registers should be reset
        #50;
        $display("RST: write_enable=%b", write_enable);

        // Test MOV instruction (opcode 1000)
        instruction = 10'b1000101011; // reg_a_select = 010, reg_b_select = 011
        #50;
        $display("MOV: reg_a_select=%b, reg_b_select=%b, write_enable=%b, mb_select=%b", reg_a_select, reg_b_select, write_enable, mb_select);

        // Test JMP instruction (opcode 1001)
        instruction = 10'b1001000111; // set_value = 000111
        #50;
        $display("JMP: set_value=%b, load=%b", set_value, load);

        // Test OUT instruction (opcode 1010)
        instruction = 10'b1010110000; // reg_a_select = 110
        #50;
        $display("OUT: reg_a_select=%b, write_enable=%b", reg_a_select, write_enable);

        // Test LOAD instruction (opcode 1011)
        instruction = 10'b1011101001; // reg_a_select = 101
        #50;
        $display("LOAD: reg_a_select=%b, write_enable=%b, mem_read=%b", reg_a_select, write_enable, mem_read);

        // Test STORE instruction (opcode 1100)
        instruction = 10'b1100100110; // reg_a_select = 010
        #50;
        $display("STORE: reg_a_select=%b, write_enable=%b, mem_write=%b", reg_a_select, write_enable, mem_write);

        // Test default case (invalid opcode)
        instruction = 10'b1111111111; // Invalid opcode
        #50;
        $display("Default case: write_enable=%b, g_select=%b", write_enable, g_select);

        $stop; // Stop the simulation
    end

endmodule