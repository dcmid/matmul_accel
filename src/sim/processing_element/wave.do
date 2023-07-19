onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processing_element_tb/period
add wave -noupdate /processing_element_tb/BIT_WIDTH
add wave -noupdate /processing_element_tb/clk
add wave -noupdate /processing_element_tb/rst
add wave -noupdate /processing_element_tb/part_prod_recv
add wave -noupdate /processing_element_tb/part_prod_recv_val
add wave -noupdate /processing_element_tb/part_prod_recv_rdy
add wave -noupdate /processing_element_tb/msg_recv
add wave -noupdate /processing_element_tb/msg_recv_val
add wave -noupdate /processing_element_tb/msg_recv_rdy
add wave -noupdate /processing_element_tb/part_prod_send
add wave -noupdate /processing_element_tb/part_prod_send_val
add wave -noupdate /processing_element_tb/part_prod_send_rdy
add wave -noupdate /processing_element_tb/msg_send
add wave -noupdate /processing_element_tb/msg_send_val
add wave -noupdate /processing_element_tb/msg_send_rdy
add wave -noupdate /processing_element_tb/stim_weights
add wave -noupdate /processing_element_tb/stim_activations
add wave -noupdate /processing_element_tb/stim_part_prod
add wave -noupdate /processing_element_tb/expected
add wave -noupdate /processing_element_tb/i
add wave -noupdate -expand -group uut /processing_element_tb/uut/BIT_WIDTH
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_part_prod_recv
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_part_prod_recv_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_part_prod_recv_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_msg_recv
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_msg_recv_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_msg_recv_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_part_prod_send
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_part_prod_send_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_part_prod_send_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_msg_send
add wave -noupdate -expand -group uut /processing_element_tb/uut/o_msg_send_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_msg_send_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_clk
add wave -noupdate -expand -group uut /processing_element_tb/uut/i_rst
add wave -noupdate -expand -group uut /processing_element_tb/uut/part_prod_recv
add wave -noupdate -expand -group uut /processing_element_tb/uut/part_prod_recv_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/part_prod_recv_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/msg_recv
add wave -noupdate -expand -group uut /processing_element_tb/uut/msg_recv_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/msg_recv_rdy
add wave -noupdate -expand -group uut /processing_element_tb/uut/msg_send
add wave -noupdate -expand -group uut /processing_element_tb/uut/weight
add wave -noupdate -expand -group uut /processing_element_tb/uut/weight_full
add wave -noupdate -expand -group uut /processing_element_tb/uut/activation
add wave -noupdate -expand -group uut /processing_element_tb/uut/inputs_val
add wave -noupdate -expand -group uut /processing_element_tb/uut/outputs_rdy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 320
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {402 ps}
