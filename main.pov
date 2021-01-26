#include "shapes.inc"
#include "colors.inc"
#include "textures.inc"
#include "woods.inc"
#include "glass.inc"
#include "metals.inc"
#include "functions.inc"
#include "stones1.inc"
#include "skies.inc"

#declare Pi = 3.141592653589793384626;

#declare axe=0;
#declare lumpoint=10;
#declare Start=0;
#declare End=2*Pi;
#declare My_Clock=Start+(End-Start)*clock;
#declare sca=25;  

camera{   
    location <0.1*sca,1*sca,9>
    look_at <0,0,9>
    sky <0,0,1>
    right <-image_width/image_height,0,0>
}
    
light_source { <-17,0,0> color Magenta }
light_source { <0,0,0> color White }
light_source { <0,0,0> color rgb <0.75,0.5,0.59>spotlight radius 2 falloff 10 tightness 10 point_at <10,0,0>}
light_source { <0,10,0> color rgb <0.5,0.5,0.49>}
light_source { <10,10,10> color rgb <0.825,0.5,0.9>}                                                         
light_source { <0,0,0> color Red }
light_source { <0,0,0> color Green }
light_source { <10,10,10> color rgb <0.5,0.25,0.49>} 

#declare use_phot=0;
#declare use_area=0;

background {White}

global_settings{
    max_trace_level 60
    ambient_light 1.00
    assumed_gamma 2.0
    #if (use_phot)
        spacing .025
        autostop 0
    }
    #end
}

#declare ciel=1;
#if (ciel)
    sky_sphere {S_Cloud5 rotate <90,0.051, 1>}
#end  

//sol
plane{
    -z 150
    material{  
        texture{
            pigment{ 
                brick color  GreenCopper,
                color PaleGreen mortar 5 brick_size 50                       
            } 
            finish{
                phong 0.8
                ambient 0.85
                diffuse 0.
                reflection 0.2                  
            }
        } 
        interior{ 
            ior 1.333 
            fade_distance 1
            fade_power 1
            fade_color <0,0.0,0>
            caustics 2.5
        }
    }
    rotate <0,0,45>
}  

///////// SAPIN

#declare pEtages = 1;
#declare hauteurTronc = 4; 
#declare rayonTronc = 1;
#declare rayonCone=4;
#declare i=0; 
#declare nCylindreSphere=5;
                        
#declare monSapin=object
{
    union{ 
        //TRONC
        cylinder{ 
            <0,0,-1>
            <0,0,hauteurTronc>
            rayonTronc
            pigment {
               color Brown
            }               
        }
        
       
       
       #while(i<nCylindreSphere)
            union
            {
                 difference
                 {   
                    //Branches
                    cone
                    { 
                         <0,0,hauteurTronc+(i*3)> (rayonCone*(1-i/nCylindreSphere))
                         <0,0,hauteurTronc+(i+1)*3> ((1-(i+1)/nCylindreSphere))
                    } 
                    union
                    {
                        #declare j=0;
                        #while(j<20)
                            cylinder
                            {   
                                <0.5,1,1>
                                <1,0.5,1>
                                2
                            }  
                            #declare j=j+1;
                         #end                          
                    } 
                    pigment
                    { 
                        color MediumForestGreen
                    }
                 }
                 //Boules
            }
            #declare i=i+1;
         #end
          }
}                        
                        
object{         
    monSapin
}