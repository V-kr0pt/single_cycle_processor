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

   integer i; // Declare loop variable

    always @(posedge clk or posedge reset_all) begin
        if (reset_all) begin // Reset all registers
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        end else if (reset) begin // Reset specific register
            registers[addr_a] <= 8'b0;
        end else if (load) begin // Load data into the specific register
            registers[addr_a] <= d_in;
        end
    end
    
    always @(*) begin
        val_a <= registers[addr_a];
        if (mb_select) begin
            val_b <= registers[addr_b];
        end else begin
            val_b <= addr_b; 
        end
    end
endmodule