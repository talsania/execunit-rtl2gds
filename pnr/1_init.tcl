set DESIGN   "riscv_top"
set NETLIST  "../synth/outputs/riscv_top_netlist.v"
set SDC_FILE "../synth/outputs/riscv_top_synth.sdc"

set PDK_ROOT "/pdk/SCLPDK_V3.0_KIT/scl180"
set SC_ROOT  "$PDK_ROOT/stdcell/fs120/6M1L"

set LIB_SS "$SC_ROOT/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib"
set LIB_FF "$SC_ROOT/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib"

set TECH_LEF "$SC_ROOT/lef/scl18fs120_tech.lef"
set STD_LEF  "$SC_ROOT/lef/scl18fs120_std.lef"

file mkdir "./outputs"
file mkdir "./reports"

create_library_set -name WC_LIB -timing [list $LIB_SS]
create_library_set -name BC_LIB -timing [list $LIB_FF]
create_rc_corner -name Cmax -T 125
create_rc_corner -name Cmin -T -40
create_delay_corner -name WC_CORNER -library_set WC_LIB -rc_corner Cmax
create_delay_corner -name BC_CORNER -library_set BC_LIB -rc_corner Cmin
create_constraint_mode -name CON -sdc_files [list $SDC_FILE]
create_analysis_view -name WC_VIEW -delay_corner WC_CORNER -constraint_mode CON
create_analysis_view -name BC_VIEW -delay_corner BC_CORNER -constraint_mode CON

set init_verilog            $NETLIST
set init_design_netlisttype "Verilog"
set init_design_settop      1
set init_top_cell           $DESIGN
set init_lef_file           [list $TECH_LEF $STD_LEF]
set init_pwr_net            "VDD"
set init_gnd_net            "VSS"

init_design -setup {WC_VIEW} -hold {BC_VIEW}

set_interactive_constraint_modes {CON}
setDesignMode -process 180

puts "\n\[DONE\] riscv_top initialized successfully."
puts " Setup view : WC_VIEW (SS / 125°C)"
puts " Hold  view : BC_VIEW (FF / -40°C)"
