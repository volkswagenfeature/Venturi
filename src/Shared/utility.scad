module section(size){
    for (i=[0:$children-1]){
        intersection(){
            translate([0.5*size,0,0])
            cube(size,center=true);
            children(i);
        }
        
    }
}