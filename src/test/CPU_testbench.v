module CPU_testbench;
    // Declaração dos sinais
    reg clk;
    reg reset; 
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;
    wire [6:0] HEX6;
    wire [6:0] HEX7;
    
    
    // Instanciação do módulo da CPU
    CPU uut (
        .clk(clk),
        .reset_CPU(reset),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7) 
    );  
    // Geração do clock
     // Inicializa o clock
    initial begin
        clk = 0; // Inicializa o clock
    end
    always #5 clk = ~clk; // Alterna o clock a cada 5 unidades de tempo
    
    // Vetores de teste
    initial begin
        // Configuração para gerar o arquivo .vcd
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, CPU_testbench);  

        // Inicialização
        reset = 1;
        #5 reset = 0;
      
        // espera até as instruções serem executadas
        #200

        // Finalização da simulação
        $finish;
    end 

endmodule