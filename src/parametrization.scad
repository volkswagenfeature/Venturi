// Remember, this library must be imported with "include", not "use"

// Having this library seperate allows you to have multiple venturis in one scene, by functionalizing everything, and writing a more complicated t_aks that performs lookups.

// index values
md_taks = 0;
Md_taks = 1;
ta_taks = 2;
sh_taks = 3;
ng_taks = 4;
na_taks = 5;

// Toroid parameters
minor_dia    = 10;
major_dia    = 100;
tilt_angle   = 165;
shell_th     = 2;
nozzle_gap   = 1;
nozzle_angle = 60;

// Calculated parameters
hlf_a = nozzle_angle/2;

// pack a array with parameters for a toroid, using airknife_shadow as its cross-section.
function t_aks () = [ 
    minor_dia, major_dia,
    tilt_angle, shell_th,
    nozzle_gap, nozzle_angle
];

