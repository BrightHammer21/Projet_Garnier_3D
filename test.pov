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
    //location <0,0,25>
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
                //color White             
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


   
#declare hauteurTronc = 3; 
#declare rayonTronc = 3;
#declare rTronc = 1;
#declare nbEtageBranches=6;
#declare rayonCone=4;
#declare i=0; 
#declare nbBoulesSapin=15; 
#declare nbCylindreSapin=15;
#declare rayonBoulesSapin=0.3;  
#declare rotation = (2*Pi/nbBoulesSapin)+1.05;  //pour placer les boules au milieu des branches
                   

#declare p=0;  
#declare monEtage=0; 

        #declare rayonGuirlande = 0.1;  
    #declare rayon=rayonCone*(1/nbEtageBranches) ;
    #declare monZ=hauteurTronc+rayonTronc;
#declare zSommet = hauteurTronc*nbEtageBranches+(monZ*1.4);
#declare c=0;
#declare p=0;    
#declare n=50;    

#declare tab12=array[4]; 
#declare tab22=array[4];   
#declare tabPt1=array[n+1];   
#declare tabPt22=array[n+1];   



#declare maGuirlande2 = object 
{  
 union {          
 

        
    
    #declare P0=<rayonCone,rayonCone>;  
    #declare P1=<1.2,1.5>;  
    #declare P2=<-1.5,2>; 
    #declare P3=<-2,0.2>;  

   
    #declare M0=<0,0>;
    #declare M1=<1,-2>;      
    #declare M2=<-1.9,-1.4>; 
    #declare M3=P3;         
   
    
    #declare tab12[0]=P0;
    #declare tab12[1]=P1;
    #declare tab12[2]=P2;
    #declare tab12[3]=P3;    
    
    #declare tab22[0]=M0;
    #declare tab22[1]=M1;
    #declare tab22[2]=M2;
    #declare tab22[3]=M3;
      
        
     #while (c<n+1)         
             
        #declare t0 = c/n;
                       
        #declare tabPt1[c]=pow(1-t0,3)*tab12[0]+3*pow(1-t0,2)*t0*tab12[1]+3*(1-t0)*pow(t0,2)*tab12[2]+pow(t0,3)*tab12[3];
        #declare tabPt22[c]=pow(1-t0,3)*tab22[0]+3*pow(1-t0,2)*t0*tab22[1]+3*(1-t0)*pow(t0,2)*tab22[2]+pow(t0,3)*tab22[3];
  
        #declare c=c+1;
     #end     
     
     #while(p<n)            
           
            cylinder{
                tabPt1[p] 
                tabPt1[p+1] 
                rayonGuirlande  
                rotate <0,0,p*0.5> 
                translate<0,1,zSommet/2> 
                pigment {color Green}  
                }            
                
             cylinder{
                tabPt22[p] 
                tabPt22[p+1] 
                rayonGuirlande  
                rotate <0,0,p*0.5> 
                translate<0,1,zSommet/2> 
                pigment {color Yellow}  
                }            
            #declare p=p+1;   
     
     #end   
     
      }  
} 
     
object {
 
    maGuirlande2 
    
}          