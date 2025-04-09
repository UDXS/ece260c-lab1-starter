export PLATFORM         = ihp-sg13g2
export DESIGN_NAME      = asqrt_top

export VERILOG_FILES    = rtl/*.v
export SDC_FILE         = constraint.sdc

export USE_FILL = 1

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.50
export TNS_END_PERCENT  = 100

# !Complete the following the following 
# export VERILOG_TOP_PARAMS = N_CYCLES <N> N_PIPES <N> ..