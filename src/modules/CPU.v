module CPU(
    input wire clk,  // Clock
    input wire reset_PC, // Reset do PC 
    output [7:0] output_port  // Saída (para o display de 7 segmentos)
);


// Declaração de sinais internos
wire [9:0] instruction;  // Instrução
wire [7:0] addr_A;  // Registrador A
wire [7:0] addr_B;  // Registrador B
wire reset_FR;  // Reset FileRegister
wire reset_all_FR // Reset all FileRegister
wire load
wire mb_select // Seleciona se val_b é um instantaneo ou um dado de um registrador
wire [7:0] reg_input

wire ALU_opcode
wire output_ula

wire mem_read
wire mem_write
wire [5:0] mem_addr
wire mem_select
wire output_mem


wire load_PC
wire [7:0] pc_input
wire [7:0] pc_output


// Instanciação de módulos
PC pc(
    .clk(clk),
    .reset(reset_PC),
    .load_PC(load_PC),
    .set_value(pc_input)
    .points(pc_output)
);


instruction_memory instruction_memory(
    .clk(clk),
    .address(pc_output),
    .instruction(instruction)
);


// Módulo de controle
control_unit control_unit(
    .clk(clk),
    .instruction(instruction),
    .addr_A(addr_A),
    .addr_B(addr_B),
    .reset(reset_FR)
    .reset_all(reset_all_FR)
    .load(load)
    .mb_select(mb_select)
    .ALU_opcode(ALU_opcode)
    .mem_read(mem_read)
    .mem_write(mem_write)
    .mem_addr(mem_addr)
    .mem_select(mem_select)
    .load_PC(load_PC)
    .pc_value(pc_input)
);


// Módulo de registradores
FileRegister file_register(
    .clk(clk),
    .reset(reset_FR),
    .reset_all(reset_all_FR),
    .load(load),
    .mb_select(mb_select),
    .addr_A(addr_A),
    .addr_B(addr_B)
    .d_in(reg_input)
);


// Módulo da ALU
ALU alu(
    .clk(clk),
    .reset(reset),
    .opcode(ALU_opcode),
    .A(addr_A),
    .B(addr_B),
    .output(ula_output)
);


// Módulo memória de dados
data_memory data_memory(
    .clk(clk),
    .read(mem_read),
    .write(mem_write),
    .address(mem_addr),
    .data_in(addr_B),
    .data_out(mem_output)
);

// Módulo mux de entrada do registrador
mux_reg_input mux_reg_input(
    .memory_select(mem_select),
    .memory_output(mem_output),
    .ula_output(ula_output),
    .reg_input(reg_input)
);