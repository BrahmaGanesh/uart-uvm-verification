//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_driver.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 27-12-2025
// Version     : 1.1
// Description : UVM driver for UART transactions,
//               drives stimulus to DUT via interface
//               with start, data, parity, and stop bits.
//=====================================================

class uart_driver extends uvm_driver #(uart_transaction);
    `uvm_component_utils(uart_driver)
  
    virtual uart_interface vif;
    uart_transaction tr;
    logic [12:0] tx_counter;
    
    function new(string name = "uart_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_interface)::get(this,"","vif",vif))
            `uvm_fatal(get_type_name(),"virtual interface not set")
    endfunction

     function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_top.set_report_verbosity_level(UVM_LOW);
        `uvm_info(get_type_name(), "Start of Simulation...", UVM_LOW)
    endfunction
      
    task pre_reset_phase(uvm_phase phase);
        super.pre_reset_phase(phase);
         `uvm_info("PHASE", "Preparing reset...", UVM_LOW)
    endtask
    
    task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this, "driver reset");
        vif.rst_n <= 0;
        #200;
        vif.rst_n <= 1;
        `uvm_info("PHASE", "Reset applied...", UVM_LOW)
        phase.drop_objection(this, "driver reset");
    endtask
    task post_reset_phase(uvm_phase phase);
        super.post_reset_phase(phase);
         `uvm_info("PHASE", "Reset Completed...", UVM_LOW)
    endtask

    task run();
        for (int i = 0; i < 8; i++) begin
   			tx_counter = 0;
        	while (tx_counter < tr.baud_rate) begin
      			@(posedge vif.clk);
      			tx_counter++;
    		end
            `uvm_info(get_type_name(),$sformatf("DATA SENDING data =%0h tx=%0b",tr.tx_data,tr.tx_data[i]),UVM_LOW)
    		vif.tx = tr.tx_data[i];
  		end
    endtask
  
  task run_phase(uvm_phase phase);
    forever begin
    	seq_item_port.get_next_item(tr);
            wait(vif.rst_n);
            vif.tx_data     <= tr.tx_data;
            vif.baud_rate   <= tr.baud_rate;
      		vif.tx <= 0;
            `uvm_info(get_type_name(),$sformatf("START DATA SEND tx =%0d",vif.tx),UVM_LOW)
            
            run();

            if(tr.parity_en)begin
                vif.parity_en <= tr.parity_en;
                tx_counter = 0;
                while (tx_counter < tr.baud_rate) begin
      		        @(posedge vif.clk);
      		        tx_counter++;
    		    end
    		    vif.tx <= ^tr.tx_data;
                `uvm_info(get_type_name(),$sformatf("PARITY DATA SEND tx =%0d",vif.tx),UVM_LOW)
            end
    		
            tx_counter = 0;
            while (tx_counter < tr.baud_rate) begin
      		    @(posedge vif.clk);
      		    tx_counter++;
    		end
    		vif.tx <= 1;
             `uvm_info(get_type_name(),$sformatf("STOP DATA SEND tx =%0d",vif.tx),UVM_LOW)

            repeat(12)begin
            tx_counter = 0;
                while (tx_counter < tr.baud_rate) begin
      		        @(posedge vif.clk);
      		        tx_counter++;
    		    end
            end

    	seq_item_port.item_done();
    end
  endtask
endclass