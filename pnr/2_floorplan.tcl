floorPlan -site CoreSite \
          -r 1.0 0.65 \
          30 30 30 30

checkFPlan
checkDesign -physical -outDir ../reports/checkDesign_physical
saveDesign ../outputs/2_floorplan.enc

puts "\n\[DONE\] Floorplan complete."
