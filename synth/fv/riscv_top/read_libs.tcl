add_search_path . /software/cadence/installs/DDI251/GENUS251/tools.lnx86/lib/tech -library -both
read_library -liberty -both \
    /pdk/SCLPDK_V3.0_KIT/scl180/memory/spram/4M1L/SPRAM_2048x36/SPRAM_2048x36_max_SP.lib \
    /pdk/SCLPDK_V3.0_KIT/scl180/memory/spram/4M1L/SPRAM_8192x36/SPRAM_8192x36_max_SP.lib \
    /pdk/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib

