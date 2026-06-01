set_clock_latency -source -early -max -rise  -0.393171 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -early -max -fall  -0.415562 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -late -max -rise  -0.393171 [get_ports {clk_i}] -clock clk 
set_clock_latency -source -late -max -fall  -0.415562 [get_ports {clk_i}] -clock clk 
