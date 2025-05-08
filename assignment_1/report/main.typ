 #import "lib.typ": *

#show: ieee.with(
  title: [A 256-kb 65-nm Sub-threshold SRAM Design for Ultra-Low-Voltage Operation: Review and Verification],
  abstract: [
    Due to technology scaling, modern digital circuits often contain millions of SRAM cells for fast storage of data. As transistor size have decreased, leakage current has increased, resulting in static power consumption often being the most significant contributor to overall power consumption. Low-voltage operation for SRAM is an attractive solution to save power. In this report we will review and verify the findings of the paper "A 256-kb 65-nm Sub-threshold SRAM Design for Ultra-Low-Voltage Operation", confirming its findings and evaluating the proposed 10T bitcell capable of operating in the sub-threshold region.    
  ],
  authors: (
    (
      name: "Andreas Pedersen",
      email: "202104430@post.au.dk"
    ),
    (
      name: "Alexandre Cherencq",
      email: "201506019@post.au.dk"
    ),
    (
    name: "Martin Harder",
    email: "201905207@post.au.dk"
  ),
  ),
  bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
)

= Introduction
#h(10pt)Static Random Access Memory (SRAM) can retain its stored information for as long as power is supplied. A _block_ of SRAM is built up of individual _bitcells_, each cell capable of storing 1 bit. The most common structure is the 6T bitcell (#ref(<sram-6t>)). The core of the cell is formed by two cross-coupled CMOS inverters. The feedback loop formed by the cross-coupling stabilizes the inverters to their respective state. The access transistors ($M_5$, $M_6$) and the word and bit lines, WL and BL, are used to read and write from or to the cell. 

#v(5pt)
Due to technology scaling, leakage power has become a significant contributor to total power consumption for modern integrated designs. An attractive solution is to lower the supply voltage for the SRAM cells, offering an exponential decrease in leakage power consumption.
Three issues arise when lowering the $V_("DD")$ of the 6T bitcell:

#v(5pt)
1. Hold static noise margin (SNM) plummets as the feedback in the inverter cell weakens, causing data errors.

2. Access transistors become too weak to overpower the inverter cell, causing write errors.

3. The circuit becomes more susceptible to $V_T$ variations, causing large differences in SNM in process corners.

#v(5pt)
Because of these issues, different topologies must be explored to address them when aiming for driving memory circuits using lower voltages and smaller transistor sizes. 

== 6T Read operation
The stability of the bitcell, or its ability to hold the data, depends on the feedback loop formed by the two inverter blocks ($M_1, M_2, M_3, M_4$ in #ref(<sram-6t>)). When reading from the cell, the access transistors connect the bitcell to the bitlines. As the supply voltage is lowered, the drive strength of the inverters weakens, lessening their capability to drive the bitlines during access. This stability-disturbing effect mainly arises because the bitlines are precharged to "1" before the read access. Since the bitcell always holds a "1" and a "0", the inverter outputting a "0" has to discharge the precharged bitline. 

== 6T Write operation
During write both bitlines are driven and the access transistors are enabled. The write operation depends on the bitlines being able to "overpower" the back-to-back inverters. As the supply voltage is lowered, the drive strength of the bitlines is lessened, weakening the write operation.

== Process variations
When lowering the supply voltage, the difference between the transistors threshold voltages becomes more significant. These differences arise from the manufacturing process, in which transistors will come out having small variations in $V_T$. As mentioned, this is far less important and negligible when using supply voltages that are not in the range of $V_T$. 

#figure(
  image("images/replace_me_pls_6t.png", width: 80%),
  caption: [6T bitcell.],
  placement: top
) <sram-6t>

#figure(
  image("images/schematic.svg"),
  caption: [Sub-threshold 10T bitcell.],
  placement: top
) <sram-10t>

= 10T Bitcell

To alleviate the previously mentioned issues, a 10T bitcell is proposed in #cite(<calhoun>) (#ref(<sram-10t>)). With the addition of four transistors ($M_7, M_8, M_9, M_(10)$), the read and write operations are decoupled, providing a single-ended, buffered output on RBL. The write operations are done through the typical 6T bitlines. In addition, a virtual supply rail, $V_("VDD")$, is used to weaken the inverter-cell feedback by leaving it floating during write operations. Transistor $M_(10)$ reduces leakage through $M_8$ to RBL, by providing a '1' on the node shared by ($M_8, M_9, M_(10)$) when QB is 1, and by lowering leakage due to the stack effect when QB is 0.

== Enabling Sub-threshold Read

