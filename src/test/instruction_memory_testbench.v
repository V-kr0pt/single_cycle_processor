module instruction_memory_testbench();
    reg clk; // Sinal de clock
    reg pc_reset; // Sinal de reset do PC
    wire [7:0] address;  // 6 bits para endereçar a memória de instruções
    wire [9:0] instruction;  // 10 bits de largura da palavra

    // Instanciando o módulo da memória de instruções
    InstructionMemory inst_mem (
        .address(address),
        .instruction(instruction)
    );

    PointCounter pc(
        .clk(clk),
        .reset(pc_reset),
        .points(address)
    );

    integer i; // Variável de controle do loop

    // Gera o clock
    always #5 clk = ~clk;

    initial begin
        // Configuração para gerar o arquivo .vcd
        $dumpfile("instruction_memory_test.vcd");
        $dumpvars(0, instruction_memory_testbench);

        // Inicializa os sinais
        clk = 0;
        pc_reset = 1;
        #10;
        pc_reset = 0;
        if (instruction === 10'bx) begin
            # 10;   
            $finish;
        end

        #50 $finish;

    end




endmodule
