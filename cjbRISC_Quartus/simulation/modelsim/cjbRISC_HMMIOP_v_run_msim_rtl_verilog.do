transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjb_PM_HMMIOP_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjb_DM_HMMIOP_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjbRISC_HMMIOP_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjbRISC_HMMIOP_DP_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjbRISC_HMMIOP_CU_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_RISC/cjb_IW2ASCII_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_sr_unit_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_logic_unit_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_const_unit_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_arith_unit_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_alu_struc_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_ALU/cjb_8bit_addsub_struc_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_nbit_reg_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_nbit_mux4to1_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_nbit_mux2to1_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_nbit_cntup_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_nbit_4loc_stack_v.v}
vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/verilog_primitives/cjb_fa_struc_v.v}

vlog -vlog01compat -work work +incdir+D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/cjbRISC_Quartus/../verilog_RISC {D:/Documents/RIT/Semester_4/cjb1402_EEEE-220/cjbRISC/cjbRISC_Quartus/../verilog_RISC/cjbRISC_HMMIOP_v_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  cjbRISC_HMMIOP_v_tb

add wave *
view structure
view signals
run -all
