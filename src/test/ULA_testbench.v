module ULA_testbench();

    reg clk;
    reg [7:0] val_a;
    reg [7:0] val_b;
    reg [3:0] op;
    wire [7:0] result;
    wire zero_flag;
    wire carrier_flag;
    wire negative_flag;

    // Instanciando o módulo da ULA
    ULA test_ula (
        .clk(clk),
        .val_a(val_a),
        .val_b(val_b),
        .op(op),
        .result(result),
        .zero_flag(zero_flag),
        .carrier_flag(carrier_flag),
        .negative_flag(negative_flag)
    );

    // Gera o clock
    always #5 clk = ~clk; // alterna seu estado em 5 blocos de tempo

    initial begin
        // Gerando arquivos .vcd
        $dumpfile("test_ULA.vcd");
        $dumpvars(0, ULA_testbench);

        // Inicializa os sinais
        clk = 0;
        val_a = 0;
        val_b = 0;
        op = 0;

        // ======== Teste 1: ADD =========
        $display("Test ADD");
        val_a = 8'b00000001;
        val_b = 8'b00000001;
        op = 4'b0000;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        $display("Test ADD negative values");
        val_a = 8'b11111111; // -1
        val_b = 8'b11111110; // -2
        op = 4'b0000;
        #10; //espera pra ver o resultado
        
        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        // ======== Teste 2: SUB =========
        $display("Test SUB with Zero Result");
        val_a = 8'b00000001;
        val_b = 8'b00000001;
        op = 4'b0001;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);


        // ======== Teste 2: Negative SUB =========
        $display("Test Negative Result");
        val_a = 8'b00000001;
        val_b = 8'b00000010;
        op = 4'b0001;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        // ======== Teste 3: MUL2 =========
        $display("Test MUL2");
        val_a = 8'b00000001;
        val_b = 8'b00000000;
        op = 4'b0101;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        // ======== Teste 4: DIV2 =========
        $display("Test DIV2");
        val_a = 8'b00000010;
        val_b = 8'b00000000;
        op = 4'b0110;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        // ======== Teste 5: Carrier =========
        $display("Test Carrier");
        val_a = 8'b11111111;
        val_b = 8'b00000001;
        op = 4'b0000;
        #10; //espera pra ver o resultado

        $display("val_a: %b, val_b: %b, op: %b, result: %b, zero_flag: %b, carrier_flag: %b, negative_flag: %b", val_a, val_b, op, result, zero_flag, carrier_flag, negative_flag);

        $display("Test finished! :D");
        #50 $finish;
    end


endmodule