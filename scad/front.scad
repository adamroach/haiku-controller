$fn = 20;

proto_height = 70;
proto_width = 30;
proto_thickness = 1.65;
proto_mounting_hole_diameter = 2;
proto_mounting_hole_x_spacing = proto_width - proto_mounting_hole_diameter - 2;
proto_mounting_hole_y_spacing = proto_height - proto_mounting_hole_diameter - 2;

// PCB-mounted buttons
pcb_switch_out_thickness = 4.96;
pcb_switch_in_thickness = 4.68;
pcb_switch_throw = pcb_switch_out_thickness - pcb_switch_in_thickness;
pcb_switch_square = 6.2;
pcb_switch_diameter = 3.45;
pcb_switch_body_height = 3.87;

// Dimensions for Decora-style devices
decora_screw_spacing = 96.8;
decora_hole_height = 66.8;
decora_hole_width = 33.2;
decora_hole_roundness = 1.0;
decora_switch_depth = 5.6;
outlet_box_screw_spacing = 83.34375;
screw_head_top_diameter = 0.262 * 25.4;
screw_head_bottom_diameter = 0.138 * 25.4;
screw_head_countersink = 0.138 * 25.4;

// M2 screws used to mount to electronics, plus 0.4mm tolerance
screwhead_diameter = 3.6 + 0.4;

//front_components(8, pivot=false, leds=true);
//front_components(1);
//front_components(2);

module front_components(hole_count, pivot=true, leds=false) {
    hole_divider = 2;
    hole_width = 27.5 - (leds?(2.54*3):0);
    vertical = (hole_count == 1?true:false);
    hole_height = (decora_hole_height - (vertical?2:0) - (hole_divider * (hole_count-1)) - 8) / hole_count;

    //////////////////////////////////////////////////////////////////////
    // Draw the frame and ghost in the other components
    group() {
        frame(hole_width, hole_height, hole_count, hole_divider, pivot, vertical, (leds?2.54*1.5:0));
        *%for(y=[-(hole_count-1)/2:1:(hole_count-1)/2])
            translate([0,y*(hole_height + hole_divider),0])
                switch(hole_width, hole_height, pivot, vertical);
        *%pivot();
        *electronics(hole_count, pivot, leds=leds);
        *color("white") decora_single();
    }

    //////////////////////////////////////////////////////////////////////
    // Draw the pivot
    if (pivot) {
        translate([decora_hole_width,0,0]) pivot(length=vertical?decora_hole_width:decora_hole_height);
    }

    //////////////////////////////////////////////////////////////////////
    // Draw switches
    for (x=[0:1:(hole_count-2)/2],y=[-decora_hole_height/4-2,decora_hole_height/4+2])
        translate([-decora_hole_width/1.5 - x*pcb_switch_out_thickness*1.5,y,(vertical?hole_width:hole_height)/2]) 
            rotate([90,vertical?90:0,-90]) switch(hole_width, hole_height, pivot, vertical);
    
    if (hole_count % 2) {
        translate([-decora_hole_width/1.5 - (hole_count/2)*pcb_switch_out_thickness*1.5,0,
                    (vertical?hole_width:hole_height)/2])
            rotate([90,vertical?90:0,-90]) switch(hole_width, hole_height, pivot, vertical);
    }
}

//////////////////////////////////////////////////////////////////////
// Debugging: draw a switch and the two buttons in the correct position
//!group() {switch(); for (x=[-3.5 * 2.56, 3.5*2.6]) translate([x,0,0]) pcb_button();}

module electronics(hole_count, pivot=true, gap=0, leds=false) {
    // If gap is set, this just creates volumes for the switches to fit into.
    // This is used to slice out notches in the faceplate.
    if (!gap)
        color("green") translate([0,0,-proto_thickness/2+0.1]) rotate([90,0,0]) proto_board(true);
    spacing = floor(25 / hole_count);
    xrange = (pivot?[-3.5,3.5]:[(leds?-1.5:-0.5)]);
    for (x=xrange, y=[-((hole_count-1)/2):1:((hole_count-1)/2)]){
        translate([x*2.54,(floor(y*spacing)+0.5)*2.54,0]) {
            if (gap) {
                translate([0,0,(pcb_switch_out_thickness+gap)/2])
                    cube([pcb_switch_square+gap*2,pcb_switch_square+gap*2,pcb_switch_out_thickness+gap],
                    center=true);
            } else {
                pcb_button();
            }

        }
    }
    if (leds) {
        for (y=[-((hole_count-1)/2):1:((hole_count-1)/2)]){
            translate([4*2.54,y*spacing*2.54,0]){
                led(gap=gap, color=(gap?undef:"red"));
                if(gap) cylinder(h=decora_switch_depth*2, d=2);
            }
        }
    }

}

module pivot(truncate=true, spacing=0, length=decora_hole_height) {
    rotate([90,0,0]) {
        difference() {
            translate([0,-pcb_switch_throw/2,0])
                cylinder(h=length-2-0.8+spacing*2,
                         r=pcb_switch_out_thickness+spacing,
                         center=true);
            if (truncate) {
                translate([0,-pcb_switch_out_thickness,0])
                    cube([pcb_switch_out_thickness*2,
                          pcb_switch_out_thickness*2,
                          length], center=true);
            }
        }
    }
}


