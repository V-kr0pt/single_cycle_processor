module ControlUnit(
    input clk,                 // Clock
    input [9:0] instruction,   // palavra iiiidddddd (10 bits)

    // Saídas (sinais de controle)
    output reg [2:0] addr_a,   // Seleção do registrador A (3 bits)
    output reg [2:0] addr_b,   // Seleção do registrador B (3 bits)
    output reg reset,          // Sinal de reset para o registrador A
    output reg reset_all,      // Sinal de reset para todos registradores
    output reg load,           // Sinal de habilitação de escrita para o registrador A
    output reg mb_select,      // Seleção do caminho para Bus B
    output reg [3:0] ALU_opcode,   // Sinal de controle da ALU
    output reg mem_read,       // Sinal de leitura da memória
    output reg mem_write,      // Sinal de escrita na memória
    output reg [5:0] mem_addr, // Endereço da memória
    output reg mem_select,     // Seleção do caminho para Bus D
    output reg load_PC,        // Sinal de carga para o PC
    output reg [7:0] pc_value  // Valor a ser carregado no PC
);

    wire [3:0] opcode = instruction[9:6]; // Bits 9-6 são o opcode

    // Define valores padrão no início de cada ciclo de clock
    always @(posedge clk) begin
        // Valores padrão de reset
        {reset, reset_all, load, mb_select, mem_read, mem_write, mem_select, load_PC} <= 1'b0;
        ALU_opcode <= 4'b1111;

        // Decodifica a instrução
        case (opcode)
            4'b0000: {ALU_opcode, addr_a, addr_b, load, mb_select} <= {4'b0000, instruction[5:3], instruction[2:0], 1'b1, 1'b1};
            4'b0001: {ALU_opcode, addr_a, addr_b, load, mb_select} <= {4'b0001, instruction[5:3], instruction[2:0], 1'b1, 1'b1};
            4'b0010: {ALU_opcode, addr_a, addr_b, load} <= {4'b0000, instruction[5:3], instruction[2:0], 1'b1}; // ADDI
            4'b0011: {ALU_opcode, addr_a, addr_b, load} <= {4'b0001, instruction[5:3], instruction[2:0], 1'b1}; // SUBI
            4'b0100: {ALU_opcode, addr_a, load} <= {4'b0010, instruction[5:3], 1'b1}; // MUL2
            4'b0101: {ALU_opcode, addr_a, load} <= {4'b0011, instruction[5:3], 1'b1}; // DIV2
            4'b0110: {addr_a, reset} <= {instruction[5:3], 1'b1}; // CLR
            4'b0111: reset_all <= 1'b1; // RST
            4'b1000: {ALU_opcode, addr_a, addr_b, load, mb_select} <= {4'b0100, instruction[5:3], instruction[2:0], 1'b1, 1'b1}; // MOV
            4'b1001: begin // JMP instruction
                        load_PC <= 1'b1;
                        pc_value <= instruction[5:0];
                    end 
            4'b1010: {mem_addr, mem_read} <= {instruction[5:0], 1'b1}; // OUT
            4'b1011: {addr_a, mem_addr, mem_read, mem_select, load} <= {3'b0, instruction[5:0], 1'b1, 1'b1, 1'b1}; // LOAD
            4'b1100: {addr_a, mem_addr, mem_write} <= {3'b0, instruction[5:0], 1'b1}; // STORE
            default: begin
                // Mantenha os valores padrão se a instrução for inválida
            end
        endcase
    end
endmodule
