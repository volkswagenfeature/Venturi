use <../libs/Venturi/airknife_supports.scad>
include <../libs/Venturi/parametrization.scad>

// Throat parameters
/*
nozzle_wid  = 1; //
start_dist  = 2;
cone_angle  = 0;
start_angle = 15;
outer_rad   = 51;
inner_rad   = 50;
end_dist    = 4;
rep_dist    = 10;
*/
function distance(p1,p2) = sqrt(pow(p1.x-p2.x,2)+ 
                                pow(p1.y-p2.y,2));





gen_support(t_aks());

//poly_support(width = 1);
gen_support_tts(t_ts());

draw_throat(t_ts());
    