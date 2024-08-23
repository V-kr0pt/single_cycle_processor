module d7s(
    input [7:0] read_data,     // Entrada de 8 bits (número binário)
    output reg [6:0] Y0,       // Saída para o primeiro display (unidades)
    output reg [6:0] Y1,       // Saída para o segundo display (dezenas)
    output reg [6:0] Y2        // Saída para o terceiro display (centenas)
);

    reg [3:0] hundreds; // Dígito das centenas
    reg [3:0] tens;     // Dígito das dezenas
    reg [3:0] units;    // Dígito das unidades

    // Conversão de binário para dígitos decimais
    always @(*) begin
        integer temp;
        temp = read_data;
        
        hundreds = temp / 100;
        temp = temp % 100;
        
        tens = temp / 10;
        units = temp % 10;
    end

    // Conversão dos dígitos para o formato de 7 segmentos
    always @(*) begin
        Y0 = convert_to_7seg(units);
        Y1 = convert_to_7seg(tens);
        Y2 = convert_to_7seg(hundreds);
    end

    // Função para converter um dígito decimal em código de 7 segmentos
    function [6:0] convert_to_7seg;
        input [3:0] X;
        begin
            case (X)
                4'b0000: convert_to_7seg = ~7'b0111111; // 0
                4'b0001: convert_to_7seg = ~7'b0000110; // 1
                4'b0010: convert_to_7seg = ~7'b1011011; // 2
                4'b0011: convert_to_7seg = ~7'b1001111; // 3
                4'b0100: convert_to_7seg = ~7'b1100110; // 4
                4'b0101: convert_to_7seg = ~7'b1101101; // 5
                4'b0110: convert_to_7seg = ~7'b1111101; // 6
                4'b0111: convert_to_7seg = ~7'b0000111; // 7
                4'b1000: convert_to_7seg = ~7'b1111111; // 8
                4'b1001: convert_to_7seg = ~7'b1101111; // 9
                default: convert_to_7seg = ~7'b0000000; // Apaga o display
            endcase
        end
    endfunction

endmodule
