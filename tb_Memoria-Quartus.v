module tb_Microprocessador_ciclo_unico;

    reg clk;
    reg reset;
    reg [2:0] endereco;
    reg [7:0] valor_escrita;
    reg leitura;
    reg escrita;
    wire [7:0] valor_saida;

    // Instanciação do módulo
    Microprocessador_ciclo_unico uut (
        .clk(clk),
        .reset(reset),
        .endereco(endereco),
        .valor_escrita(valor_escrita),
        .leitura(leitura),
        .escrita(escrita),
        .valor_saida(valor_saida)
    );

    // Gerador de clock
    always #5 clk = ~clk;

    initial begin
        // Inicializa os sinais
        clk = 0;
        reset = 1;
        endereco = 3'b000;
        valor_escrita = 8'b0;
        leitura = 0;
        escrita = 0;
        #10;

        // Desativa o reset
        reset = 0;
        #10;

        // Teste de escrita
        endereco = 3'b001;
        valor_escrita = 8'b10101010;
        escrita = 1;
        #10;
        escrita = 0;

        // Teste de leitura
        leitura = 1;
        #10;

        // Exibir resultado da leitura
        $display("Endereco: %b, Valor Lido: %b", endereco, valor_saida);
        leitura = 0;

        // Finalizar simulação
        $finish;
    end

endmodule
