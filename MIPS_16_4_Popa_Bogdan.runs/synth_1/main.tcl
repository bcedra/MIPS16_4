# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.cache/wt [current_project]
set_property parent.project_path D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/TX_FSM.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/MEM.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/EX.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/UC.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/ID.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/IFF.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/MPG.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/SSD.vhd
  D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/sources_1/new/main.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/constrs_1/imports/Desktop/Basys3_test_env.xdc
set_property used_in_implementation false [get_files D:/workspace/Vivado/MIPS_16_4_Popa_Bogdan/MIPS_16_4_Popa_Bogdan.srcs/constrs_1/imports/Desktop/Basys3_test_env.xdc]


synth_design -top main -part xc7a35tcpg236-1


write_checkpoint -force -noxdef main.dcp

catch { report_utilization -file main_utilization_synth.rpt -pb main_utilization_synth.pb }