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
    always @(*) begin
        // Valores padrão de reset
        {reset, reset_all, load, mb_select, mem_read, mem_write, mem_select, load_PC} <= 1'b0;
        ALU_opcode <= 4'b1111;

        // Decodifica a instrução
        case (opcode)
            4'b0000: begin // Operação para o opcode 0000
                ALU_opcode <= 4'b0000;
                addr_a <= instruction[5:3];
                addr_b <= instruction[2:0];
                load <= 1'b1;
                mb_select <= 1'b1;
            end
            4'b0001: begin // Operação para o opcode 0001
                ALU_opcode <= 4'b0001;
                addr_a <= instruction[5:3];
                addr_b <= instruction[2:0];
                load <= 1'b1;
                mb_select <= 1'b1;
            end
            4'b0010: begin // ADDI
                ALU_opcode <= 4'b0000;
                addr_a <= instruction[5:3];
                addr_b <= instruction[2:0];
                load <= 1'b1;
            end
            4'b0011: begin // SUBI
                ALU_opcode <= 4'b0001;
                addr_a <= instruction[5:3];
                addr_b <= instruction[2:0];
                load <= 1'b1;
            end
            4'b0100: begin // MUL2
                ALU_opcode <= 4'b0010;
                addr_a <= instruction[5:0];
                load <= 1'b1;
            end
            4'b0101: begin // DIV2
                ALU_opcode <= 4'b0011;
                addr_a <= instruction[5:0];
                load <= 1'b1;
            end
            4'b0110: begin // CLR
                addr_a <= instruction[5:0];
                reset <= 1'b1;
            end
            4'b0111: begin // RST
                reset_all <= 1'b1;
            end
            4'b1000: begin // MOV
                ALU_opcode <= 4'b0100;
                addr_a <= instruction[5:3];
                addr_b <= instruction[2:0];
                load <= 1'b1;
                mb_select <= 1'b1;
            end
            4'b1001: begin // JMP instruction
                load_PC <= 1'b1;
                pc_value <= instruction[5:0];
            end
            4'b1010: begin // OUT
                mem_addr <= instruction[5:0];
                mem_read <= 1'b1;
            end
            4'b1011: begin // LOAD
                addr_a <= 3'b001;
                mem_addr <= instruction[5:0];
                mem_read <= 1'b1;
                mem_select <= 1'b1;
                load <= 1'b1;
            end
            4'b1100: begin // STORE
                addr_a <= 3'b000;
                mem_addr <= instruction[5:0];
                mem_write <= 1'b1;
            end
            default: begin
                // Mantenha os valores padrão se a instrução for inválida
            end
        endcase

    end
endmodule
