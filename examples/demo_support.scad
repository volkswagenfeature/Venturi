use <../libs/Venturi/airknife_supports.scad>
include <../libs/Venturi/parametrization.scad>

//index values
wd_tts = 0;
sd_tts = 1;
ca_tts = 2;
sa_tts = 3;
or_tts = 4;
ir_tts = 5;
ed_tts = 6;
rd_tts = 7;


// Throat parameters
nozzle_wid  = 1; //
start_dist  = 2;
cone_angle  = 30;
start_angle = 15;
outer_rad   = 51;
inner_rad   = 50;
end_dist    = 4;
rep_dist    = 10;

function t_ts() = [
   nozzle_wid,
   start_dist,
   cone_angle,
   start_angle,//
   outer_rad,
   inner_rad,
   end_dist,
   rep_dist,
];

function distance(p1,p2) = sqrt(pow(p1.x-p2.x,2)+ 
                                pow(p1.y-p2.y,2));


module draw_throat(t_ts){
    // Drop in index values later.
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
            rotate_extrude()
            polygon([p_1,p_2,p_3,p_4]);
               
            color("red",.5)            
            rotate_extrude()
            polygon([p_1,p_4,p_6,p_5]);
            
            color("blue",0.5)
            rotate_extrude()
            polygon([p_2,p_3,p_8,p_7]);   
           }
            
        
        
        
    }
}


gen_support(t_aks());

poly_support();

draw_throat(t_ts());
    