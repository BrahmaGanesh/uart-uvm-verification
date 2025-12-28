//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : tb.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 28-12-2025
// Version     : 1.0
// Description : Top-level UART UVM testbench.
//               Instantiates DUT and interface,
//               generates clock, dumps waveform,
//               and launches UVM test.
//=====================================================

`timescale 1ns/1ps
`include "uart_interface.sv"
`include "uart_package.sv"

module tb;
    import pkg::*;
    uart_interface vif();

    localparam int CLK_PERIOD_NS = 120;
    localparam int BAUD_RATE     = 115200;
    localparam int CLK_FREQ_HZ   = 1_000_000_000 / CLK_PERIOD_NS;
    localparam int CLK_PER_BIT   = CLK_FREQ_HZ / BAUD_RATE;


    uart_top #(.CLK_PER_BIT(CLK_PER_BIT)) dut (
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .tx(vif.tx),
        .rx(vif.rx),
        .parity_en(vif.parity_en),
        .tx_valid(vif.tx_valid),
        .rx_valid(vif.rx_valid),
        .parity_error(vif.parity_error),
        .frame_error(vif.frame_error)
    );
  
    initial begin
        vif.clk = 0;
        forever #(CLK_PERIOD_NS/2) vif.clk = ~vif.clk;
    end
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,tb);
    end
    initial begin
        uvm_config_db#(virtual uart_interface)::set(null,"*","vif",vif);
        run_test();
    end
endmodule
