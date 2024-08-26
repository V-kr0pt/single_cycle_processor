module PointCounter (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] set_value,
    output reg [7:0] points
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            points <= 0;
        else if (load)
            points <= set_value;
        else
            points <= points + 1;
    end

endmodule