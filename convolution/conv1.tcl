transcript off
vcom conv1.vhd 
vcom conv1_tb.vhd 
vsim conv1_tb
add wave sim:/conv1_tb/uut/* 
run 1.5 us