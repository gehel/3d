rail_width = 40; // x
rail_length = 200; // y
rail_height = 40;

magnet_x = 20;
magnet_y = 10;
magnet_z = 2;

magnet_border = (rail_width - magnet_x)/2;

wall_thickness = 4;
magnet_cover_thickness = 0.6;
base_thickness = 0.8;
rail_thickness = base_thickness + magnet_z + magnet_cover_thickness;



difference() {
    cube([rail_width, rail_length, rail_height]);
    translate([wall_thickness, 0, rail_thickness])
        cube([rail_width - 2*wall_thickness, 200, rail_height - rail_thickness]);
    for (i = [0:15]) {
        translate([magnet_border, 5 + i*(magnet_x + 2), base_thickness])
            cube([magnet_border + magnet_x, magnet_y, magnet_z]);
        translate([0, 5 + i*(magnet_x + 2), base_thickness+2])
            cube([magnet_border, 3, magnet_z]);
    }
}