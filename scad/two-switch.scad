include <front.scad>
front_components(2);

include <cage.scad>
translate([38,0,depth/2+1.85]) rotate([0,0,90]) draw_cage();
