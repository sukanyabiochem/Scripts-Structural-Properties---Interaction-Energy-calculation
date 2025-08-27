mol new equil13-pbc.gro type gro
##mol addfile equil11-pbc.xtc type xtc first $i last $i 

##set outfile [open test-angle-equil9.dat "a"]

set c3 {1 10 100 101 102 103 104 105 106 107 108 109 11 110 111 112 113 114 115 116 117 118 119 12 120 121 122 123 124 125 126 127 128 129 13 130 131 132 133 134 135 136 137 138 139 14 140 141 142 143 144 145 146 147 148 149 15 150 151 152 153 154 155 156 157 158 16 17 18 19 2 20 21 22 23 24 25 26 27 28 29 3 30 31 32 33 34 35 36 37 38 39 4 40 41 42 43 44 45 46 47 48 49 5 50 51 52 53 54 55 56 57 58 59 6 60 61 62 63 64 65 66 67 68 69 7 70 71 72 73 74 75 76 77 78 79 8 80 81 82 83 84 85 86 87 88 89 9 90 91 92 93 94 95 96 97 98 99}

set target_angle 61.827
set target_e2e   47.91
set tol_angle 5.0   ;# tolerance for angle (degrees)
set tol_e2e   5.0   ;# tolerance for E2E (nm)

foreach atmname $c3 {
        set ligg [atomselect top "resname LIG and resid $atmname"]
        set serials [$ligg get serial]
	set first_serial [lindex $serials 0]
	set last_serial  [lindex $serials end]
	set end1 [atomselect top "serial $first_serial"]
        set end2 [atomselect top "serial $last_serial"]
        set coord1 [lindex [$end1 get {x y z}] 0]
        set coord2 [lindex [$end2 get {x y z}] 0]
        set simdata [veclength [vecsub $coord1 $coord2]]
        set first20 [lrange $serials 0 19]
        set last20 [lrange $serials [expr {[llength $serials] -19}] end]
	set EO1 [atomselect top "serial $first20"]
        set cm1 [measure center $EO1 weight mass]
        set EO2 [atomselect top "serial $last20"]
        set cm2 [measure center $EO2 weight mass]
        set PO [atomselect top "resname LIG and resid $atmname and name PO"]
        set cm3 [measure center $PO weight mass]
        set vec1_2 [vecsub $cm3 $cm1]
        set vec2_3 [vecsub $cm3 $cm2]
        set angle_top [vecdot $vec1_2 $vec2_3]
        set vec3_2_len [veclength $vec2_3]
        set vec1_2_len [veclength $vec1_2]
        set angle_bottom [vecdot $vec1_2_len $vec3_2_len]
        set angle_cos [expr $angle_top/$angle_bottom]
        set angle_rad [expr acos($angle_cos)]
        set ang [expr $angle_rad*(180/3.14)]
	
	## check if within tolerance 
	if {abs($ang - $target_angle) < $tol_angle && abs($simdata - $target_e2e) < $tol_e2e} {
        puts "resid $atmname matches: angle=$ang, e2e=$simdata"
        
        # Write PDB for that frame
	#set inset [atomselect top "resname LIG and resid $atmname"]
	##$inset writepdb frame_$i.pdb
}	
## cleanup
$ligg delete
$EO1 delete
$EO2 delete
$PO delete
$end1 delete
$end2 delete
}
exit

resid 104 matches: angle=61.80970875887616, e2e=52.81123040463412
resid 125 matches: angle=56.910025205020844, e2e=45.95017645394182
resid 147 matches: angle=60.393149319828645, e2e=48.77007803043607
!!resid 152 matches: angle=61.044398173963444, e2e=45.848788854346225
resid 4 matches: angle=64.22462320867147, e2e=44.328050677060446
resid 43 matches: angle=64.31466378829904, e2e=51.683808035460075
resid 77 matches: angle=59.32988651287828, e2e=49.07919566483286
resid 98 matches: angle=60.21272722741894, e2e=46.46930623356914
