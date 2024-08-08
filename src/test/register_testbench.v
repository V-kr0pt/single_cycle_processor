module register_testbench();

    reg clk;
    reg reset;
    reg load;
    reg [7:0] d_in;
    wire [7:0] q_out;

    // Instanciando o módulo do registrador
    register test_register (
        .clk(clk),
        .reset(reset),
        .load(load),
        .d_in(d_in),
        .q_out(q_out)
    );

    // Gera o clock 
    always #5 clk = ~clk; // alterna seu estado em 5 blocos de tempo

    initial begin
        // Configuração para gerar o arquivo .vcd
        $dumpfile("test_register.vcd");
        $dumpvars(0, register_testbench);

        // Inicializa os sinais
        clk = 0;
        reset = 0;
        load = 0;
        d_in = 8'b0;

        // Aplica reset
        #10 reset = 1;
        #10 reset = 0;

        // Teste 1: Carrega um valor no registrador
        #10 load = 1; d_in = 8'b10101010;
        #10 load = 0;

        // Teste 2: Carrega outro valor no registrador sem mudar o load
        #10 d_in = 8'b11001100;

        // Teste 3: Altera o load para ver mudança no registrador
        #10 load = 1;
        #10 load = 0;

        // Teste 3: Aplica reset (deve zerar o registrador mesmo sem estar na borda positiva do clock)
        #10 reset = 1;
        #10 reset = 0;

        #50 $finish;
    end

endmodule
