$fn=20;

// I couldn't find published dimensions for outlet box interiors, but this is what I measured.
max_height=72.5-1;
max_width=45; // measured as 49.15
max_depth=42;

proto_thickness = 1.65;
proto_height = 70;
proto_width = 30;
proto_mounting_hole_diameter = 2 - 0.2;
proto_mounting_hole_x_spacing = proto_width - proto_mounting_hole_diameter - 2;
proto_mounting_hole_y_spacing = proto_height - proto_mounting_hole_diameter - 2;

pi_thickness = 1.5;
pi_height = 66;
pi_width=30;
pi_total_thickness = 5;
pi_mounting_hole_diameter = proto_mounting_hole_diameter;
pi_mounting_hole_y_spacing = 58;
pi_mounting_hole_x_spacing = 23;

/*
// RAC15-05SK
power_thickness = 23;
power_height = 52.6;
power_width = 27.5;
*/

// HLK-PM01
power_thickness = 15;
power_height = 34;
power_width = 20;

wall=2;
board_gap = 5;
depth = power_thickness + proto_thickness*2 + pi_total_thickness + board_gap + wall;

front_board_depth = -depth/2-wall/2;
pi_depth = -depth/2-wall/2 + board_gap;
back_board_depth = pi_depth + pi_total_thickness + board_gap + power_thickness;


//draw_cage();

module draw_cage() {
    rotate([0,-90,0]) {
        intersection() {
            cage();
            rotate([0,90,0]) cube([max_height,max_depth,max_width],center=true);
        }

        // Uncomment to ghost in components
        *group() {
            %translate([0,front_board_depth,0]) proto_board();
            %translate([0,pi_depth,/*-proto_height+pi_height*/0]) rotate([-90,90,0]) PiZeroBody();
            %translate([0,pi_depth,0]) cube([pi_width,pi_thickness,pi_height],center=true);
            %translate([0,back_board_depth,0]) proto_board();
            %translate([0,back_board_depth - power_thickness/2 - proto_thickness/2,0])
                cube([power_width,power_thickness,power_height],center=true);
        }

        // Uncomment to draw representative electronic components
        *group() {
            color("green") translate([0,front_board_depth,0]) proto_board(true);
            translate([0,pi_depth+pi_total_thickness/2.5,0]) rotate([-90,90,0])
                difference(){
                    group() {
                        color("green") zero(pi_total_thickness, 3.5);
                    }
                    pi_holes(pi_total_thickness+1, 1);
            }
            color("green") translate([0,back_board_depth,0]) proto_board(true);
            color("gray") translate([0,back_board_depth - power_thickness/2 - proto_thickness/2,0])
                cube([power_width,power_thickness,power_height],center=true);
                for (x=[-3.5 * 2.56, 3.5*2.6], z=[-6 * 2.56, 6 * 2.56])
                    translate([x,front_board_depth-proto_thickness/2,z]) rotate([90,0,0]) pcb_button();
        }

    }
}

module proto_board(holes) {
    difference() {
        cube([proto_width, proto_thickness, proto_height],center=true);
        if (holes){
            for(x=[-4.5:1:4.5],z=[-12:1:12]) {
                translate([x*2.54,0,z*2.54]) rotate([90,0,0])
                    cylinder(h=proto_thickness*2,d=1, center=true);
            }
        }

        for(x=[-proto_mounting_hole_x_spacing/2,proto_mounting_hole_x_spacing/2],
            z=[-proto_mounting_hole_y_spacing/2,proto_mounting_hole_y_spacing/2]) {
                translate([x,0,z]) rotate([90,0,0])
                    cylinder(h=proto_thickness*2,d=proto_mounting_hole_diameter, center=true);
        }

  }
}

module cage() {
    gap = back_board_depth-pi_depth-2*wall-pi_thickness-proto_thickness + 4;
    difference() {
        cube([proto_width+wall*2, depth + wall*2, proto_height+wall*2],center=true);
        cube([proto_width, depth + wall*3, proto_height],center=true);
        translate([wall*2,0,0]) cube([proto_width, depth + wall*3, proto_height],center=true);
        //cube([proto_width, depth, proto_height+wall*3],center=true);
        //cube([proto_width + wall*3, depth, proto_height],center=true);

        translate([-wall*2,0,0]) cube([proto_width,gap,proto_height],center=true);
        translate([wall*3,0,0]) cube([proto_width,gap,proto_height+wall*3],center=true);
    }

