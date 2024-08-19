// Vamos ter 3 bits livres para endereçar os registradores.
// O que nos permite ter até 8 registradores.
module FileRegister(
    input wire clk, 
    input wire reset, // reseta todos os registradores
    input wire load, // permite trocar dado salvo
    input wire [2:0] address,  // 3 bits para endereçar os registradores
    input wire [7:0] d_in, // entrada de dados
    output reg [7:0] q_out // saída do registrador
);

    reg [7:0] registers [0:7];  // 8 registradores de 8 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin //zera todos os registradores
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
            registers[4] <= 8'b0;
            registers[5] <= 8'b0;
            registers[6] <= 8'b0;
            registers[7] <= 8'b0;
        end else if (load) begin
            registers[address] <= d_in;
        end
    end
    
    always @(*) begin
        q_out = registers[address];
    end
endmodule