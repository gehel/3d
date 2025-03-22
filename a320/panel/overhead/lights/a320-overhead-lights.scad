include <../../commons/panels.scad>


panel_x=310;
panel_y=130;

line1=20;
line2=60;
line3=100;

$fn=100;

difference() {
    color("grey")
    linear_extrude(backplate_thickness)
    rounded_square(x=panel_x, y=panel_y, r=3, center=false  );
    
    translate([20, line3])
        korry_hole();
    translate([80, line3])
        korry_hole();
    translate([110, line3])
        korry_hole();
    
    translate([150, line3])
        korry_hole();

    translate([190, line3])
        switch_hole();
    translate([220, line3])
        korry_hole();
    translate([250, line3])
        pot_hole();
    translate([280, line3])
        korry_hole();
    
    
    translate([20, line2])
        switch_hole();
    translate([50, line2])
        switch_hole();
    translate([80, line2])
        switch_hole();
    translate([110, line2])
        switch_hole();

    translate([150, line2])
        korry_hole();

    translate([190, line2])
        pot_hole();
    translate([220, line2])
        switch_hole();
    translate([250, line2])
        switch_hole();
    translate([280, line2])
        switch_hole();



    translate([20, line1])
        switch_hole();
    translate([50, line1])
        switch_hole();
    translate([80, line1])
        switch_hole();
    translate([110, line1])
        switch_hole();

    translate([150, line1])
        korry_hole();
        
    translate([190, line1])
        switch_hole();
    translate([220, line1])
        switch_hole();

    translate([250, line1])
        korry_hole();
    translate([280, line1])
        switch_hole();
}

line([5, panel_y-25], [5, 25]);
line([panel_x-5, panel_y-25], [panel_x-5, 25]);

translate([65, line3+20])
    label("ANTI ICE", size=3);

translate([20, line3])
    korry_outline("WING");

line([35, 110], [35, 90]);

line([65, 110], [65, 90]);

translate([80, line3])
    korry_outline("ENG 1");
translate([110, line3])
    korry_outline("ENG 2");

line([125, 110], [125, 90]);

translate([150, line3+20])
    label("PROBE/WINDOW", size=3);
translate([150, line3+15])
    label("HEAT", size=3);

translate([150, line3])
    korry_outline(
        text_right="AUTO",
        text_right_direction="ttb");

line([175, 110], [175, 90]);

translate([220, line3+20])
    label("CABIN PRESS", size=3);

translate([190, line3])
    switch_outline(
        text_top_1="MAN V/S CTL",
        text_right_up="UP",
        text_right_down="DN");
translate([220, line3])
    korry_outline(
        text="MODE SEL",
        text_right="AUTO",
        text_right_direction="ttb");
translate([250, line3])
    pot_outline(
        text_top_1="LDG ELEV",
        text_top_2="AUTO");
translate([280, line3])
    korry_outline(text="DITCHING");

line([10, 83], [panel_x-10, 83]);

translate([65, line2+20])
    label("EXT LT", size=3);

translate([20, line2])
    switch_outline(
        text_top_1="STROBE",
        text_top_2="ON",
        text_right="AUTO",
        text_bottom="OFF",
        text_right_direction="ttb");
translate([50, line2])
    switch_outline(
        text_top_1="BEACON",
        text_top_2="ON",
        text_bottom="OFF");
translate([80, line2])
    switch_outline(
        text_top_1="WING",
        text_top_2="ON",
        text_bottom="OFF");
translate([110, line2])
    switch_outline(
        text_top_1="NAV & LOGO",
        text_top_2="2",
        text_right="1",
        text_bottom="OFF");

line([132, 80], [132, 5]);

translate([150, line2+20])
    label("APU", size=3);

translate([150, line2])
    korry_outline("MASTER SW");

line([168, 80], [168, 5]);

translate([235, line2+20])
    label("INT LT", size=3);

translate([190, line2])
    pot_outline(
        text_top_1="OVHD INTEG LT",
        text_bottom_left="OFF",
        text_bottom_right="BRT");
translate([220, line2])
    switch_outline(
        text_top_1="ICE IND &",
        text_top_2="STBY COMPASS",
        text_bottom="OFF");
translate([250, line2])
    switch_outline(
        text_top_2="DOME",
        text_right_up="BRT",
        text_right="DIM",
        text_right_down="OFF");
translate([280, line2])
    switch_outline(
        text_top_2="ANN LT",
        text_right_up="TEST",
        text_right="BRT",
        text_right_down="DIM");


translate([20, line1])
    switch_outline(
        text_top_1="RUNWAY TURN OFF",
        text_top_2="ON",
        text_bottom="OFF");

line([37, 37], [58, 37]);
line([37, 37], [37, 35]);

translate([65, 37])
    label(text="LAND");

line([72, 37], [93, 37]);        
line([93, 37], [93, 35]);        

translate([50, line1])
    switch_outline(text_top_2="L");
translate([80, line1])
    switch_outline(text_top_2="R");
translate([110, line1])
    switch_outline(
        text_top_2="NOSE",
        text_right_up="T.O",
        text_right="TAXI",
        text_right_down="OFF");

translate([150, line1])
    korry_outline("START");

line([175, 43], [panel_x-10, 43]);

translate([242, line1+20])
    label("SIGNS", size=3);

translate([190, line1])
    switch_outline(
        text_top_1="SEAT BELTS",
        text_top_2="ON",
        text_bottom="OFF");
translate([220, line1])
    switch_outline(
        text_top_1="NO SMOKING",
        text_top_2="ON",
        text_right="AUTO",
        text_bottom="OFF",
        text_right_direction="ttb");

line([237, 35], [237, 5]);

translate([265, line1+13])
    label("EMER EXT LT");

translate([250, line1])
    korry_outline();
translate([280, line1])
    switch_outline(
        text_right_up="ON",
        text_right="ARM",
        text_right_down="OFF");
