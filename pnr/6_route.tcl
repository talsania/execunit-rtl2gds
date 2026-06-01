setNanoRouteMode -route_with_timing_driven          true \
                 -route_with_si_driven               true \
                 -route_concurrent_minimize_via_count_effort high \
                 -route_detail_fix_antenna           true

routeDesign -globalDetail

setExtractRCMode -engine postRoute

setAnalysisMode -analysisType onChipVariation \
                -cppr both

optDesign -postRoute \
          -outDir ../reports/optDesign_postRoute

optDesign -postRoute \
          -hold \
          -outDir ../reports/optDesign_postRoute_hold

verify_drc -report ../reports/verify_drc_route.rpt

verifyConnectivity -type regular \
                   -report ../reports/verify_conn_route.rpt

timeDesign -postRoute \
           -pathReports \
           -outDir ../reports/timeDesign_postRoute

timeDesign -postRoute \
           -hold \
           -pathReports \
           -outDir ../reports/timeDesign_postRoute_hold

saveDesign ../outputs/6_route.enc

puts "\n\[DONE\] Routing complete."
puts " Check ../reports/verify_drc_route.rpt        — target 0 violations"
puts " Check ../reports/verify_conn_route.rpt       — target 0 violations"
puts " Check ../reports/timeDesign_postRoute        — setup WNS >= 0"
puts " Check ../reports/timeDesign_postRoute_hold   — hold WNS >= 0"
