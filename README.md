# RISC-V Execution Unit (RTL-to-GDS)
<img width="2880" height="1800" alt="Screenshot from 2026-06-01 21-02-16" src="https://github.com/user-attachments/assets/8ab9792a-de55-487c-9043-0558c5ac8033" />

## Specifications
**Inputs:**
| Signal   | Width | Description |
|----------|-------|-------------|
| `clk_i`    | 1     | Clock signal (positive edge-triggered) |
| `rst_ni`   | 1     | Active-low asynchronous reset |
| `rs1_addr_i` | 5  | Register file read address 1 |
| `rs2_addr_i` | 5  | Register file read address 2 |
| `rd_addr_i`  | 5  | Register file write address |
| `we_i`       | 1  | Write-back enable |
| `imm_i`      | 32 | Sign-extended immediate |
| `alu_src_b_i`| 1  | ALU source B select (0=rs2, 1=immediate) |
| `alu_op_i`   | 4  | ALU operation code |

**Outputs:**
| Signal    | Width | Description |
|-----------|-------|-------------|
| `alu_result_o` | 32 | ALU result |
| `zero_o` | 1 | Zero flag |
| `neg_o` | 1 | Negative flag |
| `overflow_o` | 1 | Overflow flag |
| `carry_o` | 1 | Carry flag |
| `dbg_data_o` | 32 | Debug read-back from register file |

## Metrics
### Timing
- **Clock Period:** 50 ns
- **Critical Path Slack:** 27125 ps
- **Max Delay (overflow_o):** 20.875 ns
- **Timing Status:** ✓ All paths met

### Area
- **Total Area:** 247868.171 µm²
- **Cell Area:** 161710.976 µm²
- **Net Area:** 86157.195 µm²
- **Instance Count:** 4651 cells (3386 in register file)

### Power (@ nominal conditions)
- **Total Power:** 2.270 mW
  - Internal Power: 1.797 mW (79.18%)
  - Switching Power: 0.471 mW (20.73%)
  - Leakage Power: 2.02 µW (0.09%)
- **Register Power:** 1.450 mW (63.86%)
- **Logic Power:** 0.709 mW (31.21%)
- **Clock Power:** 0.112 mW (4.93%)

## Tools & Technology
- **RTL Simulation:** Cadence Xcelium 25.13
- **Synthesis:** Cadence Genus 25.13
- **Place & Route:** Cadence Innovus 25.13
- **Technology:** SCL 180nm PDK
