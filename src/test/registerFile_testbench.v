module registerFile_testbench();

    reg clk;
    reg reset;
    reg reset_all;
    reg load;

    reg [2:0] addr_a;
    reg [2:0] addr_b;
    reg [7:0] d_in;
    reg mb_select;
    
    wire [7:0] out_a;
    wire [7:0] out_b;

    integer i; // variável auxiliar de controle do loop

    // Instanciando o módulo do registrador
    FileRegister test_register (
        .clk(clk),
        .reset(reset),
        .reset_all(reset_all),
        .load(load),
        .addr_a(addr_a), // endereço do registrador A
        .addr_b(addr_b), // endereço do registrador B
        .d_in(d_in),
        .mb_select(mb_select), // seleciona se val_b vai ser o dado de entrada ou o dado do registrador
        .val_a(out_a) , // saída do registrador A
        .val_b(out_b) // saída do registrador B
    );

    // Gera o clock 
    always #5 clk = ~clk; // alterna seu estado em 5 blocos de tempo

    initial begin
        // Configuração para gerar o arquivo .vcd
        $dumpfile("test_FileRegister.vcd");
        $dumpvars(0, registerFile_testbench);

        // Inicializa os sinais
        clk = 0;
        reset = 0;
        reset_all = 0;
        load = 0;
        addr_a = 0;
        addr_b = 0;
        d_in = 0;
        mb_select = 0;

        // Aplica reset_all
        #10 reset_all = 1;
        #10 reset_all = 0;       

        // Teste 1: Carrega um valor em cada registrador
        $display("Test 1: Loading values in all registers...");
        for (i = 0; i < 8; i++) begin
            addr_a = i[2:0]; // endereço do registrador 3 bits menos significativos de i
            load = 1;
            d_in = 8'b10101010+addr_a; // valor a ser carregado no registrador A
            #10 load = 0;
            #10; //espera pra ver o resultado
            $display("Address A: %d, Address B: %d, d_in: %b, out_a: %b, out_b: %b, load: %b", addr_a, addr_b, d_in, out_a, out_b, load);
        end
        $display("Test 1 done!");

        
        $display("Test 2: Resetting one register...");
        // Teste 2: Reseta o endereço de um registrador
        addr_a = 3'b000;   
        addr_b = 3'b001;
        reset = 1;
        #10 reset = 0;
        #10; //espera pra ver o resultado
        $display("Address A: %d, Address B: %d, d_in: %b, out_a: %b, out_b: %b, load: %b", addr_a, addr_b, d_in, out_a, out_b, load);
        $display("Test 2 done!");

        $display("Test 3: Changing input without changing load...");
        // Teste 3: Coloca outro valor na entrada sem alterar o load
        #10 d_in = 8'b11001100;
        $display("Address A: %d, Address B: %d, d_in: %b, out_a: %b, out_b: %b, load: %b", addr_a, addr_b, d_in, out_a, out_b, load);
        $display("Test 3 done!");

        $display("Test 4: Changing load and varying address to change register value...");
        // Teste 4: Altera o load e varia o endereço para alterar o valor do registrador
        #5 load = 1;
        for (i = 0; i < 8; i++) begin
            #10 addr_a = i[2:0];
            $display("Address A: %d, Address B: %d, d_in: %b, out_a: %b, out_b: %b, load: %b", addr_a, addr_b, d_in, out_a, out_b, load);
        end
        #5 load = 0;
        $display("Test 4 done!");

        $display("Test 5: Put a constant as val_b...");
        // Teste 5: Coloca um valor constante em val_b
        #10 addr_b = 3'b001;
        mb_select = 1;
        $display("Address A: %d, Address B: %d, d_in: %b, out_a: %b, out_b: %b, load: %b", addr_a, addr_b, d_in, out_a, out_b, load);
        $display("Test 6 done!");


        $display("Test 6: Reset all registers...");
        // Teste 6: Aplica reset_all (deve zerar o registrador mesmo sem estar na borda positiva do clock)
        #10 reset_all = 1;
        #10 reset_all = 0;
        $display("Test 6 done!");

        $display("Test finished! :D");

        #50 $finish;
    end

endmodule
