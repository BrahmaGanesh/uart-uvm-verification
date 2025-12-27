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
            wait(vif.rst_n == 1'b1);
            wait(vif.rx_valid);

            `uvm_info(get_type_name(),"Monitor is started...",UVM_LOW)
            wait_cycles(vif.baud_rate);
            wait(vif.rx == 0);
            `uvm_info(get_type_name(),"Monitor is DATA started...",UVM_LOW)
            tr = uart_transaction::type_id::create("tr", this);
            wait_cycles(vif.baud_rate);
      
            for (int i = 0; i < 8; i++) begin
                wait_cycles(vif.baud_rate);
                `uvm_info(get_type_name(),$sformatf("rx=%b i=%0b rx_data=%0h",vif.rx,i,tr.rx_data),UVM_LOW)
       		    tr.rx_data[i] = vif.rx;
            end

            if (vif.parity_en) begin
                wait_cycles(vif.baud_rate);
                if(vif.rx == ^tr.rx_data)
          	        tr.parity_error = 0;
                else
                tr.parity_error = 1;
            end

            `uvm_info(get_type_name(),$sformatf("Monitor captured data=0x%0h | rx_valid=%0d | parity_err=%0d | frame_err=%0d ",tr.rx_data, tr.rx_valid, tr.parity_error, tr.frame_error),UVM_LOW)
            wait_cycles(vif.baud_rate);
            tr.parity_en    = vif.parity_en;
            tr.rx_valid     = vif.rx_valid;
            tr.parity_error = vif.parity_error;
            tr.frame_error  = vif.frame_error;
            tr.baud_rate    = vif.baud_rate;

            `uvm_info(get_type_name(),"Monitor is completed...",UVM_LOW)

            mon_ap.write(tr);
        end
    endtask
endclass
