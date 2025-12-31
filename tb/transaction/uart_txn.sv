//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_txn.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 31-12-2025
// Version     : 1.1
// Description : UART transaction class extending
//               uvm_sequence_item. Encapsulates TX/RX
//               data, control flags, error injection,
//               and baud rate constraints for stimulus
//               generation and coverage.
//=====================================================

class uart_transaction extends uvm_sequence_item;
    
    rand bit [7:0] tx_data;
         bit [7:0] rx_data;
         bit       rx_valid;
         bit       tx_valid;
    rand bit       parity_en;
         bit       frame_error;
         bit       parity_error;
    rand bit [12:0] clk_per_bit;
    randc bit [16:0] baud_rate;
    rand bit parity_error_injection;
    rand bit frame_error_injection;

     constraint data_c {
        tx_data dist {
            8'h00        := 5,
            8'hFF        := 5,
            [8'h01:8'h0F] := 10,
            [8'h10:8'h7F] := 3,
            [8'h80:8'hFE] := 3
        };
    }
    constraint parity_en_c {soft parity_en inside {0,1};}
    constraint baud_rate_c {soft baud_rate inside {17'd9600,17'd10102,17'd115200};}

    `uvm_object_utils_begin(uart_transaction)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
        `uvm_field_int(tx_valid, UVM_ALL_ON)
        `uvm_field_int(rx_valid, UVM_ALL_ON)
        `uvm_field_int(parity_en, UVM_ALL_ON)
        `uvm_field_int(parity_error, UVM_ALL_ON)
        `uvm_field_int(frame_error, UVM_ALL_ON)
        `uvm_field_int(clk_per_bit, UVM_ALL_ON)
        `uvm_field_int(baud_rate, UVM_ALL_ON)
        `uvm_field_int(parity_error_injection, UVM_ALL_ON)
        `uvm_field_int(frame_error_injection, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "uart_transaction");
        super.new(name);
    endfunction

endclass
