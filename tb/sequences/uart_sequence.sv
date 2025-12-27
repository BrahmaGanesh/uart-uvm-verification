//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_sequence.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.0
// Description : UVM sequence generating UART transactions
//               for normal operation tests.
//=====================================================

class uart_sequence extends uvm_sequence#(uart_transaction);
    `uvm_object_utils(uart_sequence)

    uart_transaction tr;
    function new(string name = "uart_sequence");
        super.new(name);
    endfunction

    virtual task body();
    endtask
    
endclass