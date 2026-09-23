vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../../../../../AMDDesignTools/2026.1/Vivado/data/rsb/busdef" \
"../../../../lab_2.1.gen/sources_1/ip/hdmi_tx_0/hdl/encode.v" \
"../../../../lab_2.1.gen/sources_1/ip/hdmi_tx_0/hdl/serdes_10_to_1.v" \
"../../../../lab_2.1.gen/sources_1/ip/hdmi_tx_0/hdl/srldelay.v" \
"../../../../lab_2.1.gen/sources_1/ip/hdmi_tx_0/hdl/hdmi_tx_v1_0.v" \
"../../../../lab_2.1.gen/sources_1/ip/hdmi_tx_0/sim/hdmi_tx_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

