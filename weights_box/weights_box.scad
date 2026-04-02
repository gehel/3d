include <Chamfers-for-OpenSCAD/Chamfer.scad>

$fs = 0.1;
$fn=50;

box_x = 103;
box_y = 73;
box_z = 30;
lid_z = 15;

magnet_h = 2;
magnet_d = 6.7;
magnet_border = 1.5;

ext_space = 4;
int_space = 5;


difference() {
    translate([0, 0, box_z])
        chamferCube([box_x, box_y, lid_z]);

    translate([ext_space, ext_space, 0])
    line_of_weights_top([
        [27, 25, 38, 8],
        [20, 20, 32, 8],
        [14, 15, 22, 5],
        [14, 15, 22, 5],
    ]);

    translate([94, 35, 0])
    rotate([0, 0, 180])
    line_of_weights_top([
        [11, 12, 18, 5],
        [9, 9, 17, 5],
        [5, 7, 10, 5],
        [5, 7, 10, 5],
        [5, 5, 9, 5],
    ]);

    
    // pliers
    translate([ext_space, 40, box_z - 1])
        cube([67, 8, 6 + 1]);

    // small weights
    translate([ext_space + 95/2 - 20/2, 40 + 8 + int_space + 16/2 - 5/2, box_z - 1])
        cube([20, 5, 8]);

    // magnets
    translate([magnet_border + magnet_d/2, magnet_border + magnet_d/2, box_z-1])
        magnet();
    translate([box_x - magnet_border - magnet_d/2, magnet_border + magnet_d/2, box_z-1])
        magnet();
    translate([box_x - magnet_border - magnet_d/2, 35, box_z-1])
        magnet();
    translate([magnet_border + magnet_d/2, 35, box_z-1])
        magnet();

}


difference() {
    chamferCube([box_x, box_y, box_z]);

    translate([ext_space, ext_space, 0])
    line_of_weights([
        [27, 25],
        [21, 20],
        [15, 15],
        [15, 15],
    ]);

    translate([94, 35, 0])
    rotate([0, 0, 180])
    line_of_weights([
        [12, 12],
        [10, 9],
        [6, 7],
        [6, 7],
        [5, 5],
    ]);
    
    // pliers
    translate([ext_space, 40, box_z-8+1])
        cube([67, 8, 8]);

    // small weights
    translate([ext_space, 40 + 8 + int_space, box_z-3+1])
        cube([95, 16, 3]);

    translate([ext_space, 40 + 8 + int_space, box_z - 9])
        cube([7, 16, 9]);
    translate([ext_space + 7 + 1, 40 + 8 + int_space, box_z - 9])
        cube([7, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1, 40 + 8 + int_space, box_z - 9])
        cube([7, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1 + 7 + 1, 40 + 8 + int_space, box_z - 9])
        cube([10, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1 + 7 + 1 + 10 + 1, 40 + 8 + int_space, box_z - 9])
        cube([13, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1 + 7 + 1 + 10 + 1 + 13 + 1, 40 + 8 + int_space, box_z - 9])
        cube([13.5, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1 + 7 + 1 + 10 + 1 + 13 + 1 + 13.5 + 1, 40 + 8 + int_space, box_z - 9])
        cube([13.5, 16, 9]);
    translate([ext_space + 7 + 1 + 7 + 1 + 7 + 1 + 10 + 1 + 13 + 1 + 13.5 + 1 + 13.5 + 1, 40 + 8 + int_space, box_z - 9])
        cube([17, 16, 9]);
    
    // magnets
    translate([magnet_border + magnet_d/2, magnet_border + magnet_d/2, box_z - magnet_h])
        magnet();
    translate([box_x - magnet_border - magnet_d/2, magnet_border + magnet_d/2, box_z - magnet_h])
        magnet();
    translate([box_x - magnet_border - magnet_d/2, 35, box_z - magnet_h])
        magnet();
    translate([magnet_border + magnet_d/2, 35, box_z - magnet_h])
        magnet();
}

module line_of_weights_top(weights) {
    l_top(0, 0, weights);
}

module l_top(start, i, weights) {
    w = weights[i];
    h = w[0];
    d = w[1];
    t_h = w[2];
    t_d = w[3];
    y = d/2;
    translate([start + d/2, y, 0])
        weight_top(t_h - h + 1, t_d);
    if (i < len(weights)-1)
        l_top(start + int_space + d, i+1, weights);
}

module weight_top(h, d){
    translate([0, 0, box_z-1])
        cylinder(h=h+1, d=d+1);
}

module line_of_weights(weights) {
    l(0, 0, weights);
}

module l(start, i, weights) {
    w = weights[i];
    h = w[0];
    d = w[1];
    y = d/2;
    translate([start + d/2, y, 0])
        weight(h, d);
    if (i < len(weights)-1)
        l(start + int_space + d, i+1, weights);
}

module weight(h, d){
    translate([0, 0, box_z-h+1])
        cylinder(h=h+1, d=d+1);
}

module magnet() {
    cylinder(h=magnet_h + 1, d=magnet_d);
}
