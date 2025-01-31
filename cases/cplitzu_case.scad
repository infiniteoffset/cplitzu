$fn=64; 

// https://github.com/Irev-Dev/Round-Anything/
include <Round-Anything/polyround.scad>

pcbx = 19.05*7; // pcb width
pcby = 19.05*4; // pcb length

inscl = 0.5; // inside clearance from pcb

inhgt = 14.5; // inside height

cwt = 3.5; //case wall thickness
cbt = 3.5; //case bottom thickness

module case_inside(){
    sketchPoints=[
        [-inscl, -inscl,  1.5],
        [-inscl, pcby+inscl, 1.5],
        [pcbx+inscl,  pcby+inscl,  1.5],
        [pcbx+inscl,  -inscl,  1.5]
    ];
    polyRoundExtrude(
        sketchPoints,
        inhgt+0.1,
        r1=-0.5,
        r2=0.5,
        fn=$fn
    );
}

module case_outside(){
    sketchPoints=[
        [-inscl - cwt, -inscl - cwt,  5],
        [-inscl - cwt, pcby + inscl + cwt, 5],
        [pcbx + inscl + cwt,  pcby + inscl + cwt,  5],
        [pcbx + inscl + cwt,  -inscl - cwt,  5]
    ];
    translate([0, 0, -cbt])
    polyRoundExtrude(
        sketchPoints,
        inhgt + cbt,
        r1=1.5,
        r2=1.5,
        fn=$fn
    );
}

module case_body(){
    difference() {
        case_outside();
        case_inside();
    }
}

module mounting_hole(x=0, y=0){
    translate([x,y,-cbt-0.01]){
        cylinder(h=cbt+0.02, d=2.4);
        cylinder(h=1.5, d1= 4.4, d2=2.4);
    }
}

module foot_hole(x=0, y=0){
    translate([x,y,-cbt-0.01]){
        cylinder(h=0.6+0.01, d=8.6);
    }
}

module usbc_hole(x=0, y=0){
    translate([x,y,5])
    rotate([-90,0,0])
    hull(){
        translate([3.5,0,-0.01])
            cylinder(d=6.5, h=cwt+0.02);
        translate([-3.5,0,-0.01])
            cylinder(d=6.5, h=cwt+0.02);
    }
}



module trrs_hole(x=0, y=0){
    translate([x,y,6.15])
    rotate([0,90,0])
    translate([0,0,-0.01])
        cylinder(d=7, h=cwt+0.02);
}


module case(){
    difference(){
        case_body();
        
        mounting_hole(19.05*1,19.05*1);
        mounting_hole(19.05*1,19.05*3);
        mounting_hole(19.05*5,19.05*1);
        mounting_hole(19.05*5,19.05*3);
        
        foot_hole(4,4);
        foot_hole(4,pcby-4);
        foot_hole(pcbx-4,pcby-4);
        foot_hole(pcbx-4,4);
        
        trrs_hole(pcbx + inscl, 28.57);
        usbc_hole(123.15,pcby + inscl);
    }
}


case();

