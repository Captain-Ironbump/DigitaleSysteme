new_project \
         -name {aufgabe2} \
         -location {C:\Users\lu121lin\Documents\Libro\DigitaleSysteme\Aufgabe_2\Aufgabe_2\designer\aufgabe2\aufgabe2_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S005} \
         -name {M2S005}
enable_device \
         -name {M2S005} \
         -enable {TRUE}
save_project
close_project
