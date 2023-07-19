#set UNISIM_DIR C:/Users/ljthomas/Projects/Modelsim_Lib
# set UNISIM_DIR C:/Users/jtrulear/Documents/Modelsim_Lib
set UNISIM_DIR N:/Modelsim_Lib

set origin_dir [file dirname [info script]]

#cd C:/Users/jtrulear/Git/nav_firmware/nav_signal_gen/sim

vlib unisim
vmap unisim           $UNISIM_DIR/unisim


vlib matmul
vcom -2008 -work matmul     $origin_dir/../../hdl/packages/type_pkg.vhd

vlib work
vlog -work work       $origin_dir/processing_element_tb.sv

vcom -2008 -work work       $origin_dir/../../hdl/components/processing_element.vhd
vcom -2008 -work work       $origin_dir/../../hdl/components/processing_element_array.vhd

vsim -t 1ps -novopt work.processing_element_tb