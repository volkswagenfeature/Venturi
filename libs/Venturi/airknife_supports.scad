// Throat parameters
nozzle_wid  = 1; //
start_dist  = 2;
cone_angle  = 30;
start_angle = 15;
outer_rad   = 51;
inner_rad   = 50;
end_dist    = 4;
sup_wid     = 2;
rep_dist    = 10;

function t_ts() = [
   nozzle_wid,
   start_dist,
   cone_angle,
   start_angle,//
   outer_rad,
   inner_rad,
   end_dist,
   sup_wid,
   rep_dist,
];

module draw_throat(t_ts){
    let(
        wd_tts = 0,
        sd_tts = 1,
        ca_tts = 2,
        sa_tts = 3,
        or_tts = 4,
        ir_tts = 5,
        ed_tts = 6,
        sw_tts = 7,
        rd_tts = 8
    ){
        let(){
            angle = 90-t_ts[ca_tts]/2;
            slope = tan(angle);
            d_pt  = t_ts[wd_tts]*[cos(angle+90),sin(angle+90)];
            delta = t_ts[or_tts]-t_ts[ir_tts];
            
            e_pt  = t_ts[ed_tts]*[cos(angle+180),sin(angle+180)];
            
            s_pt  = t_ts[sd_tts]*[cos(angle),sin(angle)];
            w_pt  = t_ts[ed_tts]*tan(t_ts[sa_tts])*
                    [cos(angle-90),sin(angle-90)];
            
            echo(w_pt);
           
            let(p_1=[t_ts[ir_tts],0],
                p_2=[t_ts[or_tts],slope*delta],
                p_3=p_2-d_pt,
                p_4=p_1-d_pt,
            
                p_5=p_1+e_pt,
                p_6=p_5-d_pt,
            
                p_7=p_2+s_pt-w_pt,
                p_8=p_2+s_pt-d_pt+w_pt
            
               ){
                color("green",.5)
                //rotate_extrude()
                polygon([p_1,p_2,p_3,p_4]);
                   
                color("red",.5)            
                //rotate_extrude()
                polygon([p_1,p_4,p_6,p_5]);
                
                color("blue",0.5)
                //rotate_extrude()
                polygon([p_2,p_3,p_8,p_7]);   
               }
            }
    }
}

module test_throat(t_ts){
    // For testing the propper sizing of a single poly_support at origin.
}

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
    // with exactly contacting polygons.
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
/*
module poly_support(
    body_len = 4,
    thickness = 1,
    width = 2,
    tail_merge = 3,
    tail_end = 5,
    head_width = 2.35,
    head_start = 2
){
*/

/*
function t_ts() = [
   nozzle_wid,
   start_dist,
   cone_angle,
   start_angle,//
   outer_rad,
   inner_rad,
   end_dist,
   sup_wid,
   rep_dist,
];
*/

module gen_support_tts(t_ts,c="cyan")
{
    let(
        wd = 0,
        sd = 1,
        ca = 2,
        sa = 3,
        or = 4,
        ir = 5,
        ed = 6,
        sw = 7,
        rd = 8
    ){
        body_len = (t_ts[or]-t_ts[ir]) / sin(t_ts[ca]);
        thickness = t_ts[wd];
        width = t_ts[sw];
        tail_merge = 0.5 * t_ts[ed];
        tail_end = t_ts[ed];
        head_width =  t_ts[wd]+2*tan(t_ts[sa])*t_ts[sd];
        head_start = t_ts[sd];
        
        
        poly_support(body_len,thickness,
                     width,tail_merge,
                     tail_end,head_width,
                     head_start);
        translate([0,0,0]);
        
        
    }
}

