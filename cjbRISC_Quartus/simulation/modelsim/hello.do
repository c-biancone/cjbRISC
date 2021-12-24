onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cjbRISC_HMMIOP_v_tb/i
add wave -noupdate /cjbRISC_HMMIOP_v_tb/Reset_tb
add wave -noupdate /cjbRISC_HMMIOP_v_tb/Clock_tb
add wave -noupdate /cjbRISC_HMMIOP_v_tb/PB1_tb
add wave -noupdate /cjbRISC_HMMIOP_v_tb/SW_tb
add wave -noupdate -radix ascii /cjbRISC_HMMIOP_v_tb/LEDs_tb
add wave -noupdate -radix ascii /cjbRISC_HMMIOP_v_tb/ICis_tb
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/IW
add wave -noupdate -radix unsigned /cjbRISC_HMMIOP_v_tb/crtMCis_tb
add wave -noupdate -radix unsigned /cjbRISC_HMMIOP_v_tb/muv/DP/R0out
add wave -noupdate -radix unsigned /cjbRISC_HMMIOP_v_tb/muv/DP/R1out
add wave -noupdate -radix unsigned /cjbRISC_HMMIOP_v_tb/muv/DP/R2out
add wave -noupdate -radix unsigned /cjbRISC_HMMIOP_v_tb/muv/DP/R3out
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_R0
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_R1
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_R2
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_R3
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/IB0
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/IB1
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/IB2
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/IB0_SEL
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/IB1_SEL
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/IB2_SEL
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/ALU_FS
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/ALU_Result
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/ALU_CNVZ
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/SRout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_SR
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/PCout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/RST_PC
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_PC
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/CNT_PC
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/PMout
add wave -noupdate -radix hexadecimal /cjbRISC_HMMIOP_v_tb/muv/DP/IRout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_IR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/MABRout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_MABR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/MAXRout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_MAXR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/MARout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_MAR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/DMout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/RW
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/IPDRout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_IPDR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/LD_OPDR
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/STKout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/push
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/pop
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/DP/ipstkmuxout
add wave -noupdate /cjbRISC_HMMIOP_v_tb/muv/ipstksel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4601610 ps} 0} {{Cursor 2} {1875000 ps} 0} {{Cursor 3} {11681942 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4626564 ps}
