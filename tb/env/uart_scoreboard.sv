//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_scoreboard.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 28-12-2025
// Version     : 1.1
// Description : UART UVM scoreboard compares TX vs RX data,
//               counts total, matched, and mismatched transactions.
//=====================================================

class uart_scoreboard extends uvm_component;
    `uvm_component_utils(uart_scoreboard)

    uvm_analysis_imp #(uart_transaction, uart_scoreboard) soc_export;

    function new (string name = "uart_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        soc_export = new("soc_export", this);
    endfunction

    int total_reads         = 0;
    int matched_reads       = 0;
    int mismatched_reads    = 0;;

    task write(uart_transaction tr);
        if(tr.rx_valid == 1'b1) begin
            total_reads++;
            if(tr.tx_data != tr.rx_data) begin
                mismatched_reads++;
                `uvm_error(get_type_name(),$sformatf("Mismatched tx_data = 0x%0h <==> rx_data = 0x%0h",tr.tx_data,tr.rx_data))
            end
            else begin
                matched_reads++;
                `uvm_info(get_type_name(),$sformatf("Matched rx_data=0x%0h",tr.rx_data),UVM_LOW)
            end
        end
    endtask
endclass
        
