//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_repeat10_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.0
// Description : UART UVM sequence/test that generates
//               10 back-to-back randomized transactions
//               for repeated operation validation.
//=====================================================

class uart_repeat10_seq extends uart_sequence;
  `uvm_object_utils(uart_repeat10_seq)
  uart_transaction tr;
  function new (string name = "uart_repeat10_seq");
    super.new(name);
  endfunction
  task body();
    for(int i=0;i<10;i++)begin
      tr = uart_transaction::type_id::create("tr");
      assert(tr.randomize())
      else
        `uvm_fatal("ASSERT", $sformatf("Invalid baud_rate=%0d", tr.baud_rate))
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
  class uart_repeat10_test extends uart_base_test;
    `uvm_component_utils(uart_repeat10_test)
    uart_repeat10_seq repeat_t;
    function new(string name = "uart_repeat10_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      repeat_t = uart_repeat10_seq::type_id::create("repeat_t");
    endfunction
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      repeat_t.start(env.m_agent.seqr);
      phase.drop_objection(this);
    endtask
  endclass