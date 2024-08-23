module DataMemory (
    input wire clk,
    input wire mem_write,       // Sinal para escrever na memória
    input wire mem_read,        // Sinal para ler da memória
    input wire [5:0] address,  // Endereço da memória
    input wire [7:0] data_in, // Dados a serem escritos na memória
    output reg [7:0] data_out   // Dados lidos da memória
);

    reg [7:0] memoria [0:49]; // Memória de 50 posições de 8 bits

    integer i; // Variável para o loop

    // Inicialização da memória para garantir que todas as posições comecem zeradas
    initial begin
        for (i = 0; i < 50; i = i + 1) begin
            memoria[i] = 8'b0;
        end
    end

    // Escrita e leitura na memória
    always @(posedge clk) begin
        if (mem_write) begin
            memoria[address] <= data_in; // Escreve na memória
        end
        if (mem_read) begin
            data_out <= memoria[address]; // Lê da memória
        end
    end

endmodule