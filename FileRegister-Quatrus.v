module Microprocessador_ciclo_unico (
    input wire clk,          // Sinal de clock
    input wire reset,        // Sinal de reset
    input wire load,         // Sinal para carregar o valor no registrador
    input wire [7:0] d_in,   // Dados de entrada (8 bits)
    output reg [7:0] q_out   // Dados de saída (8 bits)
);

// Bloco always sensível ao clock e ao sinal de reset (reset não precisa funcionar na borda do clock)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_out <= 8'b0;   // Zera o registrador em caso de reset
        end else if (load) begin
            q_out <= d_in;   // Carrega o valor de entrada no registrador
        end
    end

endmodule