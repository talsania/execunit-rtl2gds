globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *
globalNetConnect VDD -type tiehi -inst *
globalNetConnect VSS -type tielo -inst *

addRing -nets {VDD VSS} \
        -type core_rings \
        -follow core \
        -layer {top M5 bottom M5 left M6 right M6} \
        -width 5.0 \
        -spacing 2.0 \
        -offset 2.0 \
        -center 1

addStripe -nets {VDD VSS} \
          -layer M6 \
          -direction vertical \
          -width 3.0 \
          -spacing 2.0 \
          -set_to_set_distance 70.0 \
          -start_from left

addStripe -nets {VDD VSS} \
          -layer M5 \
          -direction horizontal \
          -width 2.0 \
          -spacing 1.5 \
          -set_to_set_distance 60.0 \
          -start_from bottom

setSrouteMode -viaConnectToShape { ring stripe blockring }

sroute -connect { corePin } \
       -nets { VDD VSS } \
       -layerChangeRange  { M1 M6 } \
       -blockPinTarget    { nearestTarget } \
       -allowJogging 1
add_shape -net VSS -layer M2 -rect {525.4 449.5 528.0 450.0}

verifyConnectivity -type special
saveDesign ../outputs/3_powerplan.enc

puts "\n\[DONE\] Power plan complete."
