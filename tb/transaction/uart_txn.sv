//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_txn.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.0
// Description : UART transaction class carrying data,
//               control, error flags, and baud rate.
//=====================================================

class uart_transaction extends uvm_sequence_item;
    
    rand bit [7:0] tx_data;
         bit [7:0] rx_data;
         bit       rx_valid;
         bit       tx_valid;
    rand bit       parity_en;
         bit       frame_error;
         bit       parity_error;
    rand bit [12:0] baud_rate;

    `uvm_object_utils_begin(uart_transaction)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
        `uvm_field_int(tx_valid, UVM_ALL_ON)
        `uvm_field_int(rx_valid, UVM_ALL_ON)
        `uvm_field_int(parity_en, UVM_ALL_ON)
        `uvm_field_int(parity_error, UVM_ALL_ON)
        `uvm_field_int(frame_error, UVM_ALL_ON)
        `uvm_field_int(baud_rate, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "uart_transaction");
        super.new(name);
    endfunction

endclass
