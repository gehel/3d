// Kote drying support.
//
// A round base holds embedded magnets and sticks to the side of a metal
// cupboard. A perforated tube leaves the base at 45 deg, pointing up and away
// from the wall; the kote slides over it, is held open, and dries.
//
// Print one per kote, base flat on the bed, no support: at tube_angle = 45 the
// underside of the tube is exactly at the printable overhang limit, and the
// gusset, the bore floor and the tip chamfer are all shaped to stay within it.
// Raising tube_angle past 45 means printing with supports.

$fn = 96;
$fs = 0.4;

/* [Base] */
base_d = 110;          // wide enough to give the magnets some leverage
base_h = 5;
base_chamfer = 1.5;    // on the outer top edge

/* [Magnets] */
magnet_d = 8;         // neodymium discs, N42 or better
magnet_h = 3;
magnet_tol = 0.2;      // added to the diameter for a slip fit
magnet_count = 12;
magnet_cover = 0.4;    // material left between magnet and cupboard
magnet_margin = 3;     // between pocket and base edge
magnet_angle = 45;     // ring offset, keeps the pockets clear of the gusset
// true:  pockets open on the outer face, glue the magnets in.
// false: pockets are closed, drop the magnets in during a print pause.
magnet_pocket_open = false;

/* [Tube] */
tube_od = 50;
tube_wall = 2;
tube_len = 190;        // along the axis, from the base centre
tube_angle = 45;       // from the wall normal
root_h = 10;           // solid plug at the foot of the tube
tip_chamfer = 1.5;
drain_d = 6;           // empties the bore floor through the lower wall

/* [Air holes] */
hole_d = 12;
hole_pitch = 26;       // along the tube axis
hole_count = 6;        // per ring
hole_first = 40;       // first ring, along the axis from the base centre
hole_tip_margin = 14;  // keep the last ring clear of the tip

/* [Gusset] */
gusset = false;
gusset_len = 12;       // up along the tube
gusset_reach = 14;     // out along the base, past the tube footprint
gusset_t = 5;

// ---------------------------------------------------------------------------

tube_id = tube_od - 2 * tube_wall;
// Where the underside of the tube crosses the base plane, on the +X side.
// Also the half-width of the tube footprint, which is an ellipse.
tube_foot_x = (tube_od / 2) / cos(tube_angle);
n_rings = max(0, floor((tube_len - hole_tip_margin - hole_first) / hole_pitch) + 1);
big = 2 * (tube_len + base_d);

echo(str("tube footprint: ", 2 * tube_foot_x, " x ", tube_od, " mm on a ", base_d, " mm base"));
echo(str("hole rings: ", n_rings));

// Places a cylinder on the tube axis, from..to measured along that axis from
// the base centre.
module along_tube(d, from, to) {
  rotate([0, tube_angle, 0])
    translate([0, 0, from])
      cylinder(h = to - from, d = d);
}

// Everything at z < h, used to trim the model at the wall and to floor the bore.
module below(h) {
  translate([0, 0, h - big / 2])
    cube([big, big, big], center = true);
}

module base_disc() {
  r = base_d / 2;
  rotate_extrude()
    polygon([
      [0, 0],
      [r, 0],
      [r, base_h - base_chamfer],
      [r - base_chamfer, base_h],
      [0, base_h],
    ]);
}

// Triangular buttress under the tube, on the side the kote tries to lever off
// the wall. Extruded along Y so every face is vertical and it needs no
// support. Its inner edge is sunk into the tube wall by `ov` so the two weld
// together instead of meeting at a tangent.
module gusset_rib() {
  ov = tube_wall;
  a = tube_angle;
  rotate([90, 0, 0])
    translate([0, 0, -gusset_t / 2])
      linear_extrude(gusset_t)
        polygon([
          [tube_foot_x - ov, 0],
          [tube_foot_x + gusset_len * sin(a) - ov * cos(a), gusset_len * cos(a) + ov * sin(a)],
          [tube_foot_x + gusset_reach, 0],
        ]);
}

module magnet_pockets() {
  d = magnet_d + magnet_tol;
  r = base_d / 2 - magnet_margin - d / 2;
  depth = magnet_pocket_open ? base_h - magnet_cover + 0.1 : magnet_h + magnet_tol;
  for (i = [0 : magnet_count - 1])
    rotate([0, 0, magnet_angle + i * 360 / magnet_count])
      translate([r, 0, magnet_cover])
        cylinder(h = depth, d = d);
}

// Each cylinder is drilled straight through the tube, so it makes two holes.
// Alternate rings are staggered, so no line of holes runs down the tube.
module air_holes() {
  rotate([0, tube_angle, 0])
    for (i = [0 : n_rings - 1])
      translate([0, 0, hole_first + i * hole_pitch])
        for (j = [0 : hole_count - 1])
          rotate([0, 0, j * 360 / hole_count + (i % 2) * 180 / hole_count])
            rotate([0, 90, 0])
              cylinder(h = tube_od + 2, d = hole_d, center = true);
}

// The bore is floored at root_h, which makes a cup. Let it out through the
// lower wall, level with that floor.
module drain_hole() {
  translate([0, 0, root_h + drain_d / 2 + 0.2])
    rotate([0, 90, 0])
      cylinder(h = big, d = drain_d);
}

module tip_chamfers() {
  rotate([0, tube_angle, 0])
    translate([0, 0, tube_len - tip_chamfer]) {
      // outer edge
      difference() {
        cylinder(h = tip_chamfer + 0.01, d = tube_od + 4);
        cylinder(h = tip_chamfer + 0.01, d1 = tube_od, d2 = tube_od - 2 * tip_chamfer);
      }
      // inner edge
      cylinder(h = tip_chamfer + 0.01, d1 = tube_id, d2 = tube_id + 2 * tip_chamfer);
    }
}

module kote_support() {
  difference() {
    difference() {
      union() {
        base_disc();
        along_tube(tube_od, -base_d, tube_len);
        if (gusset) gusset_rib();
      }
      below(0);  // trim off everything behind the wall
    }

    difference() {
      along_tube(tube_id, -base_d, tube_len + 1);
      below(root_h);
    }
    drain_hole();
    air_holes();
    tip_chamfers();
    magnet_pockets();
  }
}

kote_support();
