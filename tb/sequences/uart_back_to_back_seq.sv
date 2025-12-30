//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_back_to_back_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.0
// Description : UART UVM sequence/test for back-to-back
//               transactions with fixed clk_per_bit.
//=====================================================

class uart_back_to_back_seq extends uart_sequence;
  `uvm_object_utils(uart_back_to_back_seq)
  uart_transaction tr;
  function new (string name = "uart_back_to_back_seq");
    super.new(name);
  endfunction
  task body();
      tr = uart_transaction::type_id::create("tr");
      tr.randomize() with {tr.clk_per_bit == 13'd72; frame_error_injection == 1'b0;};
      start_item(tr);
      finish_item(tr);
      tr = uart_transaction::type_id::create("tr");
      tr.randomize() with {tr.clk_per_bit == 13'd72; frame_error_injection == 1'b0;};
      start_item(tr);
      finish_item(tr);
  endtask
endclass
  class uart_back_to_back_test extends uart_base_test;
    `uvm_component_utils(uart_back_to_back_test)
	uart_back_to_back_seq b_n;
    function new(string name = "uart_back_to_back_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      b_n = uart_back_to_back_seq::type_id::create("b_n");
    endfunction
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      b_n.start(env.m_agent.seqr);
      phase.drop_objection(this);
    endtask
  endclass