
read_verilog dse.postmap.v
read_liberty sg13g2_stdcell_typ_1p20V_25C.lib
link_design asqrt_top

# !Create a clock with a 5 ns period here using the syntax from Section 1


# This will write out the analysis report so Python can use it.
report_checks -format json > dse.analysis.json