##### Variables #####
set origin_dir [file dirname [info script]]
set output_dir $origin_dir/../work
set bd_name design_1

set _xil_proj_name_ "matmul_xcel_zcu102"


##### Create Project #####

set files [glob -nocomplain "$output_dir/$_xil_proj_name_/*"]
if {[llength $files] != 0} {
    puts "deleting old project"
    file delete -force {*}[glob -directory $output_dir/$_xil_proj_name_ *]; # clear folder contents
} else {
    puts "work directory is empty"
}

create_project ${_xil_proj_name_} ${output_dir}/${_xil_proj_name_} -part xczu9eg-ffvb1156-2-e

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part_repo_paths" -value "[file normalize "$origin_dir/2020.2/xhub/board_store/xilinx_board_store"]" -objects $obj
set_property -name "board_part" -value "xilinx.com:zcu102:part0:3.4" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
# set_property -name "ip_output_repo" -value "N:/temp/${_xil_proj_name_}/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "zcu102" -objects $obj
# set_property -name "sim.central_dir" -value "N:/temp/${_xil_proj_name_}/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "VHDL" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "2" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "2" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "2" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "2" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "2" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "2" -objects $obj
set_property -name "webtalk.xcelium_export_sim" -value "1" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "2" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_MEMORY" -objects $obj

##### Add Sources #####

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/../src/hdl/matmul_xcel.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/components/axi_reg_slave.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/components/fwft_fifo.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/components/processing_element.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/components/processing_element_array.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/components/matmul_xcel_regs.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/packages/component_pkg.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/packages/matmul_xcel_Addr_pkg.vhd"] \
 [file normalize "${origin_dir}/../src/hdl/packages/type_pkg.vhd"] 
]
add_files -norecurse -fileset $obj $files


# # Create 'constrs_1' fileset (if not found)
# if {[string equal [get_filesets -quiet constrs_1] ""]} {
#   create_fileset -constrset constrs_1
# }
# # Set 'constrs_1' fileset object
# set obj [get_filesets constrs_1]
# set files [list \
#   [file normalize "${origin_dir}/../src/constraints/constraints.xdc"]
# ]
# add_files -norecurse -fileset $obj $files

##### Create BD #####
source $origin_dir/../src/bd/$bd_name.tcl


# Generate wrapper
# set design_name [get_bd_designs mb_preset*]
make_wrapper -files [get_files $bd_name.bd] -top -import