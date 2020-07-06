include <../libs/Venturi/head_assembly.scad>
include <../libs/Venturi/airknife_supports.scad>

translate([0,0,-aks_miny(t_aks())])
gen_support(t_aks());
construct_head(t_aks(),gen_sup_ags=[]);