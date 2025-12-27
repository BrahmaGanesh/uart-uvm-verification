module uart_slave#(
    parameter CLK_PER_BIT = 7812,
    parameter USE_PARITY  = 1
)(
    input   logic clk,
    input   logic rst_n,
    input   logic rx,
    output  logic tx,
    output logic rx_valid,
    output logic frame_error,
    output logic parity_error
);

    typedef enum {IDEL, START, DATA, PARITY, STOP} state_n;
    state_n uart_rx, uart_tx;

    logic [$clog2(CLK_PER_BIT):0] rx_counter;
    logic [$clog2(CLK_PER_BIT):0] tx_counter;
    logic [2:0] rx_bit_counter;
    logic [2:0] tx_bit_counter;
    logic [7:0] rx_data;
    logic [7:0] tx_data;

    logic rx_ready;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            uart_rx <= IDEL;
            rx_counter <= 0;
            rx_bit_counter <= 0;
            rx_valid <= 0;
            frame_error <= 0;
            parity_error <= 0;
            rx_ready <= 0;
        end
        else begin
        rx_ready <= (uart_rx == STOP && rx && rx_counter == CLK_PER_BIT-1);
            case(uart_rx)
                IDEL    :   begin
                                rx_counter <= 0;
                                rx_bit_counter <= 0;
                                frame_error <= 0;
                                parity_error <= 0;
                                if(rx == 0)begin
                                    rx_valid <= 0;
                                    uart_rx <= START;
                                end
                            end
                START   :   begin
                                if(rx_counter == (CLK_PER_BIT / 2))begin
                                    rx_counter <= 0;
                                    if(!rx)
                                        uart_rx <= DATA;
                                    else
                                        uart_rx <= IDEL;
                                end
                                else
                                    rx_counter++;
                            end
                DATA    :   begin
                                if(rx_counter == (CLK_PER_BIT - 1)) begin
                                    rx_counter <= 0;
                                    rx_data[rx_bit_counter] <= rx;
                                    rx_bit_counter++;
                                    uart_rx <= DATA;
                                    if(rx_bit_counter == 3'd7)begin
                                        rx_bit_counter <= 0;
                                        uart_rx <= (USE_PARITY ? PARITY : STOP);
                                    end
                                end
                                else
                                    rx_counter++;
                            end
                PARITY  :   begin
                                if(rx_counter == (CLK_PER_BIT- 1)) begin
                                    rx_counter <= 0;
                                    if(rx != ^rx_data)
                                        parity_error <= 1;
                                    else
                                        parity_error <= 0;
                                    uart_rx <= STOP;
                                end
                                else
                                    rx_counter++;
                            end
                STOP    :   begin
                                if(rx_counter == (CLK_PER_BIT -1))begin
                                    rx_counter <= 0;
                                    if(rx)begin
                                        frame_error <= 0;
                                        rx_valid <= 1;
                                        uart_rx <= IDEL;
                                    end
                                    else begin
                                        frame_error <= 1;
                                        rx_valid <= 0;
                                        uart_rx <= IDEL;
                                    end
                                end
                                else begin
                                    rx_counter++;
                                end
                            end
            endcase
            end
        end
        always_ff @(posedge clk or negedge rst_n) begin
            if(!rst_n)begin
                uart_tx <= IDEL;
                tx_counter <= 0;
                tx_bit_counter <= 0;
                tx <= 1'b1;
            end
            else begin
                if(rx_ready && uart_tx == IDEL)begin
                    tx_data <= rx_data;
                    uart_tx <= START;
                end
                case(uart_tx)
                    START   :   begin
                                    if(tx_counter == (CLK_PER_BIT-1)) begin
                                        tx_counter <= 0;
                                        tx <= 0;
                                        uart_tx <= DATA;
                                    end
                                    else
                                        tx_counter++;
                                end 
                    DATA    :   begin
                                    if(tx_counter == (CLK_PER_BIT - 1)) begin
                                        tx_counter <= 0;    
                                        tx <= tx_data[tx_bit_counter];
                                        tx_bit_counter++;
                                        if(tx_bit_counter == 3'd7)begin
                                            tx_bit_counter<=0;
                                            uart_tx <= (USE_PARITY ? PARITY : STOP);
                                        end
                                    end
                                    else
                                        tx_counter++;
                                end
                    PARITY  :   begin
                                   if(tx_counter == (CLK_PER_BIT - 1)) begin
                                        tx_counter <= 0;
                                        tx <= ^tx_data;
                                        uart_tx <= STOP;
                                    end
                                    else
                                        tx_counter++;
                                end
                    STOP    :   begin
                                    if(tx_counter == (CLK_PER_BIT - 1)) begin
                                        tx_counter <= 0;
                                        tx <= 1'b1;
                                        uart_tx <= IDEL;
                                    end
                                    else
                                        tx_counter++;
                                end
                endcase
            end
        end
endmodule
                            


