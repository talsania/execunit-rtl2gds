set_ccopt_property -use_inverters true
set_ccopt_property buffer_cells   {buffd1 buffd2 buffd3 buffd4}
set_ccopt_property inverter_cells {inv0d0 inv0d1 inv0d2}

create_ccopt_clock_tree_spec -file ../reports/ccopt_spec.tcl

clock_opt_design

set fp [open ../reports/5_cts_skew.rpt w]
puts $fp [report_ccopt_clock_trees]
close $fp

timeDesign -postCTS \
           -pathReports \
           -outDir ../reports/timeDesign_postCTS

timeDesign -postCTS \
           -hold \
           -pathReports \
           -outDir ../reports/timeDesign_postCTS_hold

saveDesign ../outputs/5_cts.enc

puts "\n\[DONE\] CTS complete."
