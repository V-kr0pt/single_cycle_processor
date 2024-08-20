module PC_testbench();

    // Inputs
    reg clk;
    reg reset;
    reg load;
    reg [7:0] set_value;

    // Outputs
    wire [7:0] points;

    // Instantiate the point counter module
    PointCounter point_counter (
        .clk(clk),
        .reset(reset),
        .load(load),
        .set_value(set_value),
        .points(points)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Gerando arquivos .vcd
        $dumpfile("test_PC.vcd");
        $dumpvars(0, PC_testbench);

        // Initialize inputs
        clk = 0;
        reset = 1;
        load = 0;
        set_value = 10;

        // Começa o contador
        #5 reset = 0;

        //  Carrega novo valor no contador
        #15 load = 1;

        // Finaliza com o reset
        #10 load = 0;
        #10 reset = 1;
        
        // Wait for simulation to complete
        #10 $finish;
    end

endmodule