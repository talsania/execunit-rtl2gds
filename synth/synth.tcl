set DESIGN riscv_top
set OUT_DIR outputs
set REP_DIR reports

file mkdir $OUT_DIR
file mkdir $REP_DIR

set PDK_ROOT /pdk/SCLPDK_V3.0_KIT/scl180
set SC_ROOT  $PDK_ROOT/stdcell/fs120/6M1L
set MEM_ROOT $PDK_ROOT/memory/spram/4M1L

set RTL_DIR [file normalize [file join [file dirname [info script]] ..]]

set_db library [list \
    $SC_ROOT/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib \
    $MEM_ROOT/SPRAM_2048x36/SPRAM_2048x36_max_SP.lib   \
    $MEM_ROOT/SPRAM_8192x36/SPRAM_8192x36_max_SP.lib   \
]

set_db lef_library [list \
    $SC_ROOT/lef/scl18fs120_tech.lef                   \
    $SC_ROOT/lef/scl18fs120_std.lef                    \
    $MEM_ROOT/SPRAM_2048x36/SPRAM_2048x36.lef          \
    $MEM_ROOT/SPRAM_8192x36/SPRAM_8192x36.lef          \
]

read_hdl -language v2001 [list \
    $RTL_DIR/rtl/riscv_alu.v            \
    $RTL_DIR/rtl/riscv_regfile.v        \
    $RTL_DIR/rtl/riscv_top.v            \
]

elaborate $DESIGN

check_design -unresolved
check_design -all

create_clock -name clk -period 50.0 [get_ports clk_i]

set_input_delay 2.0 -clock clk \
    [remove_from_collection [all_inputs] [get_ports clk_i]]

set_output_delay 2.0 -clock clk [all_outputs]

set_load 0.05 [all_outputs]

check_timing_intent

set_db syn_generic_effort medium
set_db syn_map_effort     medium
set_db syn_opt_effort     medium

syn_generic
syn_map
syn_opt

report_timing > $REP_DIR/timing.rpt
report_area   > $REP_DIR/area.rpt
report_power  > $REP_DIR/power.rpt
report_qor    > $REP_DIR/qor.rpt

write_hdl > $OUT_DIR/${DESIGN}_netlist.v
write_sdf > $OUT_DIR/${DESIGN}.sdf
write_sdc > $OUT_DIR/${DESIGN}_synth.sdc
write_db    $OUT_DIR/${DESIGN}_genus.db

puts "\n\[DONE\] Synthesis complete."
puts " Netlist : $OUT_DIR/${DESIGN}_netlist.v"
puts " Reports : $REP_DIR/"
