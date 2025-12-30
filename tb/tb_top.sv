//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : tb_top.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
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

    uart_top dut (
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .clk_per_bit(vif.clk_per_bit),
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
        forever #60 vif.clk = ~vif.clk;
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
