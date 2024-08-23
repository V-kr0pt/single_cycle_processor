module CPU(
    input wire clk,  // Clock
    input wire reset_CPU, // Reset da CPU 
    output [7:0] output_port,  // Saída (para o display de 7 segmentos)
    output carrier_flag,  // Flag de carry
    output zero_flag,  // Flag de zero
    output negative_flag  // Flag de negativo
);


    // Declaração de sinais internos
    wire [9:0] instruction;  // Instrução
    wire [2:0] addr_a;  // Registrador A
    wire [2:0] addr_b;  // Registrador B
    wire reset_FR;  // Reset FileRegister
    wire reset_all_FR; // Reset all FileRegister
    wire load;
    wire mb_select; // Seleciona se val_b é um instantaneo ou um dado de um registrador
    wire [7:0] reg_input;


    wire [7:0] val_a;
    wire [7:0] val_b;
    wire [3:0] ALU_opcode;
    wire [7:0] ALU_output;

    wire mem_read;
    wire mem_write;
    wire [5:0] mem_addr;
    wire mem_select;
    wire [7:0] mem_output;


    wire load_PC;
    wire [7:0] pc_input;
    wire [7:0] pc_output;


    // Instanciação de módulos
    PointCounter pc(
        .clk(clk),
        .reset(reset_CPU),
        .load(load_PC),
        .set_value(pc_input),
        .points(pc_output)
    );


    InstructionMemory instruction_memory(
        .address(pc_output),
        .instruction(instruction)
    );


    // Módulo de controle
    ControlUnit control_unit(
        .clk(clk),
        .instruction(instruction),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .reset(reset_FR),
        .reset_all(reset_all_FR),
        .load(load),
        .mb_select(mb_select),
        .ALU_opcode(ALU_opcode),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_select(mem_select),
        .load_PC(load_PC),
        .pc_value(pc_input)
    );


    // Módulo de registradores
    FileRegister file_register(
        .clk(clk),
        .reset(reset_FR),
        .reset_all(reset_all_FR | reset_CPU),
        .load(load),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .d_in(reg_input),
        .mb_select(mb_select),
        .val_a(val_a),
        .val_b(val_b)    
    );


    // Módulo da ALU
    ULA alu(
        .clk(clk),
        .op(ALU_opcode),
        .val_a(val_a),
        .val_b(val_b),
        .result(ALU_output),
        .zero_flag(zero_flag),
        .carrier_flag(carrier_flag),
        .negative_flag(negative_flag)
    );


    // Módulo memória de dados
    DataMemory data_memory(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(mem_addr),
        .data_in(val_a),
        .data_out(mem_output)
    );

    // Módulo mux de entrada do registrador
    mux_reg_input mux_reg_input(
        .memory_select(mem_select),
        .memory_output(mem_output),
        .ALU_output(ALU_output),
        .reg_input(reg_input)
    );

endmodule