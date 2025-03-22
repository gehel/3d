use <BOSL2/std.scad>


backplate_thickness=3;
outline_height=.4;
outline_width=.4;
outline_distance=3;

korry_heigth=10;
korry_width=10;

switch_dia=12;
switch_dia_big=20;

pot_dia=7;
pot_dia_big=12;

tolerance=.1;

module rounded_square(x, y, r, center=true) {
    hull() {
        if (center == true) {
            translate([-(x/2)+r, -(y/2)+r])
                circle(r=r);
            translate([-(x/2)+r, (y/2)-r])
                circle(r=r);
            translate([(x/2)-r, -(y/2)+r])
                circle(r=r);
            translate([(x/2)-r, (y/2)-r])
                circle(r=r);
        } else {
            translate([r, r])
                circle(r=r);
            translate([x-r, r])
                circle(r=r);
            translate([x-r, y-r])
                circle(r=r);
            translate([r, y-r])
                circle(r=r);
        }
    }
}

module rounded_square_perimeter(x, y, r, w) {
    difference() {
        rounded_square(x=x, y=y, r=r);
        rounded_square(x=x-2*w, y=y-2*w, r=r-w);
    }
}


module korry_outline(text="", text_right="", text_right_direction="ltr") {
    color("white")
    up(backplate_thickness)
    linear_extrude(outline_height)
    union() {
        translate([0, korry_width/2+outline_distance])
            text(text, size=2, halign="center");
        translate([korry_width/2+outline_distance+1, 0])
            text(text_right, size=2, halign="left", valign="center", direction=text_right_direction);
        rounded_square_perimeter(x=korry_width+outline_distance, y=korry_heigth+outline_distance, r=1, w=outline_width);
    }
}

module korry_hole() {
    color("grey")
    down(1)
    linear_extrude(backplate_thickness+2)
    rounded_square(x=korry_width+tolerance, y=korry_heigth+tolerance, r=1);
}

module switch_outline(text_top_1="", text_top_2="", text_right_up="", text_right="", text_right_down="", text_bottom="", text_right_direction="ltr") {
    color("white")
    up(backplate_thickness)
    linear_extrude(outline_height)
    union() {
        difference() {
            circle(d=switch_dia_big+outline_distance);
            circle(d=switch_dia_big+outline_distance-2*outline_width);
        }
        translate([0, switch_dia_big/2+outline_distance+3])
            text(text_top_1, size=2, halign="center");
        translate([0, switch_dia_big/2+outline_distance])
            text(text_top_2, size=2, halign="center");
        
        translate([switch_dia_big/2+outline_distance, switch_dia_big/2+outline_distance-5])
            text(text_right_up, size=2, halign="left", valign="center", direction=text_right_direction);
        translate([switch_dia_big/2+outline_distance, 0])
            text(text_right, size=2, halign="left", valign="center", direction=text_right_direction);
        translate([switch_dia_big/2+outline_distance, -(switch_dia_big/2+outline_distance-5)])
            text(text_right_down, size=2, halign="left", valign="center", direction=text_right_direction);
        
        translate([0, -switch_dia_big/2-outline_distance])
            text(text_bottom, size=2, halign="center", valign="top");
    }
}

module switch_hole() {
    color("grey") union() {
        down(1)
            cylinder(h=backplate_thickness+2, d=switch_dia+tolerance);
        up(1)
            cylinder(h=backplate_thickness, d=switch_dia_big);
    }
}

module pot_outline(text_top_1="", text_top_2="", text_bottom_left="", text_bottom_right="") {
    color("white")
    up(backplate_thickness)
    linear_extrude(outline_height)
    union() {
        translate([0, pot_dia_big/2+outline_distance+3])
            text(text_top_1, size=2, halign="center");
        translate([0, pot_dia_big/2+outline_distance])
            text(text_top_2, size=2, halign="center");

        translate([-pot_dia_big/2-outline_distance, -pot_dia_big/2-outline_distance])
            text(text_bottom_left, size=2, halign="center");
        translate([pot_dia_big/2+outline_distance, -pot_dia_big/2-outline_distance])
            text(text_bottom_right, size=2, halign="center");
        
        path = arc(r=pot_dia_big/2+outline_distance, angle=240, start=-30);
stroke(path, width=outline_width, endcap1="arrow2", endcap2="butt");

    }
}

module pot_hole() {
    color("grey") union() {
        down(1)
            cylinder(h=backplate_thickness+2, d=pot_dia+tolerance);
        up(1)
            cylinder(h=backplate_thickness, d=pot_dia_big);
    }
}

module line(from, to) {
    up(backplate_thickness)
    color("white")
    linear_extrude(outline_height)
    stroke([from, to], width=outline_width);
}

module label(text, size=2, halign="center", valign="center") {
        color("white")
        up(backplate_thickness)
        linear_extrude(outline_height)
        text(text, size=size, halign=halign, valign=valign);
}
