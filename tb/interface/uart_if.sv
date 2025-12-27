//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_if.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.0
// Description : UART interface with clock, reset,
//               TX/RX, error flags, and baud rate.
//=====================================================

interface uart_interface;
    logic clk;
    logic rst_n;
    logic tx;
    logic rx;
    logic rx_valid;
    logic tx_valid;
    logic frame_error;
    logic parity_error;
    logic parity_en;
    logic [12:0] baud_rate;

endinterface
