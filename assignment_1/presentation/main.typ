#import "preamble.typ": *

#show: slides.with(
  title: "A 256-kb 65-nm Sub-threshold SRAM Design for Ultra-Low-Voltage Operation",
  subtitle: "VLSI - Assignment 1",
  date: "07.04.2025",
  authors: ("Andreas", "Alexandre", "Martin"),

  // Optional Styling (for more / explanation see in the typst universe)
  ratio: 16/9,
  layout: "medium",
  title-color: blue.darken(80%),
  toc: true,
)
#set heading(numbering: none)
== Introduction - Motivation
#set page(columns: 2)
- Ultra-low supply voltage (below $V_T$) reduces power consumption by reducing leakage and active energy.
- SRAM uses a significant percentage of total area and power for many digital chips.
- SRAM leakage can dominate total chip leakage.
- Switching capacitive bitlines and wordlines is costly in terms of energy.
#figure(
  image("images/battery.png"),
)
== Introduction - 6T Challenges at low voltage
#set page(columns: 2)
- *Stability Issues*
  - SNM plummets as $V_(D\D)$ drops. //butteryfly plot? 
  - Destructive errors in sub-threshold voltages because of low SNM.
  - Write errors because access transistors can't overpower the pull-up $->$ writing "0" is a problem.
  - Process variations affects $V_T$ degrading SNM.
#quote["A bulk CMOS 65-nm SRAM reports a minimum
 operating voltage of 0.7 V"]
#figure(
  image("images/6TSRAM.png"), caption: [6T SRAM - CMOS VLSI Design, A circuits and Systems Perspective], scope: "column"
)

== 10T SRAM Bitcell overview
#set page(columns: 2)
- Addition of four transistor to the 6T SRAM core. 
  - *Decouples* reading and writing operations using the added transistors as a buffer
- Dedicated write access using the previous 6T bitcells bitlines.
- Addition of a *Virtual supply rail* ($V\V_(D\D)$)
  - Can be use to gate the feedback loop in order to #emph[weaken] it during write operations
/ Main idea : Separation of write and read operations and by weakening feedback loop while writing solves stability issues when lowering $V_(D\D)$
#colbreak()
#v(20pt)
#figure(
  image("images/schematic.svg", width: 110%),
  caption: [10T SRAM schematic]
)
== 10T Bitcell -Read Stability
- The read port uses a buffer that senses the store value without affecting the stored value in the cross-coupled inverters.
- Reading doesn't upset the stability of the cell.
- The cell can operate at lower supply voltage when read disturbance is eliminated
- The read port at M10 reduce leakage on bitline, allowing more bitcells to share the same bitline
  - Measurements showed that the 10T was able to correctly read even with 256 bitcells sharing the bitline down to 320mV 

#colbreak()
#v(20pt)
#figure(
  image("images/schematic.svg", width: 110%),
  caption: [10T SRAM schematic]
)
  
== 10T Bitcell - Read Operation
#set page(columns: 1)
#figure(
  image("images/schematic_read_1.svg", width: 100%),
)
#set page(columns: 2)

#pagebreak()
#set page(columns: 1)
#figure(
  image("images/schematic_read_2.svg", width: 100%),
)
#set page(columns: 2)

== Writing at Low Voltage
- In a 6T cell at low $V_(D\D)$ the cell's feedback fights the write. The solution is to:
  - Use a header transistor to gate  the supply in a row during write operation. This will make the supply float during write. 
  - On write, the wordline goes high and $V\V_(D\D)$ is turned off. 
  - The internal voltage of the inverter feedback is weakened, allowing for the bitlines to overpower the previous state. 
- This improves the write margin allowing for writing operations at voltages down to 350mV.
#colbreak()
#v(20pt)
#figure(
  image("images/schematic.svg", width: 110%),
  caption: [10T SRAM schematic]
)

== 10T Bitcell - Write Operation
#set page(columns: 1)
#figure(
  image("images/schematic_write.svg", width: 100%),
)
#set page(columns: 2)

== Simulation - Read and Write Signals
#set page(columns: 1)
#figure(
  image("images/sram_vdd_0.6.svg", width: 70%),
)
#set page(columns: 2)

== Energy efficiency and performance
- good power reduction
- good scaling on leakage power (saves 2.5X at 0.4V and 3.9X at 0.3V versus 0.6V)
- much lower read access power consumption
- Resolving the reading problem present in 6T design due to degraded RSNM 
#colbreak()
#figure(
  image("images/Leakage_paper_img.png")
)

#pagebreak()

- energy per op.
- throughput trade-off (frequency vs voltage)
- use case specific 
#colbreak()
#figure(
  image("images/freq_vs_voltage.png")
)

== Test chip result
#set page(columns: 1)
- working voltage range from 300mV to 1.2V
- read disturb errors removed versus traditional 6T SRAM cell at same operating voltage
- write success (traditionally subthreshold 6T SRAM fails)
- bitline scalability (6T read problems at 16 bitcells/line vs 256 bitcells/line on 10T)
- First bits failed to hold their value at approx VDD < 230mV 

== Simulation Results - Hold SNM (TT)
#set page(columns: 2)
#figure(
  image("images/butterfly_hold_0.6.svg"),
)
#colbreak()
#figure(
  image("images/butterfly_hold_0.3.svg"),
)

== Simulation Results - Read SNM (TT)
#figure(
  image("images/butterfly_read_0.6.svg"),
)
#colbreak()
#figure(
  image("images/butterfly_read_0.3.svg"),
)

== Simulation Results - Read SNM Corners
#figure(
  image("images/6t_snm.svg"),
)
#colbreak()
#figure(
  image("images/10t_snm.svg"),
)

== Conclusion

- Proposed 10T cell significantly improves read SNM.

- Much less susceptible to bad performance in corners (in particular skewed corners).

- Enabled energy efficient sub-threshold operation.

- Exponential decrease in static power consumption for decreased frequency.

- Should also be write margin improvements, though we haven't done the simulation yet.

#colbreak()
#v(20pt)
#figure(
  image("images/schematic.svg", width: 110%),
  caption: [10T SRAM schematic]
)