module Microprocessador_ciclo_unico(
    input clk,               // Sinal de clock
    input reset,             // Sinal de reset
    input [2:0] endereco,    // Endereço de 3 bits
    input [7:0] valor_escrita, // Valor de 8 bits para escrita
    input leitura,           // Sinal de leitura (1 para leitura, 0 para escrita)
    input escrita,           // Sinal de escrita (1 para escrita, 0 para leitura)
    output reg [7:0] valor_saida // Valor de 8 bits lido
);

    reg [7:0] memoria [0:7]; // Memória de 8 posições de 8 bits cada

    integer i; // Variável para o loop for

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reseta todos os valores da memória para zero
            valor_saida <= 8'b0;
            for (i = 0; i < 8; i = i + 1) begin
                memoria[i] <= 8'b0;
            end
        end else if (escrita) begin
            memoria[endereco] <= valor_escrita; // Escrita na memória
        end else if (leitura) begin
            valor_saida <= memoria[endereco]; // Leitura da memória
        end
    end

endmodule