    // Reinforce the side rails
    for(z=[-proto_height/2,proto_height/2])
        translate([-proto_width/2+4-wall,0,z]) cube([8,gap+2,2],center=true);

    // Tabs for mounting boards
    translate([0,front_board_depth+proto_thickness,0]) proto_tabs();

    // Power supply board should just slide in.
    difference() {
        group() {
            translate([0,back_board_depth-proto_thickness-0.4,0]) proto_tabs();
            translate([0,depth/2+wall/2,0]) proto_tabs();
        }
        cube([proto_width+wall*3,depth*2,proto_height-8],center=true);
    }

    difference() {
        translate([0,pi_depth-pi_thickness,0]) pi_tabs();
        cube([proto_width+wall*3,depth*2,pi_height-14],center=true);
    }
}

module proto_tabs() {
        difference() {
        cube([proto_width + wall*2, wall, proto_height + wall*2],center=true);
        for(x=[-proto_mounting_hole_x_spacing/2,proto_mounting_hole_x_spacing/2],
            z=[-proto_mounting_hole_y_spacing/2,proto_mounting_hole_y_spacing/2]) {
                translate([x,0,z]) rotate([90,0,0])
                    cylinder(h=proto_thickness*2,d=proto_mounting_hole_diameter, center=true);

        }
        cube([proto_width+wall*3,depth*2,proto_height-8],center=true);

        cutout = proto_height * 0.87;
        // rotate([0,45,0]) cube([cutout, wall*2, cutout],center=true);
    }
}

module pi_tabs() {
    difference() {
        cube([proto_width + wall*2, wall, proto_height + wall*2],center=true);
        for(x=[-pi_mounting_hole_x_spacing/2,pi_mounting_hole_x_spacing/2],
            z=[-pi_mounting_hole_y_spacing/2,pi_mounting_hole_y_spacing/2]) {
                translate([x,0,z]) rotate([90,0,0])
                    cylinder(h=proto_thickness*2,d=proto_mounting_hole_diameter, center=true);
         }

        // Leave room for the prototype board screws
        for(x=[-proto_mounting_hole_x_spacing/2,proto_mounting_hole_x_spacing/2],
            z=[-proto_mounting_hole_y_spacing/2,proto_mounting_hole_y_spacing/2]) {
                translate([x,0,z]) rotate([90,0,0])
                    cylinder(h=proto_thickness*2,d=proto_mounting_hole_diameter, center=true);
        }

        cutout = pi_height * 0.8;
        //rotate([0,45,0]) cube([cutout, wall*2, cutout],center=true);
    }
}

module pcb_button() {
    leads = 5;
    pcb_switch_out_thickness = 4.96;
    pcb_switch_in_thickness = 4.68;
    pcb_switch_throw = pcb_switch_out_thickness - pcb_switch_in_thickness;
    pcb_switch_square = 6.2;
    pcb_switch_diameter = 3.45;
    pcb_switch_body_height = 3.87;
    color("silver") translate([0,0,pcb_switch_body_height/2])
        cube([pcb_switch_square,pcb_switch_square,pcb_switch_body_height],center=true);
    color("black") cylinder(h=pcb_switch_out_thickness, d=pcb_switch_diameter);
    color("silver") for(x=[-pcb_switch_square/2+0.5,pcb_switch_square/2-0.5])
            translate([x,0,-leads/2]) cylinder(h=leads,d=1);

}

// This could be much more refined, but the idea here is to show the
// total space occupied, not to place individual pi components.
module zero(height, corner_radius) {
    hull() pi_holes(height, corner_radius);
}

module pi_holes(height, radius) {
    x_distance = 29;
    y_distance = 23/2;

    for (x=[-x_distance,x_distance])
        for(y=[-y_distance,y_distance])
            translate([x,y,0])
                cylinder(h=height, r=radius, center=true);
}
