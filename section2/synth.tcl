# ECE 260C Lab 1 - DSE
# Yosys Script

yosys -import

# You need to make sure this line outputs correctly, otherwise you will likely need to make fixes in explore.py
puts "Yosys is running for the design with $::env(DSE_N_CYCLES) cycles, $::env(DSE_N_PIPES) pipes, $::env(DSE_N_DEPTH) depth."

# Load our design, but don't flatten it or set hierarchy yet
read_verilog rtl/asqrt_top.v rtl/asqrt_pipe.v rtl/asqrt_iu.v

# chparam can be used to parametrize a module. 
# When we use it for the top module like this, we can safely change the instantiatiion of the module itself 
# without dealing with specific sub-instantiations.
# For this reason, it can be beneficial (when practical) to bring parameters up through to the top module (i.e. in asqrt_top.v)
chparam -set N_CYCLES $::env(DSE_N_CYCLES) asqrt_top
# TODO: the above chparam for N_PIPES and N_DEPTH 


# Now, we set hierarchy
hierarchy -top asqrt_top
# TOOD: Here, insert the synthesis and techmapping script we used in Section 1, starting from the flatten command and ending with opt_clean



# Here, we output area for our record and then the netlist that OpenSTA needs
tee -o dse.stat.json stat -liberty sg13g2_stdcell_typ_1p20V_25C.lib -json 
write_verilog dse.postmap.v