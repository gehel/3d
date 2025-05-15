use <BOSL2/std.scad>

$fn=200;

dia = 37;
width = .8;
height = 20;
bottom = .6;
rounding = 6;

module hex() {
  difference() {
    linear_extrude(height)
      hexagon(id=dia + 2*width, rounding=rounding+width);
    translate([0, 0, bottom])
      linear_extrude(height)
      hexagon(id=dia, rounding=rounding);
  }
}

module hex_3(n) {
  for (i = [0:1:n-1]) {
    translate([0, i*(dia + width), 0])
      hex();
  }
}

hex_3(3);
translate([cos(30)*(dia+width), -cos(60)*(dia+width), 0])
  hex_3(4);
translate([2*cos(30)*(dia+width), , 0])
  hex_3(3);