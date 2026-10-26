// Bag tag label.
//
// A flat plate with rounded corners and raised text. Print it flat on the
// bed. Change filament at the layer where the text starts to get two colours.

$fn = 64;

/* [Plate] */
plate_w = 67;
plate_h = 45;
plate_t = 1;
corner_r = 5;

/* [Text] */
lines = ["Augustin", "Lederrey", "076 573 32 40"];
text_sizes = [7, 7, 5.5];
text_font = "Liberation Sans:style=Bold";
text_h = 0.6;          // raised above the plate
line_spacing = 10;     // between baselines

module rounded_rect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

module plate() {
    linear_extrude(plate_t) rounded_rect(plate_w, plate_h, corner_r);
}

module label_text() {
    n = len(lines);
    translate([0, 0, plate_t])
        linear_extrude(text_h)
            for (i = [0 : n - 1])
                translate([0, ((n - 1) / 2 - i) * line_spacing])
                    text(lines[i], size = text_sizes[i], font = text_font,
                         halign = "center", valign = "center");
}

plate();
label_text();
