//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_baud_rate_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.0
// Description : UART UVM sequence/test that generates
//               transactions at multiple baud rates
//               (9600, 10102, 115200) for validation.
//=====================================================

class uart_baud_rate_seq extends uart_sequence;
    `uvm_object_utils(uart_baud_rate_seq)
    
    uart_transaction tr;
    
  	localparam int CLK_PERIOD_NS = 120;
    localparam int CLK_FREQ_HZ   = 1_000_000_000 / CLK_PERIOD_NS;


    function new(string name="uart_baud_rate_seq");
        super.new(name);
    endfunction

    virtual task body();
        tr = uart_transaction::type_id::create("tr");
        tr.randomize();
        tr.baud_rate = 17'd9600;
        tr.clk_per_bit = CLK_FREQ_HZ / tr.baud_rate;
        tr.frame_error_injection = 1'b0;
        start_item(tr);
        finish_item(tr);
        tr.randomize();
        tr.baud_rate = 17'd10102;
        tr.clk_per_bit = CLK_FREQ_HZ / tr.baud_rate;
        tr.frame_error_injection = 1'b0;
        start_item(tr);
        finish_item(tr);
        tr.randomize();
        tr.baud_rate = 17'd115200;
        tr.clk_per_bit = CLK_FREQ_HZ / tr.baud_rate;
        tr.frame_error_injection = 1'b0;
        start_item(tr);
        finish_item(tr);
    endtask
endclass


class uart_baud_rate_test extends uart_base_test;
    `uvm_component_utils(uart_baud_rate_test)

    uart_baud_rate_seq baud_t;

    function new(string name = "uart_baud_rate_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        baud_t = uart_baud_rate_seq::type_id::create("baud_t");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        baud_t.start(env.m_agent.seqr);
        phase.drop_objection(this);
    endtask

endclass
