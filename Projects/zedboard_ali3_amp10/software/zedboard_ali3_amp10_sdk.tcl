#Example test.tcl

#!/usr/bin/tclsh
set project  "zedboard_ali3_amp10"
set hw_name  "zed_ali3_hw"
set bsp_name "zed_ali3_bsp"
set console_app_name "zed_ali3_console_app"

# Set workspace and import hardware platform
sdk set_workspace ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk create_hw_project -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk create_bsp_project -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject zed_ali3_hw -os standalone
sdk build_project -type bsp -name ${bsp_name}

# Create ALI3 display console application
puts "\n#\n#\n# Creating ${console_app_name} ...\n#\n#\n"
sdk create_app_project -name ${console_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${console_app_name} -path ../software/${console_app_name}/src

# Build ALI3 display console application
puts "\n#\n#\n# Build ${console_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${console_app_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit