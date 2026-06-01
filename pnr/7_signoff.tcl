addFiller -cell {feedth9 feedth3 feedth} -prefix FILLER
checkPlace
saveNetlist ../synth/outputs/counter_routed.v
extractRC
rcOut -spef ../synth/outputs/counter_routed.spef
streamOut ../synth/outputs/counter.gds -units 1000 -mode ALL
