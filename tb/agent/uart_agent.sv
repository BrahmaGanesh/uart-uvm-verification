class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    uart_sequencer  seqr;
    uart_driver     drv;
    uart_monitor    mon;

    function new(string name = "uart_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function void build-phase(uvm_phase phase);
        super.build_phase(phase);

        seqr    = uart_sequencer::type_id::create("seqr", this);
        drv     = uart_driver::type_id::create("drv", this);
        mon     = uart_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass