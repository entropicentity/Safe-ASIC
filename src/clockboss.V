module clockboss(
    input wire clk,
    input wire rst,
    output wire c1,
    output wire c2
    );

    reg toggle;

    assign c1 = toggle | rst;
    assign c2 = ~toggle | rst;

    always @(posedge rst) begin
        toggle <= 1'b0;
    end

    always @(posedge clk) begin
        toggle <= ~toggle;
    end

endmodule