// Venturi tube patterns.

module vp_linear_tube(
    inlet_length,
    inlet_diameter,
    throat_length,
    throat_diameter,
    outlet_length,
    outlet_diameter,
    wall_thickness = 2
){
    inlet_st  = [inlet_diameter/2,0];
    throat_st = [throat_diameter/2,-inlet_length];
    throat_ed = throat_st + [0,throat_length];
    outlet_ed = [outlet_diameter,throat_ed[1]];
    
    down = [inlet_st,throat_st,throat_ed,outlet_ed];
    vertexes = concat(vertexes,[0,2]);
    echo(vertexes);
}

vp_linear_tube(50,20,20,10,100,50); 
    