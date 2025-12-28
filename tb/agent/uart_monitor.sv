//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_monitor.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.1
// Description : UVM monitor for UART transactions,
//               samples DUT interface signals,
//               captures data, parity, and error status,
//               and publishes via analysis port.
//=====================================================

class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)
    virtual uart_interface vif;

    uvm_analysis_port #(uart_transaction) mon_ap;
    
    uart_transaction tr;
    int unsigned clk_per_bit;
    logic [7:0] rx_data;

    function new(string name = "uart_monitor", uvm_component parent = null);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_interface)::get(this,"","vif",vif))
            `uvm_fatal(get_type_name(),"virtual interface not set")
    endfunction

    task automatic wait_cycles(int unsigned n);
        repeat(n) @(posedge vif.clk);
    endtask

    task run_phase(uvm_phase phase);
        forever begin
            tr = uart_transaction::type_id::create("tr");
            wait(vif.rst_n == 1'b1);

            @(posedge vif.clk);
            tr.tx_data      = vif.tx_data;
            
            wait(vif.rx_valid);
            `uvm_info(get_type_name(),"Monitor detected rx_valid...",UVM_LOW)

            wait_cycles(vif.clk_per_bit);
            wait(vif.rx == 0);
            `uvm_info(get_type_name(),"Monitor START bit sampled...",UVM_LOW)
            wait_cycles(vif.clk_per_bit);
      
            for (int i = 0; i < 8; i++) begin
                wait_cycles(vif.clk_per_bit);
                `uvm_info(get_type_name(),$sformatf("Monitor capturing data bit %0d: rx=%0b", i, vif.rx),UVM_LOW)
       		    tr.rx_data[i] = vif.rx;
            end

            if (vif.parity_en) begin
                wait_cycles(vif.clk_per_bit);
                `uvm_info(get_type_name(),"Monitor PARITY bit sampled...",UVM_LOW)
                if(vif.rx == ^tr.rx_data)
          	        tr.parity_error = 0;
                else
                tr.parity_error = 1;
            end

           `uvm_info(get_type_name(),
            $sformatf("Monitor captured RX_data=0x%0h | rx_valid=%0d | parity_err=%0d | frame_err=%0d",
            tr.rx_data, tr.rx_valid, tr.parity_error, tr.frame_error),UVM_LOW)

            wait_cycles(vif.clk_per_bit);
            tr.parity_en    = vif.parity_en;
            tr.rx_valid     = 1;
            tr.parity_error = vif.parity_error;
            tr.frame_error  = vif.frame_error;
            tr.clk_per_bit    = vif.clk_per_bit;

            `uvm_info(get_type_name(),"Monitor transaction completed.",UVM_LOW)

            mon_ap.write(tr);
        end
    endtask
endclass
