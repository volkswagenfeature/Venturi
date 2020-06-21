// Venturi tube profiles, and handling info.

// All tube profiles should have a flat surface at z=0, and have all material below xy plane.

/* --Linear Tube profile-- */

function vp_lt_params(
    inlet_length=50,
    inlet_diameter=50,
    throat_length=20,
    throat_diameter=20,
    outlet_length=30,
    outlet_diameter=30,
) = [
     inlet_length,  inlet_diameter,
     throat_length, throat_diameter,
     outlet_length, outlet_diameter
    ];


module vp_lt_body(
    vplt_p,
    wall_thickness = 1
){
    // So I can use identifiers for vplt_p.
    // Will be in most linear tube profile modules.
    let(
        il = 0,
        id = 1,
        tl = 2,
        td = 3,
        ol = 4,
        od = 5
    ){
        inlet_st  = [vplt_p[id]/2,0];
        throat_st = [vplt_p[td]/2,-vplt_p[il]];
        throat_ed = throat_st - [0,vplt_p[tl]];
        outlet_ed = [vplt_p[od]/2,throat_ed.y-vplt_p[ol]];
        
        pt = [inlet_st,throat_st,throat_ed,outlet_ed];
        vertexes = concat(pt,
        [for (i = [len(pt)-1:-1:0])pt[i]+[wall_thickness,0]]);
        polygon(vertexes);
    }
}

module vp_lt_silhouette(
    vplt_p,
    wall_thickness = 1,
){
    let(
        il = 0,
        id = 1,
        tl = 2,
        td = 3,
        ol = 4,
        od = 5
    ){
        inlet_st  = [vplt_p[id]/2,0];
        throat_st = [vplt_p[td]/2,-vplt_p[il]];
        throat_ed = throat_st - [0,vplt_p[tl]];
        outlet_ed = [vplt_p[od]/2,throat_ed.y-vplt_p[ol]];
     
        pt = [inlet_st,throat_st,throat_ed,outlet_ed];
        // Above was copied and pasted from vp_lt_body
        
        vertexes = [for (i=[0:len(pt)-1])pt[i]+
                     [wall_thickness/2,0],
                   [0,outlet_ed.y],
                   [0,0]];
        polygon(vertexes);
    }
}

/* --Linear Tube profile end-- */

// Child should be a silhouette
// undersize is in the form[+x,-x,+y,-y]
module vp_support(
    radius = 25,
    length = 100,
    thickness = 1,
    number = 3,
    undersize = [.1,.1,.1,.1]
){
    trans = [undersize[1],undersize[3]];
    size  = [undersize[0]+undersize[1],
             undersize[2]+undersize[3]];
    

    for(i = [0:360/number:360-360/number]){
        rotate([90,0,i])
        linear_extrude(height=thickness,center=true)
        difference(){
            translate([0,-100]+trans)
            square([radius,length]-size);
            
            children();
        }
    }
}



    
vplt_p = vp_lt_params();
union(){
    rotate_extrude($fn=100)
    vp_lt_body(vplt_p); 

    vp_support(undersize=[.1,.1,.1,0])
    vp_lt_silhouette(vplt_p);
}
