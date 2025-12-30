//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_virtual_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.0
// Description : UART UVM virtual sequence/test that runs
//               multiple sub-sequences including parity,
//               frame error, back-to-back, repeat10, and
//               baud rate validation.
//=====================================================

class uart_virtual_seq extends uart_sequence;
    `uvm_object_utils(uart_virtual_seq)
    
    uart_transaction tr;
    
    uart_parity_error_seq   parity_err;
    uart_frame_error_seq    frame_err;
    uart_back_to_back_seq   b_n;
    uart_repeat10_seq       repeat_t;
    uart_baud_rate_seq      baud_t;
    
    function new (string name = "uart_virtual_seq");
        super.new(name);
    endfunction
    task body();
        parity_err  = uart_parity_error_seq::type_id::create("parity_err");
        frame_err   = uart_frame_error_seq::type_id::create("frame_err");
        b_n         = uart_back_to_back_seq::type_id::create("b_n");
        repeat_t    = uart_repeat10_seq::type_id::create("repeat_t");
        baud_t      = uart_baud_rate_seq::type_id::create("baud_t");
        
        parity_err.start(m_sequencer);
        frame_err.start(m_sequencer);
        b_n.start(m_sequencer);
        repeat_t.start(m_sequencer);
        baud_t.start(m_sequencer);
    
    endtask
endclass

class uart_virtual_test extends uart_base_test;
    `uvm_component_utils(uart_virtual_test)
	uart_virtual_seq b_n;
    
    function new(string name = "uart_virtual_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      b_n = uart_virtual_seq::type_id::create("b_n");
    endfunction
    
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      b_n.start(env.m_agent.seqr);
      phase.drop_objection(this);
    endtask

endclass