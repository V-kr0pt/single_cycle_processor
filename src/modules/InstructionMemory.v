module InstructionMemory #(
    parameter INSTRUCTION_WIDTH = 10,  // Largura da instrução (10 bits)
    parameter ADDR_BITS = 8            // Largura do endereço mínimo 6 bits, permitindo 64 endereços)
)                                      // para garantir o padrão foi utilizado 8 bits (2^8 = 256 endereços)
(
    input [ADDR_BITS-1:0] address,       // Entrada do endereço da instrução (6 bits)
    output wire [INSTRUCTION_WIDTH-1:0] instruction // Saída da instrução (10 bits)
);

    // Declaração da memória como um array bidimensional
    // A memória tem 64 posições, cada uma com largura de 10 bits (2^6 = 64 endereços)
    reg [INSTRUCTION_WIDTH-1:0] memory [0:(2**ADDR_BITS)-1];

    parameter FILE_PATH = "../machine_code/machine_code.txt"; // Caminho do arquivo de instruções
    
    // Bloco inicial para carregar as intruções na memória a partir de um arquivo de texto
    initial begin 
        // Lê o conteúdo do arquivo "machine_code.txt" e armazena
        // O arquivo deve conter instruções em formato binário, uma por linha
        $readmemb(FILE_PATH, memory);
    end

    // Atribuição contínua para retornar a instrução armazenada na no endereço especificado
    assign instruction = memory[address];

endmodule