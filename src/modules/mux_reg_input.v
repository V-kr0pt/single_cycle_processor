module mux_reg_input(
    input wire [7:0] memory_output,
    input wire [7:0] ALU_output,
    input wire memory_select,
    output wire [7:0] reg_input
);

    assign reg_input = memory_select ? memory_output : ALU_output;

endmodule