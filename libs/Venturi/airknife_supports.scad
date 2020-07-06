include <parametrization.scad>



module poly_support(
    body_len = 4,
    thickness = 1,
    width = 2,
    tail_merge = 3,
    tail_end = 5,
    head_width = 2.35,
    head_start = 2
){
  
    s_len = body_len;//shell_th / sin(nozzle_angle/2);
    s_wid = width/2;
    s_thk = thickness/2;
    s_dx  = head_width/2;   //tan(nozzle_angle/2)*head_start; //1.1547
    
    // Variable to ensure that polygons intersect,
    // rather than simpily touching. To help avoid issues
    // with intersecting polygons.
    xsz = 0.3;
    
    
    p_points = 
    [
        [0,-head_start,s_dx+s_thk+xsz], // head points.
        [0,-head_start,-s_dx-s_thk],
    
        [s_wid,s_len,s_thk+xsz], //[2] front face points
        [-s_wid,s_len,s_thk+xsz],
        [s_wid,s_len,-s_thk],
        [-s_wid,s_len,-s_thk],
    
        [s_wid,0,s_thk+xsz], //[6] back face points
        [-s_wid,0,s_thk+xsz],
        [s_wid,0,-s_thk],
        [-s_wid,0,-s_thk],
    
        [0,s_len + tail_merge,s_thk], //[10] end taper
        [0,s_len + tail_end,-s_thk]
    
    ];
    
    p_faces = 
    [
        [0,6,8,1], //face sides
        [0,1,9,7],
        [0,6,7],
        [1,8,9],
        
        
        [8,6,2,4], //sides
        [7,9,5,3],
        [10,2,6,7,3],
        [11,4,8,9,5],
        
        [10,2,4],  //tail
        [11,4,10],
        [10,5,3],
        [11,10,5]
    ];
    polyhedron(p_points,p_faces,4);
        
        
    
    
}





// Repeat supports around gap
// TODO: Consolidate all the different translate/rotate operations
// TODO: New format without t_aks.
    // Assume forming between two conical sections.
module gen_support(t_aks,spacing=15,c="cyan")
{
    tip = 
    t_aks[md_taks]/(2*sin(t_aks[na_taks]/2))-
    t_aks[ng_taks]/(2*tan(t_aks[na_taks]/2));
    
    a = t_aks[ta_taks];
    pt = [0,-tip*sin(a),tip*cos(a)];
    
    
    color(c)
    for(angle = [0:360/ceil(t_aks[Md_taks]*3.14/spacing):360])
    rotate([0,0,angle])
    translate([0,t_aks[Md_taks]/2,0]+pt)
    rotate([90-t_aks[ta_taks],0,180])
    //fix call to poly_support with new args.
    poly_support();
}


