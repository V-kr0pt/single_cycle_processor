module CPU(
    input wire clk,             // Clock
    input wire reset_CPU,       // Reset da CPU 
    output wire [6:0] HEX0,      // Saída para o display 0 de 7 segmentos
    output wire [6:0] HEX1,      // Saída para o display 1 de 7 segmentos
    output wire [6:0] HEX2,      // Saída para o display 2 de 7 segmentos
    // output wire [6:0] HEX3,      // Saída para o display 3 de 7 segmentos
    // output wire [6:0] HEX4,      // Saída para o display 4 de 7 segmentos
    // output wire [6:0] HEX5,      // Saída para o display 5 de 7 segmentos
    // output wire [6:0] HEX6,      // Saída para o display 6 de 7 segmentos
    // output wire [6:0] HEX7,      // Saída para o display 7 de 7 segmentos
    output wire carrier_flag,    // Flag de carry
    output wire zero_flag,       // Flag de zero
    output wire negative_flag,    // Flag de negativo
    // Debug outputs
    output wire [9:0] dbg_instruction,
    output wire [2:0] dbg_addr_a,
    output wire [2:0] dbg_addr_b,
    output wire [7:0] dbg_reg_input,
    output wire [7:0] dbg_val_a,
    output wire [7:0] dbg_val_b,
    output wire [3:0] dbg_ALU_opcode,
    output wire [7:0] dbg_ALU_output,
    output wire [5:0] dbg_mem_addr,
    output wire [7:0] dbg_mem_output,
    output wire dbg_zero_flag,
    output wire dbg_carrier_flag,
    output wire dbg_negative_flag,
    output wire dbg_mem_read,
    output wire dbg_mem_write,
    output wire dbg_mem_select,
    output wire dbg_load_PC,
    output wire dbg_mb_select,
    output wire dbg_load,
    output wire [7:0] dbg_pc_input,
    output wire [7:0] dbg_pc_output,
    output wire dbg_reset_FR,
    output wire dbg_reset_all_FR
);


    // DeclaraÃ§Ã£o de sinais internos
    wire [9:0] instruction;  // InstruÃ§Ã£o
    wire [2:0] addr_a;  // Registrador A
    wire [2:0] addr_b;  // Registrador B
    wire reset_FR;  // Reset FileRegister
    wire reset_all_FR; // Reset all FileRegister
    wire load;
    wire mb_select; // Seleciona se val_b Ã© um instantaneo ou um dado de um registrador
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
    

    // InstanciaÃ§Ã£o de mÃ³dulos
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


    // MÃ³dulo de controle
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


    // MÃ³dulo de registradores
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


    // MÃ³dulo da ALU
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


    // MÃ³dulo memÃ³ria de dados
    DataMemory data_memory(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(mem_addr),
        .data_in(val_a),
        .data_out(mem_output)
    );

    // MÃ³dulo mux de entrada do registrador
    mux_reg_input mux_reg_input(
        .memory_select(mem_select),
        .memory_output(mem_output),
        .ALU_output(ALU_output),
        .reg_input(reg_input)
    );
	 
	 d7s display (
	  .read_data(mem_output),
      .Y0(HEX0),
      .Y1(HEX1),
      .Y2(HEX2)
	 );
	 
	 // Connect internal signals to debug outputs
    assign dbg_instruction = instruction;
    assign dbg_addr_a = addr_a;
    assign dbg_addr_b = addr_b;
    assign dbg_reg_input = reg_input;
    assign dbg_val_a = val_a;
    assign dbg_val_b = val_b;
    assign dbg_ALU_opcode = ALU_opcode;
    assign dbg_ALU_output = ALU_output;
    assign dbg_mem_addr = mem_addr;
    assign dbg_mem_output = mem_output;
    assign dbg_mem_select = mem_select;
    assign dbg_zero_flag = zero_flag;
    assign dbg_carrier_flag = carrier_flag;
    assign dbg_negative_flag = negative_flag;
    assign dbg_mem_read = mem_read;
    assign dbg_mem_write = mem_write;
    assign dbg_load_PC = load_PC;
    assign dbg_load = load;
    assign dbg_mb_select = mb_select;
    assign dbg_pc_input = pc_input;
    assign dbg_pc_output = pc_output;
    assign dbg_reset_FR = reset_FR;
    assign dbg_reset_all_FR = reset_all_FR | reset_CPU;

endmodule