`timescale 1ns / 1ps
module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input clk,            // common clock (for synchronous mode)
    input rst,            // synchronous reset (active high)
    input wr_en,          // write enable
    input rd_en,          // read enable
    input [WIDTH-1:0] din,// data input
    output reg [WIDTH-1:0] dout, // data output
    output full,          // FIFO full flag
    output empty,         // FIFO empty flag
    output reg [ADDR_WIDTH:0] count // occupancy counter
);
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    
    // Write process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            dout <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Occupancy counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;  // write only
                2'b01: count <= count - 1;  // read only
                default: count <= count;
            endcase
        end
    end

    assign full = (count == DEPTH);
    assign empty = (count == 0);

endmodule
