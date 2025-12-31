//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_parity_error_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.0
// Description : UART UVM sequence/test with parity
//               error injection enabled.
//=====================================================

class uart_parity_error_seq extends uart_sequence;
  `uvm_object_utils(uart_parity_error_seq)
  uart_transaction tr;
  function new (string name = "uart_parity_error_seq");
    super.new(name);
  endfunction
  task body();
    repeat(2)begin
      tr = uart_transaction::type_id::create("tr");
      if (!tr.randomize() with {
            clk_per_bit == 13'd72;
            parity_en == 1'b1;
            parity_error_injection == 1'b1;
          }) begin
        `uvm_error(get_type_name(), "Randomization failed for parity error transaction")
      end
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
  class uart_parity_error_test extends uart_base_test;
    `uvm_component_utils(uart_parity_error_test)
	uart_parity_error_seq parity_err;
    function new(string name = "uart_parity_error_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      parity_err = uart_parity_error_seq::type_id::create("parity_err");
    endfunction
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      parity_err.start(env.m_agent.seqr);
      phase.drop_objection(this);
    endtask
  endclass