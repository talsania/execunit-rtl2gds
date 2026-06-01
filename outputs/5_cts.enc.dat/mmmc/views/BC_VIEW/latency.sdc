set_clock_latency -source -early -min -rise  -0.186218 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -early -min -fall  -0.192494 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -late -min -rise  -0.186218 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -late -min -fall  -0.192494 [get_ports {clk_i}] -clock clk 
