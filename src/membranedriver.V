module membranedriver(
    input wire clk,
    input wire rst,
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out0,
    output reg out1,
    output reg out2,
    output reg [3:0] data_out
     /* key
    0-9 digits
    10 = hash or enter
    11 = star

    13 = no command

    */
);
reg [3:0] recenthit;
reg [3:0] step;
reg [3:0] cyclehits;
reg [3:0] prior;

always @(posedge clk) begin
    if (rst) begin
        out0 <= 1'b0;
        out1 <= 1'b0;
        out2 <= 1'b0;
        data_out <= 4'd13;
        step <= 4'd0;
        recenthit <= 4'd13;
        cyclehits <= 4'd0;
        prior <= 4'd13;
    end else begin
        // Default: maintain current values (synthesis-friendly pattern)
        out0 <= out0;
        out1 <= out1;
        out2 <= out2;
        
        case (step)
        4'd0: begin
        data_out <= 4'd13;
        recenthit <= 4'd13;
        cyclehits <= 4'd0;
        end

        4'd1: begin
            out0 <= 1;
        end
        4'd2: begin
            if (in0) begin
                recenthit <= 4'd1;
                cyclehits <= cyclehits + 1;
            end
            if (in1) begin
                recenthit <= 4'd4;
                cyclehits <= cyclehits + 1;
            end
            if (in2) begin
                recenthit <= 4'd7;
                cyclehits <= cyclehits + 1;
            end
            if (in3) begin
                recenthit <= 4'd11;
                cyclehits <= cyclehits + 1;
            end
        end
        4'd3: begin
            out0 <= 0;
        end



        4'd4: begin
            out1 <= 1;
        end
        4'd5: begin
            if (in0) begin
                recenthit <= 4'd2;
                cyclehits <= cyclehits + 1;
            end
            if (in1) begin
                recenthit <= 4'd5;
                cyclehits <= cyclehits + 1;
            end
            if (in2) begin
                recenthit <= 4'd8;
                cyclehits <= cyclehits + 1;
            end
            if (in3) begin
                recenthit <= 4'd0;
                cyclehits <= cyclehits + 1;
            end
        end
        4'd6: begin
            out1 <= 0;
        end



        4'd7: begin
            out2 <= 1;
        end
        4'd8: begin
            if (in0) begin
                recenthit <= 4'd3;
                cyclehits <= cyclehits + 1;
            end
            if (in1) begin
                recenthit <= 4'd6;
                cyclehits <= cyclehits + 1;
            end
            if (in2) begin
                recenthit <= 4'd9;
                cyclehits <= cyclehits + 1;
            end
            if (in3) begin
                recenthit <= 4'd10;
                cyclehits <= cyclehits + 1;
            end
        end
        4'd9: begin
            out2 <= 0;
        end

        4'd10: begin
            if (cyclehits == 1) begin
                if (recenthit == prior) begin
                    data_out <= 4'd13; // no command
                end else begin
                    data_out <= recenthit;
                    prior <= recenthit;
                end
            end else if (cyclehits == 0) begin
                data_out <= 4'd13; // no command
                prior <= 4'd13;
            end else begin
                data_out <= 4'd13; // no command if multiple hits
            end
        end
        4'd11: begin
            data_out <= 4'd13; // clear output after one cycle
            step <= 4'd15; // skip to end to reset
        end
        
        default: begin
            // Ensure outputs hold their values in unspecified steps
        end
       
        endcase
        
        // Explicit step counter with wrap
        if (step >= 4'd15)
            step <= 4'd0;
        else
            step <= step + 1;
    end
end







endmodule

// Example testbench demonstrating a synchronous `case` on a 4-bit `step`
// Compatible with Icarus Verilog. Append or adapt actions as needed.
