import os
import json
import matplotlib.pyplot as plt

print("ECE 260C Lab 1: Design Space Explorer")
print("Your name and PID here") # !!!

# Since we need an integer amount of iterating units, we should only use powers of two.
N_CYCLES_range = [16, 8, 4, 2, 1]

results = []

for N_CYCLES in N_CYCLES_range:
    N_PIPES =  # TODO: Fill in here
    N_DEPTH = # TODO: Fill in here
    
    print(f"== Running DSE step for {N_CYCLES} cycles - {N_PIPES} pipes at {N_DEPTH} depth ==")
    
    # Every step requires running yosys and OpenSTA.
    # TODO: We need to lift our parameters to environment variables so that Yosys can read in - corresponding to our parameters
    os.environ["DSE_N_CYCLES"] = str(N_CYCLES)
    # TODO: ...

    # Now, we can call yosys. Make sure your synth.tcl is complete.
    os.system("yosys -c synth.tcl")
    # Then, we can call into OpenSTA with Yosys' results. Make sure your analysis.tcl is complete.
    os.system("sta -exit analysis.tcl")
    
    # We now have two statistics files called dse.stat.json and dse.analysis.json
    
    # dse.stat.json is from Yosys and, importantly, contains cell count and area information.
    
    yosys_stats = json.load(open("dse.stat.json"))
    module = yosys_stats["modules"]["\\asqrt_top"]
    area_um2 = module["area"]
    num_cells = module["num_cells"]
    
    print(f"Yosys/ABC produced a design with an area of {area_um2} and a cell count of {num_cells}")
    
    
    # dse.analysis.json is from OpenSTA and provides us with timing 
    # currently, power is unavailable in JSON but can be extracted using traditional Regex.
    
    # We care about Arrival Time here. OpenSTA provides it here in seconds.
    sta_analysis = json.load(open("dse.analysis.json"))
    arrival_time = sta_analysis["checks"][0]["data_arrival_time"]
    fmax = 1.0/arrival_time
    
    # let's make our units more convenient for printing and then graphing
    arrival_time_ns = arrival_time * 1e9
    fmax_mhz = round(fmax / 1_000_000, 2)
    
    print(f"OpenSTA says it the minimum period is {arrival_time_ns} ns == f_max = {fmax_mhz}")
    
    
    # Now, we should collect the results we want to graph later
    results.append({
        "N_CYCLES": N_CYCLES,
        "area_um2": area_um2,
        "fmax_mhz": fmax_mhz,
    })


# Save all results to 
json.dump(results, open("dse.table.json", "w"))


# Now that all the data is prepared, we can graph it.

X = [result["N_CYCLES"] for result in results]
Y1 = [result["area_um2"] for result in results]
Y2 = [result["fmax_mhz"] for result in results]

fig, axs = plt.subplots(2)
fig.suptitle("asqrt Design Space Exploration Report")
axs[0].plot(X, Y1)
axs[0].set_title("Area given N_CYCLES")
axs[0].set_xlabel ("N_CYCLES ")
axs[0].set_ylabel ("Area (um2)")

axs[1].plot(X, Y2)
axs[1].set_title("f_max given N_CYCLES")
axs[1].set_xlabel ("N_CYCLES")
axs[1].set_ylabel ("f_max (MHz)")
fig.tight_layout()
plt.savefig("dse.png")
plt.show()