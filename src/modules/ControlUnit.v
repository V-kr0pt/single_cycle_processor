module ControlUnit(
    // Entradas
    input clk,                  // Clock
    input [9:0] instruction,      // palavra iiiidddddd (10 bits)
    
    //Saídas (sinais de controle)
    
    //Registrador
    output reg [2:0] addr_a,    // Seleção do registrador A (3 bits)
    output reg [2:0] addr_b,    // Seleção do registrador B (3 bits)
    output reg reset,               // Sinal de reset para o registrador A
    output reg reset_all,       // Sinal de reset para todos registradores
    output reg load,    // Sinal de habilitação de escrita para o registrador A
    output reg mb_select,       // Seleção do caminho para Bus B
    
    //ALU
    output reg [3:0] ALU_opcode,        // Sinal de controle da ALU 
    
    // Memória
    output reg mem_read,              // Sinal de leitura da memória
    output reg mem_write,             // Sinal de escrita na memória
    output reg [5:0] mem_addr,       // Endereço da memória
    output reg mem_select,           // Seleção do caminho para Bus D
    
   
    // PC
    output reg load_PC,                  // Sinal de carga para o PC
    output reg [7:0] pc_value       // Valor a ser carregado no PC

);

    // Inicialização das variáveis
    initial begin
        addr_a = 3'b0;
        addr_b = 3'b0;
        reset = 0;
        reset_all = 0;
        load = 0;
        mb_select = 0;
        ALU_opcode = 4'b0;
        mem_read = 0;
        mem_write = 0;
        mem_addr = 6'b0;
        mem_select = 0;
        load_PC = 0;
        pc_value = 8'b0;        
    end

 
    // Decodifica a instrução
    wire [3:0] opcode = instruction[9:6];  // Bits 9-6 são o opcode

    always @(posedge clk) begin
        case(opcode)
            4'b0000: begin // ADD  
                ALU_opcode <= 4'b0000; // operação de soma na ALU                               
                addr_a <= instruction[5:3]; 
                addr_b <= instruction[2:0];
                load <= 1; // Habilita a escrita no registrador A
                mb_select <= 1; // Seleciona o registrador B para Bus B
                mem_select <= 0; // Resultado da ULA para entrada do registrador A
                
                // Outros sinais em zero
                reset <= 0;
                reset_all <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b0001: begin // SUB
                ALU_opcode <= 4'b0001; 
                addr_a <= instruction[5:3]; 
                addr_b <= instruction[2:0];
                mb_select <= 1; // Seleciona o registrador B para Bus B
                load <= 1; // Habilita a escrita no registrador A
                mem_select <= 0; // Resultado da ULA para entrada do registrador A

                // Outros sinais em zero
                reset <= 0;
                reset_all <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;   
            end

            4'b0010: begin // ADDI
                ALU_opcode <= 4'b0000; 
                addr_a <= instruction[5:3]; 
                addr_b <= instruction[2:0]; // Constante dos 3 bits menos significativos
                mb_select <= 0; // Seleciona o addr_b para Bus B
                load <= 1; // Habilita a escrita no registrador A
                mem_select <= 0; // Resultado da ULA para entrada do registrador A
                
                //Outros sinais em zero
                reset <= 0;
                reset_all <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;   
            end

            4'b0011: begin // SUBI
                ALU_opcode <= 4'b0001; 
                addr_a <= instruction[5:3]; 
                addr_b <= instruction[2:0]; 
                mb_select <= 0; // Seleciona o addr_b para Bus B
                load <= 1; // Habilita a escrita no registrador A
                mem_select <= 0; // Resultado da ULA para entrada do registrador A


                // Outros sinais em zero
                reset <= 0;
                reset_all <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;                   
            end

            4'b0100: begin // MUL2
                ALU_opcode <= 4'b0010; 
                addr_a <= instruction[5:3]; 
                load <= 1; 
                mem_select <= 0; // Resultado da ULA para entrada do registrador A

                // Outros sinais em zero
                addr_b <= 3'b000;
                reset <= 0;
                reset_all <= 0;
                mb_select <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b0101: begin // DIV2
                ALU_opcode <= 4'b0011; 
                addr_a <= instruction[5:3]; 
                load <= 1; 
                mem_select <= 0; // Resultado da ULA para entrada do registrador A

                // Outros sinais em zero
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                mb_select <= 0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b0110: begin // CLR: Zera um registrador
                addr_a <= instruction[5:3];
                reset <= 1; // Zera o registrador

                // Outros sinais em zero
                addr_b <= 3'b0;
                reset_all <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                mem_select <= 0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b0111: begin // RST: Reseta todos os registradores
                reset_all <= 1; // Zera todos os registradores

                // Outros sinais em zero
                addr_a <= 3'b0;
                addr_b <= 3'b0;
                reset <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                mem_select <= 0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b1000: begin // MOV: Copia regB para regA
                ALU_opcode <= 4'b0100;
                addr_a <= instruction[5:3]; 
                addr_b <= instruction[2:0]; 
                mb_select <= 1; // Seleciona o registrador B para Bus B
                mem_select <= 0;
                load <= 1; 

                // Outros sinais em zero
                reset <= 0;
                reset_all <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end 

            4'b1001: begin // JMP: Salto para um endereço
                load_PC <= 1;                      // PC capaz de carregar valor
                pc_value <= instruction[5:0];  // Define o novo valor do PC a partir dos 6 bits menos significativos da instrução
            
                // Outros sinais em zero
                addr_a <= 3'b0;
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                mem_select <= 0;                     
            end

            4'b1010: begin // OUT: Envia dado ao hardware de saída
                addr_a <= instruction[5:3]; // Seleciona o registrador A para a saída
                // VER COMO FICOU O LCD
                
                // Outros sinais em zero
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                mem_select <= 0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b1011: begin // LOAD: Carrega da memória para o registrador de endereço 0x00
                addr_a <= 3'b0; // Registrador de endereço 0x00
                mem_addr <= instruction[5:0]; // Endereço da memória de dados
                mem_read <= 1;     // Habilita a leitura da memória
                mem_select <= 1;    // Seleciona o dado da memória para Bus D
                load <= 1; // Habilita a escrita no registrador A

                // Outros sinais em zero
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_write <= 0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            4'b1100: begin // STORE: Armazena o conteúdo do registrador 0x00 na memória
                addr_a <= 3'b0; // Seleciona o registrador A cujo valor será armazenado
                mem_addr <= instruction[5:0]; // Endereço da memória de dados
                mem_write <= 1; // Habilita a escrita na memória

                // Outros sinais em zero
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_select <= 0;
                load_PC <= 0;
                pc_value <= 8'b0;
            end

            default: begin
                // Instrução inválida ou não reconhecida
                addr_a <= 3'b0;
                addr_b <= 3'b0;
                reset <= 0;
                reset_all <= 0;
                load <= 0;
                mb_select <= 0;
                ALU_opcode <= 4'b0;
                mem_read <= 0;
                mem_write <= 0;
                mem_addr <= 6'b0;
                mem_select <= 0;
                load_PC <= 0;
                pc_value <= 8'b0; 
            end
        endcase
    end

endmodule
