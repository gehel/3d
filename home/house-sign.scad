// House number sign.
//
// A flat plate with rounded corners, a raised border line, the house number
// and an arrow pointing up-left (north-west). Print it flat on the bed.
// Change filament at the layer where the raised parts start (see the echo in
// the console) to get the number, arrow and border in a second colour.

$fn = 96;

/* [Printer] */
bed_w = 250;           // Prusa MK3S
bed_h = 210;
bed_margin = 5;

/* [Plate] */
plate_w = 200;
plate_h = 110;
plate_t = 3;
corner_r = 12;

/* [Border] */
border_inset = 5;      // from the plate edge to the border line
border_w = 3;

/* [Raised parts] */
relief_h = 1;        // above the plate

/* [Number] */
number = "21";
number_size = 62;
number_font = "Liberation Sans:style=Bold";
number_x = 36;         // centre, from the plate centre

/* [Arrow] */
arrow_len = 78;        // tip to tail
arrow_head_len = 32;
arrow_head_w = 44;
arrow_shaft_w = 15;
arrow_round = 1.5;     // corner rounding
arrow_angle = 45;      // 0 = up, 45 = up-left (NW)
arrow_x = -54;         // centre, from the plate centre
arrow_y = 3;

/* [Mounting holes] */
mount_holes = true;
hole_inset = 15;       // from the plate edges to the hole centre
hole_d = 4.5;          // clearance for a 4 mm screw
hole_head_d = 8.5;     // countersink diameter at the surface

assert(plate_w <= bed_w - 2 * bed_margin && plate_h <= bed_h - 2 * bed_margin,
       "Plate does not fit on the bed");
assert((hole_head_d - hole_d) / 2 < plate_t, "Countersink is deeper than the plate");

echo(str("Colour change at Z = ", plate_t, " mm"));

module rounded_rect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

module border_2d() {
    outer_w = plate_w - 2 * border_inset;
    outer_h = plate_h - 2 * border_inset;
    outer_r = max(corner_r - border_inset, 0.01);
    difference() {
        rounded_rect(outer_w, outer_h, outer_r);
        offset(delta = -border_w) rounded_rect(outer_w, outer_h, outer_r);
    }
}

// Arrow pointing up, centred on the origin.
module arrow_2d() {
    l = arrow_len / 2;
    neck = l - arrow_head_len;
    offset(r = arrow_round) offset(delta = -arrow_round)
        polygon([
            [-arrow_shaft_w / 2, -l],
            [ arrow_shaft_w / 2, -l],
            [ arrow_shaft_w / 2, neck],
            [ arrow_head_w / 2, neck],
            [0, l],
            [-arrow_head_w / 2, neck],
            [-arrow_shaft_w / 2, neck],
        ]);
}

module number_2d() {
    text(number, size = number_size, font = number_font,
         halign = "center", valign = "center");
}

module plate() {
    linear_extrude(plate_t) rounded_rect(plate_w, plate_h, corner_r);
}

module relief() {
    translate([0, 0, plate_t])
        linear_extrude(relief_h) {
            border_2d();
            translate([arrow_x, arrow_y]) rotate(arrow_angle) arrow_2d();
            translate([number_x, 0]) number_2d();
        }
}

// Countersunk holes, one in each corner.
module mounting_holes() {
    cs_depth = (hole_head_d - hole_d) / 2;
    for (x = [-1, 1], y = [-1, 1])
        translate([x * (plate_w / 2 - hole_inset), y * (plate_h / 2 - hole_inset), 0]) {
            translate([0, 0, -1]) cylinder(d = hole_d, h = plate_t + relief_h + 2);
            translate([0, 0, plate_t - cs_depth])
                cylinder(d1 = hole_d, d2 = hole_head_d + 0.02, h = cs_depth + 0.01);
        }
}

difference() {
    union() {
        plate();
        relief();
    }
    if (mount_holes) mounting_holes();
}
