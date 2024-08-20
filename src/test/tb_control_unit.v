module tb_control_unit;

    // Declaração de variáveis de entrada para o DUT (Device Under Test)
    reg clk;
    reg reset_global;
    reg [9:0] instruction;
    reg reset;

    // Declaração de variáveis de saída para o DUT
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
    wire reset_individual;
    wire reset_all;

    // Instanciação da unidade de controle (DUT)
    control_unit dut (
        .clk(clk),
        .reset_global(reset_global),
        .instruction(instruction),
        .reset(reset),
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
        .constant_in(constant_in),
        .reset_individual(reset_individual),
        .reset_all(reset_all)
    );

    // Clock generator
    always begin
        #5 clk = ~clk;  // Gera um clock com período de 10 unidades de tempo
    end

    // Testbench logic
    initial begin
        // Inicializando entradas
        clk = 0;
        reset_global = 0;
        instruction = 10'b0000000000;
        reset = 0;

        // Reseta todos os sinais
        #10 reset_global = 1;
        #10 reset_global = 0;

        // Teste 1: ADD Instrução
        #10 instruction = 10'b0000001011; // Exemplo de instrução ADD
        #10 $display("ADD: reg_a_select=%b, reg_b_select=%b, g_select=%b, write_enable=%b", reg_a_select, reg_b_select, g_select, write_enable);

        // Teste 2: SUB Instrução
        #10 instruction = 10'b0001001011; // Exemplo de instrução SUB
        #10 $display("SUB: reg_a_select=%b, reg_b_select=%b, g_select=%b, write_enable=%b", reg_a_select, reg_b_select, g_select, write_enable);

        // Teste 3: ADDI Instrução
        #10 instruction = 10'b0010001010; // Exemplo de instrução ADDI
        #10 $display("ADDI: reg_a_select=%b, constant_in=%b, g_select=%b, write_enable=%b", reg_a_select, constant_in, g_select, write_enable);

        // Teste 4: JMP Instrução
        #10 instruction = 10'b1001001110; // Exemplo de instrução JMP
        #10 $display("JMP: load=%b, set_value=%b", load, set_value);

        // Teste 5: STORE Instrução
        #10 instruction = 10'b1100010011; // Exemplo de instrução STORE
        #10 $display("STORE: mem_write=%b, reg_a_select=%b", mem_write, reg_a_select);

        // Teste 6: CLR Instrução
        #10 instruction = 10'b0110000000; // Exemplo de instrução CLR
        #10 $display("CLR: reg_a_select=%b, write_enable=%b, reset_individual=%b", reg_a_select, write_enable, reset_individual);

        // Teste 7: LOAD Instrução
        #10 instruction = 10'b1011010011; // Exemplo de instrução LOAD
        #10 $display("LOAD: reg_a_select=%b, mem_read=%b, write_enable=%b", reg_a_select, mem_read, write_enable);

        // Teste 8: RST Instrução
        #10 instruction = 10'b0111000000; // Exemplo de instrução RST
        #10 $display("RST: reset_all=%b", reset_all);

        // Finaliza a simulação
        #10 $finish;
    end

endmodule
