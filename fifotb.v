`timescale 1ns / 1ps
module fifo_tb;
    parameter WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH);

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [WIDTH-1:0] din;
    wire [WIDTH-1:0] dout;
    wire full;
    wire empty;
    wire [ADDR_WIDTH:0] count;
    
    // Instantiate FIFO
    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .count(count)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        #20;
        rst = 0;
        
        // Write 10 values into FIFO
        repeat (10) begin
            @(posedge clk);
            wr_en = 1;
            din = $random;
        end
        wr_en = 0;
        
        // Wait for a few clock cycles
        #50;
        
        // Read out 10 values from FIFO
        repeat (10) begin
            @(posedge clk);
            rd_en = 1;
        end
        rd_en = 0;
        
        #50;
        $finish;
    end
endmodule
