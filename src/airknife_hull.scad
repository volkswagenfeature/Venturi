include <parametrization.scad>


// Construct a basic outline of the airknife
module airknife_shadow(hlf_a,p_rad)
{
    union()
    {
        circle(r=p_rad);
        polygon([
            [p_rad*cos(hlf_a),p_rad*sin(hlf_a)],
            [-p_rad*cos(hlf_a),p_rad*sin(hlf_a)],
            [0,p_rad/sin(hlf_a)]
            ]);
    }
}


// Hollow out the outline created by airknife_shadow, and open a nozzle for the jet
module airknife_section( t_aks ){
    pipe_d = t_aks[md_taks];
    shell_th = t_aks[sh_taks];
    nozzle_gap = t_aks[ng_taks];
    nozzle_angle = t_aks[na_taks];
    
    hlf_a = nozzle_angle/2;
    difference()
    {
        airknife_shadow(hlf_a,pipe_d/2+shell_th);
        airknife_shadow(hlf_a,pipe_d/2);
        translate([-nozzle_gap/2,0,0]) square([nozzle_gap,
        pipe_d/2/sin(hlf_a)+shell_th/sin(hlf_a)]);
    }
}


// Take a outline, and rotate it to form a torus, with a given tilt and size.
module ak_maketoroid(
    t_aks,
    sections = $fn
){
    rotate_extrude(convexity=6, $fn=sections)
    translate([t_aks[Md_taks]/2,-aks_miny(t_aks()),0])
    rotate([0,0,t_aks[ta_taks]]) 
    children(0);
}


// get y value at the pointy end of the ak section
// side determines which "prong" is used.
// -1 for the one on the -x side, 1 for the one on the +x side
// 0 for centered.
function aks_miny(t_aks,side=1) = 
 cos(t_aks[ta_taks])*(
 t_aks[md_taks]/2/sin(t_aks[na_taks]/2)+
 t_aks[sh_taks]/sin(t_aks[na_taks]/2)-
 t_aks[ng_taks]/2/tan(t_aks[na_taks]/2)
 )+sin(t_aks[ta_taks])*t_aks[ng_taks]/2*side;

function y_dir(angle) = (cos(angle)==0)? 0 : cos(angle)>0 ? 1 : -1;


// Add a flat top to the torus, to help with resin printing.
// pipe_dia, shell_th, and angle are from t_aks
// height is the distance from the bottom of the arc to the bottom of the shape.
// top_width is the width of the contact point with the profile shape
// bottom_width is the width of the contact point with the printer base
module ak_base(
    t_aks,
    height = 1,
    top_width = 10,
    bottom_width = 10
){
    function cir(x,r) = sqrt(pow(r,2)-pow(x,2));
    rad = t_aks[md_taks]/2 + t_aks[sh_taks];
    top = -cir(top_width/2,rad);
    mir = 90-90*y_dir(t_aks[ta_taks]);
    vertexes = [[top_width/2,top],[-top_width/2,top],
                [-bottom_width/2,-(rad+height)],
                [bottom_width/2,-(rad+height)]];
    
    union(){
        children(0);
        rotate([0,0,mir-t_aks[ta_taks]])
        translate([0,0,0])
        difference(){
            polygon(vertexes,[[0,1,2,3,4]]);
            circle(rad-0.5 * t_aks[sh_taks]);
            
        }    
    }
    
    
}

// Add a flat bottom, for building the rest of the airknife from.
// Currently broken for angles between + and - 90 deg.
// TODO change so side can be autocalculated.
module ak_side_support(
    t_aks,
    flat_dist=10,
    side = -1
){
    theta = t_aks[ta_taks]-90;
    hlf_a = t_aks[na_taks]/2;
    y_loc = t_aks[md_taks]/2/sin(hlf_a)+
            t_aks[sh_taks]/sin(hlf_a)-
            t_aks[ng_taks]/2/tan(hlf_a);
    /*
    translate([0,y_loc,0])
    color("blue",.5)
    square(5);
    */
    
    tippoint = [side*t_aks[ng_taks]/2,y_loc];
    vertexes = [tippoint,
                tippoint+flat_dist*side*[sin(theta),cos(theta)],
                [side*(t_aks[md_taks]+t_aks[sh_taks])/2,0]];

    union(){
        children(0);
        polygon(vertexes,[[0,1,2]]);
    }
}

// Takes a toroid parameter set, and 
// prepares a "skirt" before the programmed 
// throat pattern
// support_width: width of the support above this. Negative number assumes no support
// Rake: +/- this many degrees from nozzle angle
// height: height of the skirt component
module skirt(
    t_aks,
    support_width = 10,
    rake = 0,
    height = 10,
    side = -1,
    segments = $fn
){
    len_ak_profile =
    t_aks[md_taks]/2/sin(t_aks[na_taks]/2)+
    t_aks[sh_taks]/sin(t_aks[na_taks]/2)-
    t_aks[ng_taks]/2/tan(t_aks[na_taks]/2);
    
    len_nozzle_gap = t_aks[ng_taks]/2;
    
    x_displacement = 
    sin(t_aks[ta_taks])*len_ak_profile - 
    cos(t_aks[ta_taks])*side*len_nozzle_gap ;
    
    
    refpoint = [t_aks[Md_taks]/2-x_displacement,0];
    
    slope_wid = height*tan(t_aks[ta_taks]+rake);  
    
    vertexes = [[0,0],
                [slope_wid,-height],
                [support_width,-height],
                [support_width,0]
                ];
             
    rotate_extrude($fn=segments)
    translate(refpoint)
    polygon(vertexes);
}



    
    