//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_top.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.1
// Description : // UART top-level module combining 
//                  RX and TX with loopback, parity, 
//                  and error status
//=====================================================

`include "uart_rx.sv"
`include "uart_tx.sv"

module uart_top #(parameter CLK_PER_BIT = 5208)
(
    input   logic clk,
    input   logic rst_n,
    input   logic parity_en,
    input   logic tx,
    input 	logic [12:0] clk_per_bit,
    output  logic rx,
    output  logic rx_valid,
    output  logic tx_valid,
    output  logic parity_error,
    output  logic frame_error
);
    logic [7:0] rx_data;

    uart_rx #(.CLK_PER_BIT(CLK_PER_BIT)) DUT1(
        .clk(clk),
        .rst_n(rst_n),
        .clk_per_bit(clk_per_bit),
        .parity_en(parity_en),
        .rx(tx),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .parity_error(parity_error),
        .frame_error(frame_error)
    );
    uart_tx #(.CLK_PER_BIT(CLK_PER_BIT)) DUT2(
        .clk(clk),
        .rst_n(rst_n),
        .clk_per_bit(clk_per_bit),
        .parity_en(parity_en),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx(rx),
        .tx_valid(tx_valid)
    );
endmodule