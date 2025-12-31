//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_if.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 31-12-2025
// Version     : 1.1
// Description : UART interface definition with clock,
//               reset, TX/RX signals, control flags,
//               baud rate, and embedded protocol
//               assertions/coverage for reset, stop
//               bit, RX stability, and TX idle checks.
//=====================================================


interface uart_interface;
    logic clk;
    logic rst_n;
    logic tx;
    logic rx;
    logic [7:0] tx_data;
    logic rx_valid;
    logic tx_valid;
    logic frame_error;
    logic parity_error;
    logic parity_en;
    logic [12:0] clk_per_bit;
    logic [17:0] baud_rate;

    property p_reset_clear;
        @(posedge clk) disable iff (rst_n)
            1 |-> (!rx_valid && !tx_valid && !frame_error && !parity_error);
    endproperty
    assert property (p_reset_clear)
        else $error("Flags not cleared during reset");
    
    property p_frame_error_stopbit;
        @(posedge clk) disable iff (!rst_n)
      frame_error |=> (rx == 1);
    endproperty
    assert property (p_frame_error_stopbit)
        else $error("Frame error asserted incorrectly");
      
    property p_rx_valid_stable;
        @(posedge clk) disable iff (!rst_n)
            rx_valid |-> $stable(rx);
    endproperty
    assert property (p_rx_valid_stable)
        else $error("RX valid asserted while RX unstable");
      
    property p_tx_valid_idle;
        @(posedge clk) disable iff (!rst_n)
            tx_valid |-> (tx == 1);
    endproperty
    assert property (p_tx_valid_idle)
        else $error("TX valid asserted when TX not idle");

    cover property (p_rx_valid_stable);
    cover property (p_tx_valid_idle);

endinterface