module frame(hole_width, hole_height, hole_count, hole_divider, pivot, vertical, hole_offset) {
    gap = 0.8; // 0.4 on each side
    difference() {
        decora_filler();
        for(x=[-proto_mounting_hole_x_spacing/2,proto_mounting_hole_x_spacing/2],
            y=[-proto_mounting_hole_y_spacing/2,proto_mounting_hole_y_spacing/2]) {
            translate([x,y,0]) {
                cylinder(h=decora_switch_depth*3,d=proto_mounting_hole_diameter, center=true);
                translate([0,0,1]) cylinder(h=decora_switch_depth*3,d=screwhead_diameter, center=false);
            }
        }
        translate([-hole_offset,0,0]) {
            for(y=[-(hole_count-1)/2:1:(hole_count-1)/2]) {
                translate([0,y*(hole_height + hole_divider),0]) {
                    cube([hole_width+gap, hole_height+gap, decora_switch_depth*3], center=true);
                    cube([hole_width+(vertical?0:3)+gap,
                        hole_height+(vertical?3:0)+gap,
                        decora_switch_depth*2], center=true);
                }

            }
            
            if (pivot) {
                if (vertical) {
                    rotate([0,0,90]) pivot(false, 0.4, decora_hole_width);
                } else {
                    pivot(false,0.4);
                }
            }
        }
        electronics(hole_count, pivot, gap/2, leds=hole_offset);
    }
}


module switch(hole_width, hole_height, rocker=true, vertical=false) {
    curve = vertical?440:100;

    intersection() {
        difference() {
            group() {
                cube([hole_width, hole_height, decora_switch_depth*3], center=true);
                cube([hole_width+(vertical?0:3),
                      hole_height+(vertical?3:0),
                      decora_switch_depth*2-(rocker?0.8:0)], center=true);
            }
            cube([hole_width-(vertical?-1:2.5),hole_height-(vertical?2.5:-1),pcb_switch_out_thickness*2+0.1],center=true);
            cube([hole_width*2,hole_height*2,pcb_switch_out_thickness*2-4],center=true);
            // Cut off everything below the Z plane
            translate([0,0,-decora_switch_depth*5])
                cube([hole_width*2,hole_height*2,decora_switch_depth*10], center=true);
            
            // Curve the front face
            if (rocker) {
                translate([0,0,decora_switch_depth*1.5 + curve/2 - 1.8])
                    rotate([90,0,vertical?90:0])
                        cylinder(h=hole_height*2,d=curve, center=true,$fn=1000);
            }
        }
        if (!rocker) {
            translate([0,0,-curve/2 + decora_switch_depth*1.5])
                rotate([90,0,0])
                    cylinder(h=hole_height*2,d=curve, center=true,$fn=1000);
        }
    }
}

module pcb_button() {
    leads = 2.5;
    color("silver") translate([0,0,pcb_switch_body_height/2])
        cube([pcb_switch_square,pcb_switch_square,pcb_switch_body_height],center=true);
    color("black") cylinder(h=pcb_switch_out_thickness, d=pcb_switch_diameter);
    color("silver") for(x=[-pcb_switch_square/2+0.5,pcb_switch_square/2-0.5])
            translate([x,0,-leads]) cylinder(h=leads,d=1);
    
}

// 3mm LED model
module led(color="red", gap=0) {
    leads = 2.5;
    d = 3 + gap*2;
    base_d = 3.74 + gap*2;
    base_h = 1 + gap;
    total_h = base_h + 4.49;
    
    color(color) {
        cylinder(d=base_d,h=base_h);
        translate([0,0,total_h - (d/2)]) sphere(d=d);
        cylinder(d=d, h=total_h-d/2);
    }
    color("silver") for(x=[-2.54/2,2.54/2])
            translate([x,0,-leads]) cylinder(h=leads,d=1);   
}

module proto_board(holes=false) {
    difference() {
        cube([proto_width, proto_thickness, proto_height],center=true);
        if (holes){
            for(x=[-4.5:1:4.5],z=[-11.5:1:11.5]) {
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

module decora_filler() {
    switch_filler(decora_screw_spacing,
                  decora_hole_height-0.8,
                  decora_hole_width-0.8,
                  decora_hole_roundness);
}

module switch_filler(spacing, hole_h, hole_w, roundness=0) {
    height = 114.3;
    depth = 6.56;
    thickness = 2.6;
    blank_thickness = 2;

    difference() {
        group() {
            hull()
                for(x=[-hole_w/2+roundness,hole_w/2-roundness],y=[-hole_h/2+roundness,hole_h/2-roundness])
                    translate([x,y,0]) cylinder(r=roundness,h=depth);
            translate([0,0,blank_thickness/2])
            cube([hole_w*1.2,height-thickness*4,blank_thickness],center=true);
        }
        for(y=[-outlet_box_screw_spacing/2,outlet_box_screw_spacing/2])
            hull() for(x=[-1.5,1.5]) {
                translate([x,y,blank_thickness-screw_head_countersink/2])
                    cylinder(d1=screw_head_bottom_diameter, d2=screw_head_top_diameter, 
                            h=screw_head_countersink, center=true);
            }
            
        for(y=[-spacing/2,spacing/2])
            translate([0,y,0]) cylinder(d=screw_head_bottom_diameter,h=blank_thickness*3,center=true);
    }
}
