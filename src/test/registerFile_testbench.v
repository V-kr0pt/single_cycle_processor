module registerFile_testbench();

    reg clk;
    reg reset;
    reg reset_all;
    reg load;
    reg [7:0] d_in;
    reg [2:0] address;
    wire [7:0] q_out;

    integer i; // variável auxiliar de controle do loop

    // Instanciando o módulo do registrador
    FileRegister test_register (
        .clk(clk),
        .reset(reset),
        .reset_all(reset_all),
        .load(load),
        .address(address), // endereço do registrador
        .d_in(d_in),
        .q_out(q_out)
    );

    // Gera o clock 
    always #5 clk = ~clk; // alterna seu estado em 5 blocos de tempo

    initial begin
        // Configuração para gerar o arquivo .vcd
        $dumpfile("test_FileRegister.vcd");
        $dumpvars(0, registerFile_testbench);

        // Inicializa os sinais
        clk = 0;
        reset_all = 0;
        reset = 0;
        load = 0;
        address = 0;
        d_in = 0;

        // Aplica reset_all
        #10 reset_all = 1;
        #10 reset_all = 0;       

        // Teste 1: Carrega um valor em cada registrador
        $display("Test 1...");
        for (i = 0; i < 8; i++) begin
            address = i[2:0]; // endereço do registrador 3 bits menos significativos de i
            load = 1;
            d_in = 8'b10101010+address;
            #10 load = 0;
            #10; //espera pra ver o resultado
            $display("Address: %d, d_in: %b, q_out: %b, load: %b", address, d_in, q_out, load);
        end
        $display("Test 1 done!");

        
        $display("Test 2...");
        // Teste 2: Reseta o endereço de um registrador
        address = 3'b000;   
        reset = 1;
        #10 reset = 0;
        #10; //espera pra ver o resultado
        $display("Address: %d, q_out: %b, reset: %b", address, q_out, reset);
        $display("Test 2 done!");

        $display("Test 3...");
        // Teste 3: Coloca outro valor na entrada sem alterar o load
        for (i = 0; i < 8; i++) begin
            #10 d_in = 8'b11001100;
        end
        $display("Test 3 done!");

        $display("Test 4...");
        // Teste 4: Altera o load e varia o endereço para alterar o valor do registrador
        for (i = 0; i < 8; i++) begin
            address = i[2:0];
            #10 load = 1;
        end
        #10 load = 0;
        $display("Test 4 done!");

        $display("Test 5...");
        // Teste 5: Aplica reset_all (deve zerar o registrador mesmo sem estar na borda positiva do clock)
        #10 reset_all = 1;
        #10 reset_all = 0;
        $display("Test 5 done!");

        $display("Test finished! :D");

        #50 $finish;
    end

endmodule
