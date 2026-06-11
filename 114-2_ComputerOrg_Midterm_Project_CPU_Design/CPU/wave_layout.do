onerror {resume}
quietly WaveActivateNextPane {} 0

# Global & Fetch
add wave -noupdate -group {Global & Fetch} /Testbench/clk
add wave -noupdate -group {Global & Fetch} /Testbench/reset
add wave -noupdate -group {Global & Fetch} -radix hex /Testbench/CPU/pc_out
add wave -noupdate -group {Global & Fetch} -radix hex /Testbench/CPU/inst
add wave -noupdate -group {Global & Fetch} -radix hex /Testbench/CPU/if_id_inst

# Hazard Control
add wave -noupdate -group {Hazard Control} /Testbench/CPU/PCSrc
add wave -noupdate -group {Hazard Control} /Testbench/CPU/PCWrite
add wave -noupdate -group {Hazard Control} /Testbench/CPU/IF_ID_Flush
add wave -noupdate -group {Hazard Control} /Testbench/CPU/ID_EX_Flush
add wave -noupdate -group {Hazard Control} /Testbench/CPU/EX_MEM_Flush
add wave -noupdate -group {Hazard Control} /Testbench/CPU/stall_id_ex

# Forwarding
add wave -noupdate -group {Forwarding} /Testbench/CPU/ForwardA
add wave -noupdate -group {Forwarding} /Testbench/CPU/ForwardB
add wave -noupdate -group {Forwarding} -radix hex /Testbench/CPU/alu_dataA
add wave -noupdate -group {Forwarding} -radix hex /Testbench/CPU/alu_dataB

# Multiplier & TotalALU
add wave -noupdate -group {Multiplier} -radix unsigned /Testbench/CPU/ex_signal
add wave -noupdate -group {Multiplier} /Testbench/CPU/mult_stall
add wave -noupdate -group {Multiplier} /Testbench/CPU/total_alu_inst/busy
add wave -noupdate -group {Multiplier} -radix hex /Testbench/CPU/total_alu_inst/hilo_inst/HiOut
add wave -noupdate -group {Multiplier} -radix hex /Testbench/CPU/total_alu_inst/hilo_inst/LoOut

# Memory & WriteBack
add wave -noupdate -group {Memory & WB} -radix hex /Testbench/CPU/alu_result
add wave -noupdate -group {Memory & WB} /Testbench/CPU/ex_mem_m
add wave -noupdate -group {Memory & WB} -radix hex /Testbench/CPU/ex_mem_write_data
add wave -noupdate -group {Memory & WB} /Testbench/CPU/mem_wb_wb
add wave -noupdate -group {Memory & WB} -radix unsigned /Testbench/CPU/mem_wb_write_reg
add wave -noupdate -group {Memory & WB} -radix hex /Testbench/CPU/wb_data

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
update