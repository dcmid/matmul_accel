onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/period
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/BIT_WIDTH
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/NUM_ROWS
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/NUM_COLS
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/clk
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/rst
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_msg
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_val
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_rdy
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_msg
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_val
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_rdy
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/test_weights
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/test_rdy
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/test_msg
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/test_val
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/period
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/BIT_WIDTH
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/NUM_ROWS
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/NUM_COLS
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/clk
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/rst
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_msg
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_val
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/msg_recv_rdy
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_msg
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_val
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/prod_send_rdy
add wave -noupdate -expand -group TB_TOP /processing_element_array_tb/output_counts
add wave -noupdate -expand -group TB_TOP -color Magenta -expand -subitemconfig {{/processing_element_array_tb/test_activations[0]} {-color Magenta} {/processing_element_array_tb/test_activations[1]} {-color Magenta}} /processing_element_array_tb/test_activations
add wave -noupdate -expand -group TB_TOP -color Magenta -expand -subitemconfig {{/processing_element_array_tb/test_weights[0]} {-color Magenta} {/processing_element_array_tb/test_weights[1]} {-color Magenta}} /processing_element_array_tb/test_weights
add wave -noupdate -expand -group TB_TOP -color Magenta -expand -subitemconfig {{/processing_element_array_tb/output_array[0]} {-color Magenta} {/processing_element_array_tb/output_array[1]} {-color Magenta}} /processing_element_array_tb/output_array
add wave -noupdate -group UUT /processing_element_array_tb/uut/NUM_ROWS
add wave -noupdate -group UUT /processing_element_array_tb/uut/NUM_COLS
add wave -noupdate -group UUT /processing_element_array_tb/uut/BIT_WIDTH
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_msg_recv_msg
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_msg_recv_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_msg_recv_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_prod_send_msg
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_prod_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_prod_send_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_clk
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_rst
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_recv
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_recv_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_recv_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_recv
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_recv_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_recv_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_send
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_send_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_send
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_send_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/NUM_ROWS
add wave -noupdate -group UUT /processing_element_array_tb/uut/NUM_COLS
add wave -noupdate -group UUT /processing_element_array_tb/uut/BIT_WIDTH
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_msg_recv_msg
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_msg_recv_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_msg_recv_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_prod_send_msg
add wave -noupdate -group UUT /processing_element_array_tb/uut/o_prod_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_prod_send_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_clk
add wave -noupdate -group UUT /processing_element_array_tb/uut/i_rst
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_recv
add wave -noupdate -group UUT -radix binary -childformat {{/processing_element_array_tb/uut/part_prod_recv_val(1) -radix binary} {/processing_element_array_tb/uut/part_prod_recv_val(0) -radix binary}} -expand -subitemconfig {/processing_element_array_tb/uut/part_prod_recv_val(1) {-height 15 -radix binary} /processing_element_array_tb/uut/part_prod_recv_val(0) {-height 15 -radix binary}} /processing_element_array_tb/uut/part_prod_recv_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_recv_rdy
add wave -noupdate -group UUT -expand /processing_element_array_tb/uut/msg_recv
add wave -noupdate -group UUT -radix binary -childformat {{/processing_element_array_tb/uut/msg_recv_val(1) -radix binary} {/processing_element_array_tb/uut/msg_recv_val(0) -radix binary}} -expand -subitemconfig {/processing_element_array_tb/uut/msg_recv_val(1) {-height 15 -radix binary} /processing_element_array_tb/uut/msg_recv_val(0) {-height 15 -radix binary}} /processing_element_array_tb/uut/msg_recv_val
add wave -noupdate -group UUT -radix binary -childformat {{/processing_element_array_tb/uut/msg_recv_rdy(1) -radix binary} {/processing_element_array_tb/uut/msg_recv_rdy(0) -radix binary}} -expand -subitemconfig {/processing_element_array_tb/uut/msg_recv_rdy(1) {-height 15 -radix binary} /processing_element_array_tb/uut/msg_recv_rdy(0) {-height 15 -radix binary}} /processing_element_array_tb/uut/msg_recv_rdy
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_send
add wave -noupdate -group UUT -radix binary -childformat {{/processing_element_array_tb/uut/part_prod_send_val(1) -radix binary} {/processing_element_array_tb/uut/part_prod_send_val(0) -radix binary}} -expand -subitemconfig {/processing_element_array_tb/uut/part_prod_send_val(1) {-height 15 -radix binary} /processing_element_array_tb/uut/part_prod_send_val(0) {-height 15 -radix binary}} /processing_element_array_tb/uut/part_prod_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/part_prod_send_rdy
add wave -noupdate -group UUT -expand /processing_element_array_tb/uut/msg_send
add wave -noupdate -group UUT -radix binary -childformat {{/processing_element_array_tb/uut/msg_send_val(1) -radix binary} {/processing_element_array_tb/uut/msg_send_val(0) -radix binary}} -expand -subitemconfig {/processing_element_array_tb/uut/msg_send_val(1) {-height 15 -radix binary} /processing_element_array_tb/uut/msg_send_val(0) {-height 15 -radix binary}} /processing_element_array_tb/uut/msg_send_val
add wave -noupdate -group UUT /processing_element_array_tb/uut/msg_send_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_part_prod_recv
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_part_prod_recv_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_part_prod_recv_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_msg_recv
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_msg_recv_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_msg_recv_rdy
add wave -noupdate -group PE(0,0) -color Orange /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_part_prod_send
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_part_prod_send_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_part_prod_send_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_msg_send
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/o_msg_send_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_msg_send_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_clk
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/i_rst
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/part_prod_recv
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/part_prod_recv_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/part_prod_recv_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_rdy
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_wr_data
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_empty
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_wr_en
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_rd_data
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_full
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_rd_en
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_wr_data
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_empty
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_wr_en
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_rd_data
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_full
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_rd_en
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_send
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/weight
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/weight_full
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/activation
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/inputs_val
add wave -noupdate -group PE(0,0) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/outputs_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/BIT_WIDTH
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_part_prod_recv
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_part_prod_recv_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_part_prod_recv_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_msg_recv
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_msg_recv_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_msg_recv_rdy
add wave -noupdate -group PE(0,1) -color Orange /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_part_prod_send
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_part_prod_send_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_part_prod_send_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_msg_send
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/o_msg_send_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_msg_send_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_clk
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/i_rst
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/part_prod_recv
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/part_prod_recv_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/part_prod_recv_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_rdy
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_wr_data
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_empty
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_wr_en
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_rd_data
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_full
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_rd_en
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_wr_data
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_empty
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_wr_en
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_rd_data
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_full
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_rd_en
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_send
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/weight
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/weight_full
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/activation
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/inputs_val
add wave -noupdate -group PE(0,1) /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/outputs_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/BIT_WIDTH
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_part_prod_recv
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_part_prod_recv_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_part_prod_recv_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_msg_recv
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_msg_recv_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_msg_recv_rdy
add wave -noupdate -group PE(1,0) -color Orange /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_part_prod_send
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_part_prod_send_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_part_prod_send_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_msg_send
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/o_msg_send_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_msg_send_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_clk
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/i_rst
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/part_prod_recv
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/part_prod_recv_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/part_prod_recv_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/msg_recv
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/msg_recv_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/msg_recv_rdy
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_wr_data
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_empty
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_wr_en
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_rd_data
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_full
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_msg_recv_rd_en
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_wr_data
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_empty
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_wr_en
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_rd_data
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_full
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/fifo_part_prod_recv_rd_en
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/msg_send
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/weight
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/weight_full
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/activation
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/inputs_val
add wave -noupdate -group PE(1,0) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(0)/u_processing_element_i/outputs_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/BIT_WIDTH
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_part_prod_recv
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_part_prod_recv_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_part_prod_recv_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_msg_recv
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_msg_recv_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_msg_recv_rdy
add wave -noupdate -group PE(1,1) -color Orange /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_part_prod_send
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_part_prod_send_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_part_prod_send_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_msg_send
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/o_msg_send_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_msg_send_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_clk
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/i_rst
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/part_prod_recv
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/part_prod_recv_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/part_prod_recv_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/msg_recv
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/msg_recv_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/msg_recv_rdy
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_wr_data
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_empty
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_wr_en
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_rd_data
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_full
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_msg_recv_rd_en
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_wr_data
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_empty
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_wr_en
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_rd_data
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_full
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/fifo_part_prod_recv_rd_en
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/msg_send
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/weight
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/weight_full
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/activation
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/inputs_val
add wave -noupdate -group PE(1,1) /processing_element_array_tb/uut/component_gen(1)/nest_component_gen(1)/u_processing_element_i/outputs_rdy
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/BIT_WIDTH
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/DEPTH
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/i_wr_data
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/o_full
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/i_wr_en
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/i_rd_en
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/o_rd_data
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/o_empty
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/i_clk
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/i_rst
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/fifo_array
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/wr_idx
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/rd_idx
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/data_count
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/full
add wave -noupdate -group FIFO /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(1)/u_processing_element_i/msg_recv_fifo/empty
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/BIT_WIDTH
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/DEPTH
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/i_wr_en
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/i_wr_data
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/o_full
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/i_rd_en
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/o_rd_data
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/o_empty
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/i_clk
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/i_rst
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/fifo_array
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/wr_idx
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/rd_idx
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/data_count
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/full
add wave -noupdate -group {FIFO other} /processing_element_array_tb/uut/component_gen(0)/nest_component_gen(0)/u_processing_element_i/msg_recv_fifo/empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {201241 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 746
configure wave -valuecolwidth 222
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {56247 ps} {275988 ps}
