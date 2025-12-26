//=====================================================
// Project     : UART_UVM_VERFICATION
// File        : uart_rx.sv
// Author      : Brahma Ganesh Katrapalli
// Date        : 25-12-2025
// Version     : 1.0
// Description : FSM-based UART receiver with parity and
//               frame error detection.
//=====================================================

module uart_rx#(
    parameter   CLK_PER_BIT = 5208
)(
    input   logic clk,
    input   logic rst_n,
    input   logic rx,
    input   logic parity_en,
    output  logic [7:0] rx_data,
    output  logic rx_valid, 
    output  logic parity_error,
    output  logic frame_error
);

    typedef enum {IDLE, START, DATA, PARITY, STOP} state_n;
    state_n state;

    logic [$clog2(CLK_PER_BIT) -1 : 0] rx_clk_cnt;
    logic [2:0] rx_bit_idx;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state           <= IDLE;
            rx_clk_cnt      <= '0;
            rx_bit_idx      <= '0;
            rx_valid        <= 0;
            rx_data         <= '0;
            parity_error    <= 0;
            frame_error     <= 0;
        end
        else begin
            case(state)
                IDLE    :   begin
                                rx_clk_cnt <= '0;
                                rx_bit_idx <= '0;
                                parity_error <= 0;
                                frame_error  <= 0;
                                rx_valid    <= 0;
                                if(rx == 0) begin
                                    state <= START;
                                end
                            end
                START   :   begin
                                if(rx_clk_cnt == (CLK_PER_BIT / 2)) begin
                                    rx_clk_cnt  <= '0;
                                    if(rx == 0)
                                        state <= DATA;
                                    else
                                        state <= IDLE;
                                end
                                else
                                    rx_clk_cnt++;
                            end
                DATA    :   begin
                                if(rx_clk_cnt == (CLK_PER_BIT - 1)) begin
                                    rx_clk_cnt  <= '0;
                                    rx_data[rx_bit_idx] <= rx;
                                    if(rx_bit_idx == 3'd7)begin
                                        state   <= parity_en ? PARITY : STOP;
                                        rx_bit_idx  <= '0;
                                    end
                                    else
                                        state   <= DATA;
                                    rx_bit_idx++;
                                end
                                else
                                    rx_clk_cnt++;
                            end
                PARITY  :   begin
                                if(rx_clk_cnt == (CLK_PER_BIT - 1)) begin
                                    rx_clk_cnt  <= '0;
                                    if(rx != ^rx_data)
                                        parity_error    <= 1;

                                    state   <= STOP;
                                end
                                else
                                    rx_clk_cnt++;
                            end
                STOP    :   begin
                                if(rx_clk_cnt == (CLK_PER_BIT - 1))begin
                                    rx_clk_cnt  <= '0;
                                    if(rx == 1)begin
                                        rx_valid    <= 1;
                                    end
                                    else 
                                        frame_error <= 1;
                                    state   <= IDLE;
                                end
                                else
                                    rx_clk_cnt++;
                            end
            endcase                          
        end
    end


endmodule