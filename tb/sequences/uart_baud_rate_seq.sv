//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_baud_rate_seq.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 31-12-2025
// Version     : 1.1
// Description : UART UVM sequence/test that generates
//               transactions at multiple baud rates
//               (9600, 10102, 115200) for validation.
//=====================================================

class uart_baud_rate_seq extends uart_sequence;
    `uvm_object_utils(uart_baud_rate_seq)
    
    uart_transaction tr;
    
  	localparam int CLK_PERIOD_NS = 120;
    localparam int CLK_FREQ_HZ   = 1_000_000_000 / CLK_PERIOD_NS;
    int unsigned baud_list[] = '{9600, 10102, 115200};
    int unsigned data_list[] = '{8'h00, 8'hFF, 8'h05, 8'h40, 8'h90};


    function new(string name="uart_baud_rate_seq");
        super.new(name);
    endfunction

    virtual task body();
        foreach(baud_list[i])begin
            foreach (data_list[j]) begin
                tr = uart_transaction::type_id::create($sformatf("tr_baud_%0d_data_%0h", baud_list[i], data_list[j]));
                assert(tr.randomize() with { baud_rate == baud_list[i]; tx_data == data_list[j]; });
                tr.clk_per_bit = CLK_FREQ_HZ / tr.baud_rate;
                tr.frame_error_injection = 1'b0;
                start_item(tr);
                finish_item(tr);
            end
        end
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
