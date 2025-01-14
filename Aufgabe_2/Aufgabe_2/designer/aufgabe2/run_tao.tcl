set_device -family {SmartFusion2} -die {M2S005} -speed {STD}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_2\std_counter.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_2\sync_buffer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_2\lib\lfsr_lib.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_2\sync_module.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_1\hex4x7seg.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\VorlesungsSkripte\Aufgabe_2\aufgabe2.vhd}
set_top_level {aufgabe2}
map_netlist
check_constraints {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\Aufgabe_2\Aufgabe_2\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\Aufgabe_2\Aufgabe_2\designer\aufgabe2\synthesis.fdc}
