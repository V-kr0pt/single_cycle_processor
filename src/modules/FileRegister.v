// Vamos ter 3 bits livres para endereçar os registradores.
// O que nos permite ter até 8 registradores.
module FileRegister(
    //Entradas
    input wire clk, 
    input wire reset, // reseta o registrador do endereço addr_a
    input wire reset_all, // reseta todos os registradores
    input wire load, // permite salvar dado no endereço addr_a 
    input wire [2:0] addr_a,  // 3 bits para endereçar os registradores
    input wire [2:0] addr_b,  // 3 bits para endereçar os registradores
    input wire [7:0] d_in, // dado de entrada para o registrador addr_a
    input wire mb_select, // seleciona se val_b vai ser o próprio addr_b ou o dado do registrador
    // Saídas
    output reg [7:0] val_a, // saída do registrador barramento A
    output reg [7:0] val_b // saída do registrador barramento B
);

    reg [7:0] registers [0:7];  // 8 registradores de 8 bits

    integer i; // variável de controle do loop
    always @(posedge clk or posedge reset) begin
        if (reset) begin //zera o registrador no endereço add_a
            registers[addr_a] <= 8'b0;
        
        end else if (reset_all) begin //zera todos os registradores
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        
        end else if (load) begin // carrega dado no registrador addr_a
            registers[addr_a] <= d_in;
        end
    end
    
    always @(*) begin
        val_a = registers[addr_a];
        if (mb_select) begin
            val_b = registers[addr_b];
        end else
            val_b = addr_b; 
    end
endmodule