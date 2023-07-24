# Config
set projName matmul_xcel_zcu102
set bdName mb_preset
set design_name $projName
# set build_dir "kcu105"

# From StackOverflow
# https://support.xilinx.com/s/article/66966?language=en_US

proc numberOfCPUs {} {
    # Windows puts it in an environment variable
    global tcl_platform env
    if {$tcl_platform(platform) eq "windows"} {
        return $env(NUMBER_OF_PROCESSORS)
    }

    # Check for sysctl (OSX, BSD)
    set sysctl [auto_execok "sysctl"]
    if {[llength $sysctl]} {
        if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
            return $cores
        }
    }

    # Assume Linux, which has /proc/cpuinfo, but be careful
    if {![catch {open "/proc/cpuinfo"} f]} {
        set cores [regexp -all -line {^processor\s} [read $f]]
        close $f
        if {$cores > 0} {
            return $cores
        }
    }

    # No idea what the actual number of cores is; exhausted all our options
    # Fall back to returning 1; there must be at least that because we're running on it!
    return 1
}

# Open project and block design
open_project work/$projName/$projName.xpr
open_bd_design work/$projName/$projName.srcs/sources_1/bd/$bdName/$bdName.bd


# Set synthesis and implementation strategies
#set_property strategy "Flow_AlternateRoutability" [get_runs synth_1]
#set_property strategy "Performance_Retiming" [get_runs impl_1]
set_property strategy "Performance_ExtraTimingOpt" [get_runs impl_1]

# Run Synthesis + Implementation
reset_runs impl_1
launch_runs impl_1 -to_step write_bitstream -jobs [numberOfCPUs]
wait_on_run impl_1

# Generate XSA and bitstream
write_hw_platform -fixed -force -include_bit -file builds/${designName}.xsa
validate_hw_platform builds/${designName}.xsa
file copy -force work/$projName/$projName.runs/impl_1/${bdName}_wrapper.bit builds/${designName}.bit
file copy -force work/$projName/$projName.runs/impl_1/${bdName}_wrapper.ltx builds/${designName}.ltx

#set designNameNoBit ${designName}_nobit
#write_hw_platform -fixed -force -file bin/${designNameNoBit}.xsa
#validate_hw_platform bin/${designNameNoBit}.xsa

set impl_status [get_property STATUS [get_runs impl_1] ]
set synth_status [get_property STATUS [get_runs synth_1] ]
puts "  INFO: Implementation status was $impl_status"
puts "  INFO: Synthesis status was $synth_status"
puts "  INFO: Outputs written to builds/$designName"