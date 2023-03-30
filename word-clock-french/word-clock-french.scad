grid_x = 11;
grid_y = 10;
margin = 10;
cell_x = 16;
cell_y = 16;
first_layer = 0.2;
overall_width = grid_x * cell_x + 2 * margin;
overall_height = grid_y * cell_y + 2 * margin;
thickness = 2;
letter_depth = thickness - first_layer + 0.1;
offset_x = 10;
offset_y = 10;
ze = 15;
hole_offset = 8;

font="Bitstream Vera Sans Mono:style=Bold";

back_thickness = 10;
back_first_layer = 1;
back_depth = back_thickness - back_first_layer;

plate_thickness = 2;

led_width = 10;

words = [
    "ETSDEMIEPAN",
    "VINGT-CINQU",
    "ETRQUARTRED",
    "MOINSOLEDIX",
    "ONZERHEURES",
    "HUITNEUFDIX",
    "CINQSIXSEPT",
    "QUATREDOUZE",
    "DEUXNUTROIS",
    "ILNESTOUNER",
];

/*
difference() {
    cube([overall_width, overall_height, plate_thickness]);
    
    translate([hole_offset, hole_offset, -0.1])
        linear_extrude(plate_thickness + 0.2)
        circle(r=2);
    translate([hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, hole_offset, -0.1])
        linear_extrude(plate_thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(plate_thickness + 0.2)
        circle(r=2); 

    for (y = [0:grid_y-1]) {
       translate ([margin, margin + y*cell_y + 3, plate_thickness-0.2])
            cube([cell_x*grid_x, led_width, 0.4]);
    }    
    
    translate([15, overall_height - 15, -0.1])
        linear_extrude(plate_thickness + 0.2)
        circle(r=3);
}
*/


difference() {
    cube([overall_width, overall_height, back_thickness]);

    translate([hole_offset, hole_offset, -0.1])
        linear_extrude(back_thickness + 0.2)
        circle(r=2);
    translate([hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(back_thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, hole_offset, -0.1])
        linear_extrude(back_thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(back_thickness + 0.2)
        circle(r=2);
    
    for (y = [0:grid_y-1]) {
        for (x = [0: grid_x -1]) {
            translate ([margin + x*cell_x + cell_x/2, margin + y*cell_y + cell_y/2, back_thickness/2])
                cube([cell_x-1, cell_y - 1, back_thickness+2], center=true);

        }
    }
    
    translate([margin-6, margin+.5, -1])
        cube([12, cell_y*grid_y-1, 7]);
    translate([margin + cell_x*grid_x - 6, margin+.5, -1])
        cube([12, cell_y*grid_y-1, 7]);
    
}


/*
difference() {
    cube([overall_width, overall_height, thickness]);
    
    translate([hole_offset, hole_offset, -0.1])
        linear_extrude(thickness + 0.2)
        circle(r=2);
    translate([hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, hole_offset, -0.1])
        linear_extrude(thickness + 0.2)
        circle(r=2);
    translate([overall_width - hole_offset, overall_height - hole_offset, -0.1])
        linear_extrude(thickness + 0.2)
        circle(r=2);
    
    for (y = [0:grid_y-1]) {
        word = words[y];
        for (x = [0: grid_x -1]) {
            letter = word[x];
            translate ([margin + x*cell_x + cell_x/2, margin + y*cell_y + cell_y/2, first_layer])
                linear_extrude(letter_depth)
            text(letter, halign="center", valign="center", font=font);
        }
    }
    
}
*/

