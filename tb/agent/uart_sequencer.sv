//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_sequencer.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.0
// Description : UVM sequencer for UART transactions.
//=====================================================

class uart_sequencer extends uvm_sequencer#(uart_transaction);
    `uvm_component_utils(uart_sequencer)

    function new (string name = "uart_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass