module clockboss(
    input wire clk,
    input wire rst,
    output reg c1,
    output reg c2
    );

    reg toggle;
    reg rst_prev;

    always @(posedge clk) begin
        rst_prev <= rst;
        
        if (rst) begin
            // On first reset cycle: drive both low
            // On subsequent reset cycles: drive both high (creating positive edge)
            if (!rst_prev) begin
                // Rising edge of reset - drive both low
                c1 <= 1'b0;
                c2 <= 1'b0;
            end else begin
                // Reset held high - drive both high (creates 0→1 edge)
                c1 <= 1'b1;
                c2 <= 1'b1;
            end
            toggle <= 1'b0;
        end else begin
            // Normal operation: alternating clocks
            toggle <= ~toggle;
            c1 <= toggle;
            c2 <= ~toggle;
        end
    end

endmodule