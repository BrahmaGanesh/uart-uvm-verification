//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_package.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 31-12-2025
// Version     : 1.0
// Description : UART UVM package including all components,
//               sequences, env, and base tests.
//=====================================================

package pkg;
	 import uvm_pkg::*;
    `include "uvm_macros.svh" 

	`include "uart_transaction.sv"
	`include "uart_sequence.sv"
	`include "uart_sequencer.sv"
	`include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_scoreboard.sv"
    `include "uart_coverage.sv"
    `include "uart_agent.sv"
    `include "uart_env.sv"

    `include "uart_base_test.sv"
    `include "uart_back_to_back_seq.sv"
    `include "uart_repeat10_seq.sv"
    `include "uart_baud_rate_seq.sv"
    `include "uart_frame_error_seq.sv"
    `include "uart_parity_error_seq.sv"
    `include "uart_virtual_seq.sv"
endpackage