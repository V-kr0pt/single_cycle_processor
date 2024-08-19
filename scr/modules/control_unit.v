module control_unit(
    input [9:0] instruction,      // palavra iiiidddddd (10 bits)
    output reg [2:0] reg_a_select, // Seleção do registrador A (3 bits)
    output reg [2:0] reg_b_select, // Seleção do registrador B (3 bits)
    output reg [7:0] write_enable, // Sinal de habilitação de escrita para 8 registradores
    output reg [3:0] g_select,    // Sinal de controle da ALU 
    output reg mem_read,          // Sinal de leitura da memória
    output reg mem_write,         // Sinal de escrita na memória
    output reg branch,            // Sinal de desvio
    output reg jmp,               // Sinal de salto
    output reg [1:0] mb_select,   // Seleção do caminho para Bus B
    output reg mf_select,         // Seleção do caminho para Bus F
    output reg md_select,         // Seleção do caminho para Bus D
    output reg [7:0] constant_in, // Constante para operações imediatas
    output reg reset              // Sinal de reset global
);

wire [3:0] opcode;

// Decodifica a instrução
assign opcode = instruction[9:6];  // Bits 9-6 são o opcode

always @(*) begin

    // Inicialização dos sinais de controle
    write_enable = 8'b00000000;
    constant_in = 8'b00000000;
    g_select = 4'b0000; 
    mem_read = 0;
    mem_write = 0;
    branch = 0;
    jmp = 0;
    mb_select = 2'b00;
    mf_select = 0;
    md_select = 0;
    reset = 0;
    

    case(opcode)
        4'b0000: begin // ADD
            g_select <= 4'b0000; // ADD na ALU
            reg_a_select <= instruction[5:3]; 
            reg_b_select <= instruction[2:0];
            mf_select <= 1; // Coloca a saída da ALU no Bus F
            md_select <= 1; // MUX F coloca saída no Bus D
            write_enable[reg_a_select] <= 1; // Habilita a escrita no registrador A
        end
        
        4'b0001: begin // SUB
            g_select <= 4'b0001; // SUB na ALU
            reg_a_select <= instruction[5:3]; 
            reg_b_select <= instruction[2:0];
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end
        
        4'b0010: begin // ADDI
            g_select <= 4'b0000; // ADD na ALU
            reg_a_select <= instruction[5:3]; 
            constant_in <= instruction[2:0];
            mb_select <= 2'b01; // Seleciona o imediato para Bus B
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end
        
        4'b0011: begin // SUBI
            g_select <= 4'b0001; // SUB na ALU
            reg_a_select <= instruction[5:3]; 
            constant_in <= instruction[2:0]; 
            mb_select <= 2'b01; // Seleciona o imediato para Bus B
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end
        
        4'b0100: begin // MUL2
            g_select <= 4'b0101; // MUL2 na ALU
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end
        
        4'b0101: begin // DIV2
            g_select <= 4'b0110; // DIV2 na ALU 
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end
        
        4'b0110: begin // CLR: Zera um registrador
            mf_select <= 0; // Não precisamos colocar o valor da ALU no Bus F
            md_select <= 0; // Não passamos pela ALU, zeramos diretamente
            write_enable[reg_a_select] <= 1; // Zera o registrador
        end
        
        4'b0111: begin // RST: Reseta todos os registradores
            reset <= 1; // Ativa o reset global para zerar todos os registradores
        end

        4'b1000: begin // MOV: Copia regB para regA
            reg_a_select <= instruction[5:3]; // Seleciona o registrador de destino (regA)
            reg_b_select <= instruction[2:0]; // Seleciona o registrador de origem (regB)
            mb_select <= 2'b00; // Seleciona o registrador B para Bus B
            mf_select <= 1; 
            md_select <= 1; 
            write_enable[reg_a_select] <= 1; 
        end 
        
        4'b1001: begin // JMP: Salto para um endereço
           
        end
        
        4'b1010: begin // OUT: Envia dado ao hardware de saída
            
        end
        
        4'b1011: begin // LOAD: Carrega da memória para um registrador
           
        end
        
        4'b1100: begin // STORE: Armazena o conteúdo de um registrador na memória
            
        end
        
        default: begin
            // Instrução inválida ou não reconhecida
            write_enable <= 8'b00000000;
            g_select <= 4'b0000;
            mem_read <= 0;
            mem_write <= 0;
            branch <= 0;
            jmp <= 0;
            mb_select <= 2'b00;
            mf_select <= 0;
            md_select <= 0;
        end
    endcase
end

endmodule
