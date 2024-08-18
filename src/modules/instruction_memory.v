module instruction_memory #(
    parameter INSTRUCTION_WIDTH = 10,  // Largura da instrução (10 bits)
    parameter ADDR_BITS = 6            // Largura do endereço (6 bits, permitindo 64 endereços)
)
(
    input [ADDR_BITS-1:0] address,       // Entrada do endereço da instrução (6 bits)
    output wire [INSTRUCTION_WIDTH-1:0] instruction // Saída da instrução (10 bits)
);

    // Declaração da memória RAM como um array bidimensional
    // A RAM tem 64 posições, cada uma com largura de 10 bits (2^6 = 64 endereços)
    reg [INSTRUCTION_WIDTH-1:0] ram [(2**ADDR_BITS)-1:0];

    // Bloco inicial para carregar a memória RAM a partir de um arquivo de texto
    initial begin
        // Lê o conteúdo do arquivo "machine_code.txt" e armazena nas posições de RAM
        // O arquivo deve conter instruções em formato binário, uma por linha
        $readmemb("machine_code.txt", ram);
    end

    // Atribuição contínua para retornar a instrução armazenada na RAM no endereço especificado
    assign instruction = ram[address];

endmodule


