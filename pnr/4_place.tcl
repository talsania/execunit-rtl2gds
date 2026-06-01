setPinAssignMode -pinEditInBatch true

set alu_pins  [dbGet [dbGet -p top.terms.name *alu*].name]
set dbg_pins  [dbGet [dbGet -p top.terms.name *dbg*].name]

set all_pins  [dbGet top.terms.name]
set ctrl_pins {}

foreach pin $all_pins {
    if {![string match "*alu*" $pin] && ![string match "*dbg*" $pin]} {
        lappend ctrl_pins $pin
    }
}

if {[llength $alu_pins] > 0} {
    editPin -side Top -layer M3 -spreadType SIDE -pin $alu_pins
}

if {[llength $dbg_pins] > 0} {
    editPin -side Bottom -layer M3 -spreadType SIDE -pin $dbg_pins
}

if {[llength $ctrl_pins] > 0} {
    editPin -side Left -layer M3 -spreadType SIDE -pin $ctrl_pins
}

setPinAssignMode -pinEditInBatch false

setPlaceMode -timingDriven               true \
             -place_global_place_io_pins false

setOptMode -fixCap        true \
           -fixTran        true \
           -fixFanoutLoad  true \
           -effort         high

place_opt_design

optDesign -preCTS -outDir ../reports/optDesign_preCTS

sroute -connect { corePin blockPin } \
       -nets { VDD VSS } \
       -corePinTarget          { firstAfterRowEnd } \
       -blockPinTarget         { nearestTarget } \
       -allowJogging            1 \
       -allowLayerChange        1 \
       -layerChangeRange        { M1 M6 } \
       -crossoverViaLayerRange  { M1 M6 }

verifyConnectivity -type special \
                   -report ../reports/verify_place_pdn.rpt

checkPlace ../reports/check_place.rpt

timeDesign -preCTS \
           -pathReports \
           -outDir ../reports/timeDesign_preCTS

saveDesign ../outputs/4_placement.enc

puts "\n\[DONE\] Placement complete."
