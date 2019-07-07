transcript off
vcom data_package.vhd
vcom down_sample.vhd 
vcom tb_down_sample.vhd 
vsim tb_down_sample
add wave sim:/tb_down_sample/uut/* 
run 8 us