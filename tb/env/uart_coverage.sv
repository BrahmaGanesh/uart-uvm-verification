 //=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_coverage.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 31-12-2025
// Version     : 1.0
// Description : UART UVM coverage component. Defines
//               coverpoints for parity, frame errors,
//               baud rate, and TX data, with cross
//               coverage to ensure protocol validation.
//=====================================================

 class uart_coverage extends uvm_component;
    `uvm_component_utils(uart_coverage)

    uart_transaction tr;

    uvm_analysis_imp #(uart_transaction, uart_coverage) cov_export;
    function new (string name = "uart_coverage", uvm_component parent = null);
        super.new(name, parent);
        cov_export  = new("cov_export", this);
        uart_cg     = new();
    endfunction

    function write(uart_transaction tr);
        this.tr = tr;
        uart_cg.sample();
    endfunction

    covergroup uart_cg;
        parity_cp : coverpoint tr.parity_en {
            bins disabled = {0};
            bins enabled  = {1};
        }

        parity_error_cp : coverpoint tr.parity_error {
            bins no_error = {0};
            bins error    = {1};
        }

        frame_error_cp : coverpoint tr.frame_error {
            bins no_error = {0};
            bins error    = {1};
        }

        baud_rate_cp : coverpoint tr.baud_rate {
            bins low    = {9600};
            bins mid    = {10102};
            bins high   = {115200};
        }

        tx_data_cp : coverpoint tr.tx_data {
            bins zero   = {8'h00};
            bins all1   = {8'hFF};
            bins low    = {[8'h01:8'h0F]};
            bins mid    = {[8'h10:8'h7F]};
            bins high   = {[8'h80:8'hFE]};
        }

        parity_cross        : cross parity_cp, parity_error_cp{
                                ignore_bins invalid_combo = binsof(parity_cp.disabled) &&
                                binsof(parity_error_cp.error);
                            }
        baud_frame_cross    : cross baud_rate_cp, frame_error_cp;
        baud_data_cross     : cross baud_rate_cp, tx_data_cp;
    endgroup
endclass