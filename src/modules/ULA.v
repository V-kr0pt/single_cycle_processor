module ULA(
    input wire clk,
    input wire [7:0] val_a,  // no max 8 bits (quantidade de bits dos registradores)
    input wire [7:0] val_b, // no max 8 bits (quantidade de bits dos registradores)
    input wire [3:0] op, // 4 bits para operações
    output reg [7:0] result,
    output reg zero_flag,
    output reg carrier_flag,
    output reg negative_flag
);
    initial begin
        result = 8'b0;
        zero_flag = 1;
        carrier_flag = 0;
        negative_flag = 0;
    end

    always @(posedge clk) begin
        case(op)
            4'b0000: {carrier_flag, result} = val_a + val_b; // ADD
            4'b0001: begin 
                        {carrier_flag, result} = val_a - val_b; // SUB
                        if ( reg_b > reg_a )
                            negative_flag = 1'b1 ;
                        else
                            negative_flag = 1'b0 ;
                     end
            4'b0010: {carrier_flag, result} = val_a << 1; // SHL or MUL2 (multiplicação por 2)
            4'b0011: {carrier_flag, result} = val_a >> 1; // SHR or DIV2 (divisão por 2)
            4'b0100: {carrier_flag, result} = val_b; // MOV
        endcase
    end

    always @(result) begin
        if (result == 0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
    end

endmodule
