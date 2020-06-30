use <airknife_hull.scad>
use <airknife_supports.scad>
include <parametrization.scad>



module construct_head(
    t_aks,
    base_ags     = undef,
    side_sup_ags = undef,
    skirt_ags    = undef,
    gen_sup_ags  = undef
){
    /*-----START OF SHIM FUNCTIONS-----*/
    
    // From airknife_hull.scad
    module base_wrapper (t_aks,args){
        if(args){
            ak_base(t_aks, args[0],args[1],args[2])
            children(0);
        }else if(args == undef){
            children(0);
        }else{
            ak_base(t_aks)children(0);
        }
    }
    module s_sup_wrapper (t_aks,args){
        if(args){
            ak_side_support(t_aks, args[0],args[1])
            children(0);
        }else if(args == undef){
            children(0);
        }else{
            ak_side_support(t_aks)children(0);
        }
    }
    
    module skirt_wrapper (t_aks,args){
        if(args){
            translate([0,0,args[2]]){
                skirt(t_aks, args[0],args[1],
                      args[2],args[3],args[4]);
                children(0);
            }
        }else if(args == undef){
            children(0);
        }else{
            translate([0,0,10]){
                skirt(t_aks);
                children();}
            }
        }
    
    
    // From airknife_supports.scad
    module gen_sup_wrapper (t_aks,args){
        if(args){ 
            translate([0,aks_miny(t_aks),0]) 
            // ^this isn't in other wrapper modules.
            gen_support(t_aks, args[0]);
            children();
        }else if(args == undef){
            children();
        }else{
            translate([0,0,-aks_miny(t_aks)])
            gen_support(t_aks);
            children();
        }
    }
    
    
    /*---------END OF SHIM FUNCTIONS-------*/
  
    // Skirt created seperately.
    skirt_wrapper(t_aks,skirt_ags){
        
        // Revolve profile shape
        ak_maketoroid(t_aks)
        // Modifications to profile shape:
        base_wrapper(t_aks, base_ags)
        s_sup_wrapper(t_aks,side_sup_ags)
        // profile shape definition:
        airknife_section(t_aks);
        
        //Supports created.
        gen_sup_wrapper(t_aks,gen_sup_ags);
    }
}
