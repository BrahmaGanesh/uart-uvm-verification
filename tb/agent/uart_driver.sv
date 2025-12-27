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
        `uvm_info("PHASE", "reset applied...", UVM_LOW)
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
            `uvm_info(get_type_name(),$sformatf("data =%0h data=%0b",tr.tx_data,tr.tx_data[i]),UVM_LOW)
    		vif.tx = tr.tx_data[i];
  		end
    endtask
  
  task run_phase(uvm_phase phase);
    forever begin
    	seq_item_port.get_next_item(tr);
            wait(vif.rst_n);
            vif.baud_rate   <= tr.baud_rate;
      		vif.tx <= 0;
            `uvm_info(get_type_name(),$sformatf("start tx =%0d parity_error=%0b ",vif.tx,vif.parity_error),UVM_LOW)
            
            run();

            if(tr.parity_en)begin
                vif.parity_en <= tr.parity_en;
                tx_counter = 0;
                while (tx_counter < tr.baud_rate) begin
      		        @(posedge vif.clk);
      		        tx_counter++;
    		    end
    		    vif.tx <= ^tr.tx_data;
                `uvm_info(get_type_name(),$sformatf("parity tx =%0d parity_error=%0b ",vif.tx,vif.parity_error),UVM_LOW)
            end
    		
            tx_counter = 0;
            while (tx_counter < tr.baud_rate) begin
      		    @(posedge vif.clk);
      		    tx_counter++;
    		end
    		vif.tx <= 1;
            repeat(12)begin
            tx_counter = 0;
                while (tx_counter < tr.baud_rate) begin
      		        @(posedge vif.clk);
      		        tx_counter++;
    		    end
            end

            `uvm_info(get_type_name(),$sformatf("stop tx =%0d parity_error=%0b rx_valid=%0b frameerror=%0b ",vif.tx,vif.parity_error,vif.rx_valid,vif.frame_error),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("data =%0h  data=%0h",tr.tx_data,tr.tx_data),UVM_LOW)
    	seq_item_port.item_done();
    end
  endtask
endclass