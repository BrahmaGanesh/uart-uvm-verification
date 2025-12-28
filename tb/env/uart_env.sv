//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_env.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 28-12-2025
// Version     : 1.1
// Description : UART UVM environment with agent, scoreboard, and coverage.
//               Connects monitor analysis ports and reports results.
//=====================================================

class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    uart_agent m_agent;
    uart_scoreboard soc;
    uart_coverage cov;

    int Total;
    int Pass;
    int Fail;

    function new(string name = "uart_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_agent = uart_agent::type_id::create("m_agent", this);
        soc     = uart_scoreboard:: type_id::create("soc", this);
        cov     = uart_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        m_agent.mon.mon_ap.connect(soc.soc_export);
        m_agent.mon.mon_ap.connect(cov.cov_export);
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        Total = soc.total_reads;
        Pass  = soc.matched_reads;
        Fail  = soc.mismatched_reads;
    endfunction

    function void check_phase(uvm_phase phase);
        if(Fail > 0)
            `uvm_error(get_type_name(),$sformatf("Check Failed : %0d Mismatched detected",Fail))
        else
            `uvm_info(get_type_name(),"Check Passed : no Mismatched ",UVM_LOW)
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("Report",$sformatf("Total Reads   : %0d",Total),UVM_LOW)
        `uvm_info("Report",$sformatf("Total PASS    : %0d",Pass),UVM_LOW)
        `uvm_info("Report",$sformatf("Total FAIL    : %0d",Fail),UVM_LOW)
    endfunction

    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("PHASE","Clean up phase.....",UVM_LOW)
    endfunction
    
endclass
