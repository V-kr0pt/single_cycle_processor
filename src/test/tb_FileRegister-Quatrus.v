`timescale 1ns/1ps

module tb_Microprocessador_ciclo_unico;

    reg clk;
    reg reset;
    reg load;
    reg [7:0] d_in;
    wire [7:0] q_out;

    // Instancia o módulo a ser testado
    Microprocessador_ciclo_unico uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .d_in(d_in),
        .q_out(q_out)
    );

    // Gera o clock
    always #5 clk = ~clk;  // Clock de 100 MHz (10ns de período)

    initial begin
        // Inicializa os sinais
        clk = 0;
        reset = 0;
        load = 0;
        d_in = 8'b00000000;

        // Aplica reset
        reset = 1;
        #10;
        reset = 0;

        // Teste 1: Carrega o valor 8'b10101010 no registrador
        #10;
        d_in = 8'b10101010;
        load = 1;
        #10;
        load = 0;

        // Teste 2: Verifica se o valor permanece no registrador após o reset
        #10;
        reset = 1;
        #10;
        reset = 0;

        // Teste 3: Carrega o valor 8'b01010101 no registrador
        #10;
        d_in = 8'b01010101;
        load = 1;
        #10;
        load = 0;

        // Finaliza a simulação após 100 ciclos de clock
        #1000;
        $stop;
    end

endmodule
