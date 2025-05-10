# Init
set_db init_lib_search_path {/eda/pdks/65nm/65lp/Standard_Lib/u105039/tcbn65lp_220a/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn65lp_200a/}
set_db init_hdl_search_path {/home/au666333/hdl/source/}
read_libs tcbn65lptc_ccs.lib

# Load Design
read_hdl -language vhdl izhikevich.vhd
elaborate

## Check Design Comleteness
check_design -unresolved

## Check that the design has no major problem
check_design -all

# Constraints
## Resetting design constraints
reset_design -timing

## Create CLK (period is in ns)
create_clock -period 10 -name my_clock [get_ports i_clk]
report_clocks

## Add a 0.3 ns margin to account for clock jitter and skew in timing analysi
set_clock_uncertainty 0.3 [get_clocks my_clock]
## Set the slew (rise/fall time) to 0.2 ns for the clock waveform
set_clock_transition 0.2 [get_clocks my_clock]
## Define clock latency (delay from clock source to clock pin of sequential elements) as 1 ns.
set_clock_latency 1.0 [get_clocks my_clock]

## Specify input signal arrival time relative to my_clock as 5 ns.
set_input_delay 2 -max -network_latency_included -clock my_clock [all_inputs]
set_input_delay 0.1 -min -network_latency_included -clock my_clock [all_inputs]

## Model the external drive resistance on all of the input ports (unit is kohm)
set_drive 0.4 -max [all_inputs]
set_drive 0.01 -min [all_inputs]

## Set the input driving cell characteristics
set_driving_cell -max -library tcbn65lptc_ccs -lib_cell BUFFD24 -pin Z [all_inputs]
set_driving_cell -min -library tcbn65lptc_ccs -lib_cell BUFFD2 -pin Z [all_inputs]

## Specifies the maximum time the design has to produce a valid output after the clock edge. MAX:WC and MIN:BC
set_output_delay 2   -max -network_latency_included -clock my_clock [all_outputs]
set_output_delay 0.1 -min -network_latency_included -clock my_clock [all_outputs]

##Set the capacitive load (in picofarads, pF) seen at the output ports.
set_load 1.0 -max [all_outputs]
set_load 0.01 -min [all_outputs]

## Check Input Drive Strengths
report_port -driver *
## Check Output Loads
report_port -load *
## Check Input/Output Delays:
report_port -delay *

# Synthesis
## Synthesis Effort Settings: low, medium, high, express 
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

## Translates HDL to a generic netlist
syn_generic
## Maps to standard cells
syn_map
## Optimizes area, timing, etc.
syn_opt

# Post-synthesis
## Reports
report_timing > reports/report_timing.rpt
report_power  > reports/report_power.rpt
report_area   > reports/report_area.rpt
report_qor    > reports/report_qor.rpt

## Outputs
write_hdl > outputs/izhikevich_netlist.v
write_sdc > outputs/izhikevich_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/izhikevich_sdf.sdf
