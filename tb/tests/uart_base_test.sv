//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_base_test.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 28-12-2025
// Version     : 1.1
// Description : Base UVM test that builds the UART
//               environment, connects components,
//               and prints the testbench topology
//               at end of elaboration.
//=====================================================

class uart_base_test extends uvm_test;
    `uvm_component_utils(uart_base_test)

    uart_env env;      

    function new(string name = "uart_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        env     = uart_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass