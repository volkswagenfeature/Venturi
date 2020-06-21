// Venturi tube patterns.

/* --Linear Tube profile-- */
let(
    il = 0,
    id = 1,
    tl = 2,
    td = 3,
    ol = 4,
    od = 5
);
function vp_lt_params(
    inlet_length=50,
    inlet_diameter=50,
    throat_length=20,
    throat_diameter=20,
    outlet_length=30,
    outlet_diameter=30,
) = [inlet_length,  inlet_diameter,
     throat_length, throat_diameter,
     outlet_length, outlet_diameter,
      sections];


module vp_lt_body(
    inlet_length=30,
    inlet_diameter=50,
    throat_length=20,
    throat_diameter=10,
    outlet_length=50,
    outlet_diameter=30,
    wall_thickness = 1
){
    inlet_st  = [inlet_diameter/2,0];
    throat_st = [throat_diameter/2,-inlet_length];
    throat_ed = throat_st - [0,throat_length];
    outlet_ed = [outlet_diameter/2,throat_ed.y-outlet_length];
    
    pt = [inlet_st,throat_st,throat_ed,outlet_ed];
    vertexes = concat(pt,
    [for (i = [len(pt)-1:-1:0])pt[i]+[wall_thickness,0]]);
    echo(pt);
    echo(vertexes);
    polygon(vertexes);
}

rotate_extrude($fn=100)
vp_lt_body(); 

    