Read-SNM is one of the largest challenges for sub-threshold operation. The buffer improves the read operation by shielding the inverter cell from the bitlines during read. The 4T buffer structure further improves bitline leakage during both possible cell states (#ref(<output_buf>)).

== Enabling Sub-threshold write 
In a typical 6T design a write operations are not possible when $V_(\D\D)$ is lowered towards $V_T$ because the nMOS access transistor will have trouble overpowering the pMOS when writing a "0" #cite(<calhoun>). To solve this issue, a gated virtual supply rail is used to float the supply during write operations. Forcing the supply to float during write, weakens the feedback inverter loop enough to enable the access transistor to force a zero on the respective bitline.  

= Simulation

The proposed 10T bitcell was implemented in a TSMC 65nm process and simulated in Cadence Virtuoso. Two writes and reads are shown in #ref(<tran_sim>). The simulation shows a significant drop in the virtual supply rail during writes. All NMOS were sized as ($120"nm""/"60"nm"$), and all PMOS were sized as ($240"nm""/"60"nm"$).

== Hold SNM

_Hold Static Noise Margin_ is arguably the parameter of least interest. It decreases as $V_("DD")$ is lowered, but does not present the largest challenge for sub-threshold operation. Since the inverter cell is identical for both the 6T and 10T architecture, the hold SNM is identical (#ref(<hold_snm>)).

== Read SNM

_Read Static Noise Margin_ is the main parameter the proposed architecture attempts to improve for sub-threshold operation. As seen in #ref(<read_snm>), the read SNM for the 10T architecture is practically identical to the hold SNM. This is due to the added buffer. Effectively shielding the inverter cell during reads. This is in stark comparison to the 6T architecture, where read SNM suffers significantly.

#colbreak()

#figure(
  image("images/fig6.png"),
  caption: [Schematic of read buffer from 10T bitcell for both data values. In both cases, leakage is reduced to the bitline and through the inverter relative to the case where $M_(10)$ is excluded.],
  placement: top
) <output_buf>

#figure(
  image("images/sram_vdd_0.3.svg"),
  caption: [Read and write for 10T sub-threshold bitcell with $V_("DD") = 0.3 "V"$.],
  placement: top
) <tran_sim>

#figure(
  image("images/butterfly_hold_0.3.svg", width: 90%),
  caption: [Hold Static Noise Margin with $V_("DD") = 0.3 "V"$.],
  placement: top
) <hold_snm>

#pagebreak()

#figure(
  image("images/butterfly_read_0.3.svg", width: 90%),
  caption: [Read Static Noise Margin with $V_("DD") = 0.3 "V"$.],
  placement: bottom
) <read_snm>

#figure(
  image("images/sram_wm_1.2.svg", width: 100%),
  caption: [10T Write WM with and without floating rail ($V_(D D) = 1.2 "V"$).],
  placement: bottom
) <10t_wm>

== Write Margin

As seen in #ref(<10t_wm>) the write margin improves significantly from the use of the virtual $V_(D D)$ rail for the inverter cell. At $V_(D D) = 1.2 "V"$, the WM is improved by $0.23 "V"$.

== Sub-threshold Operation in Process Corners

The worsening of read SNM in worst-case process corners is of particular interest. A main difficulty during reading is the imbalance between NMOS and PMOS devices. The skewed corners (FS, SF) are therefore expected to provide the best and worst performance. See in #ref(<6t_read_snm>) how the read SNM is highly dependent on the process corner, being significantly worse in the FS corner and significantly better in the SF corner. This is in stark contrast to the 10T cell (#ref(<10t_read_snm>)) where the read SNM is much less dependent on the process corner, yielding a more stable performance.

= Discussion and conclusion

In this report, we reviewed and verified the proposed 10T bitcell from #cite(<calhoun>), aimed at enabling stable sub-threshold operation of SRAM cells in 65nm CMOS technology. Through simulation, we confirmed that the 10T topology offers attractive improvements in Read SNM, WM, and minimum $V_(D D)$ compared to the conventional 6T cell. This is primarily achieved by buffering the inverter-cell's value, isolating the cell from the bitlines during read, and by introducing a virtual supply rail, enabling robust writes near threshold voltage. In conclusion, the 10T design is a viable solution for low-voltage SRAM, at the cost of increased area for the additional four transistors.

#figure(
  image("images/6t_snm.svg", width: 90%),
  caption: [6T Read SNM at different process corners.],
  placement: bottom
) <6t_read_snm>

#figure(
  image("images/10t_snm.svg", width: 90%),
  caption: [10T Read SNM at different process corners.],
  placement: bottom
) <10t_read_snm>

#pagebreak()

/*
== Paper overview

To alleviate the mentioned issues, a 10T bitcell is proposed in #cite(<calhoun>) (#ref(<sram-10t>)). With the addition of four transistors ($M_7, M_8, M_9, M_(10)$), the read and write operations are decoupled. Providing a single-ended, buffered output on RBL. The write-operation are done through the typical 6T bitlines. In addition, a virtual supply rail, $V_("VDD")$, is used to weaken the inverter-cell feedback by leaving it floating during write operations. Transistor $M_(10)$ reduces leakage through $M_8$ to RBL, by providing a '1' on the node shared by ($M_8, M_9, M_(10)$) when QB is 1, and by lowering leakage due to the stack effect when QB is 0.
*/


/*
== Test chip
In the paper the proposed 10T design is implemented on a 65nm TSMC test chip, in the testing of this chip several conclusions are found first that the first read / write errors when pushing the Vdd lower is that 
*/
