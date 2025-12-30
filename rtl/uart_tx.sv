//=====================================================
// Project     : UART_UVM_VERIFICATION
// File        : uart_tx.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 30-12-2025
// Version     : 1.1
// Description : FSM-based UART transmitter with optional
//               parity generation and stop bit handling.
//=====================================================

module uart_tx (
    input   logic clk,
    input   logic rst_n,
    input   logic parity_en,
    input   logic rx_valid,
    input   logic [7:0] rx_data,
    input   logic [12:0] clk_per_bit,
    output  logic tx,
    output  logic tx_valid
);

    typedef enum {IDLE, START, DATA, PARITY, STOP} state_n;
    state_n state;

    logic [12:0] tx_clk_cnt;
    logic [2:0] tx_bit_idx;
    logic [7:0] tx_data;
    logic   tx_req;
    logic   tx_parity;

    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            state   <= IDLE;
            tx      <= 1;
            tx_clk_cnt <= '0;
            tx_bit_idx <= '0;
            tx_data <= '0;
            tx_parity <= 0;
            tx_valid <= 0;
            tx_req <= 0;
        end
        else begin
            if(rx_valid) begin
                tx_data <= rx_data;
                tx_req <= 1;
            end
            case(state)
                IDLE    :   begin
                                tx_clk_cnt <= 0;
                                tx_bit_idx <= '0;
                                tx_parity <= 0;
                                tx_valid <= 0;
                                if(tx_req)begin
                                    state <=START;
                                end
                            end
                START   :   begin
                                if(tx_clk_cnt == (clk_per_bit - 1)) begin
                                    tx_clk_cnt <= 0;
                                    tx <= 0;
                                    state <= DATA;
                                end
                                else
                                    tx_clk_cnt++;
                            end
                DATA    :   begin
                                if(tx_clk_cnt == (clk_per_bit - 1)) begin
                                    tx_clk_cnt <= 0;
                                    tx <= tx_data[tx_bit_idx];
                                    if(tx_bit_idx == 3'd7) begin
                                        tx_bit_idx <= 0;
                                        tx_parity <= ^tx_data;
                                        state <= parity_en ? PARITY : STOP;
                                    end
                                    else
                                        tx_bit_idx++;
                                end
                                else
                                    tx_clk_cnt++;
                            end
                PARITY  :   begin
                                if(tx_clk_cnt == (clk_per_bit -1)) begin
                                    tx_clk_cnt <= 0;
                                    tx <= tx_parity;
                                    state <= STOP;
                                end
                                else
                                    tx_clk_cnt++;
                            end
                STOP    :   begin
                                if(tx_clk_cnt == (clk_per_bit - 1)) begin
                                    tx_clk_cnt <= '0;
                                    tx <= 1;
                                    state <= IDLE;
                                    tx_valid    <= 1;
                                    tx_req <= 0;
                                end
                                else
                                    tx_clk_cnt++;
                            end
            endcase
        end
    end
endmodule