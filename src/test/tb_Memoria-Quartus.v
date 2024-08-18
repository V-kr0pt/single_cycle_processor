module tb_Microprocessador_ciclo_unico;

    reg clk;
    reg mem_write;
    reg mem_read;
    reg [5:0] endereco;
    reg [7:0] valor_escrita;
    wire [7:0] valor_saida;

    // Instancia o módulo
    Microprocessador_ciclo_unico uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .endereco(endereco),
        .valor_escrita(valor_escrita),
        .valor_saida(valor_saida)
    );

    // Gera o clock
    always #5 clk = ~clk;

    initial begin
        // Inicializa os sinais
        clk = 0;
        mem_write = 0;
        mem_read = 0;
        endereco = 0;
        valor_escrita = 0;

        // Escreve valores em diferentes endereços
        #10;
        endereco = 6'd10;
        valor_escrita = 8'hA5;
        mem_write = 1;
        #10;
        mem_write = 0;

        #10;
        endereco = 6'd20;
        valor_escrita = 8'h3C;
        mem_write = 1;
        #10;
        mem_write = 0;

        #10;
        endereco = 6'd30;
        valor_escrita = 8'h7E;
        mem_write = 1;
        #10;
        mem_write = 0;

        // Lê os valores dos endereços escritos
        #10;
        endereco = 6'd10;
        mem_read = 1;
        #10;
        mem_read = 0;

        #10;
        endereco = 6'd20;
        mem_read = 1;
        #10;
        mem_read = 0;

        #10;
        endereco = 6'd30;
        mem_read = 1;
        #10;
        mem_read = 0;

        // Verifica a leitura de outros endereços não inicializados
        #10;
        endereco = 6'd15;
        mem_read = 1;
        #10;
        mem_read = 0;

        #10;
        endereco = 6'd25;
        mem_read = 1;
        #10;
        mem_read = 0;

        #10;
        endereco = 6'd35;
        mem_read = 1;
        #10;
        mem_read = 0;

        // Simulação continua por mais tempo para observar o comportamento
        #50;

        // Finaliza a simulação
        $finish;
    end

endmodule