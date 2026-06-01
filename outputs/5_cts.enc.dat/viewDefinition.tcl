if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name WC_LIB\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ss.lib]
create_library_set -name BC_LIB\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ff.lib]
create_rc_corner -name Cmin\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T -40
create_rc_corner -name Cmax\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125
create_delay_corner -name BC_CORNER\
   -library_set BC_LIB\
   -rc_corner Cmin
create_delay_corner -name WC_CORNER\
   -library_set WC_LIB\
   -rc_corner Cmax
create_constraint_mode -name CON\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CON/CON.sdc]
create_analysis_view -name WC_VIEW -constraint_mode CON -delay_corner WC_CORNER -latency_file ${::IMEX::dataVar}/mmmc/views/WC_VIEW/latency.sdc
create_analysis_view -name BC_VIEW -constraint_mode CON -delay_corner BC_CORNER -latency_file ${::IMEX::dataVar}/mmmc/views/BC_VIEW/latency.sdc
set_analysis_view -setup [list WC_VIEW] -hold [list BC_VIEW]
catch {set_interactive_constraint_mode [list CON] } 
