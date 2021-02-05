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

///////// SAPIN

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
                   
                   
#declare P0=<rayonCone,rayonCone>;
#declare P1=<1,1>;
#declare P2=<0.5,0.5>;
#declare P3=<(rayonCone*(1-i/nbEtageBranches)),(rayonCone*(1-i/nbEtageBranches))>;  
#declare rayonGuirlande = 0.1;

#declare tab1=array[4];
#declare tab1[0]=P0;
#declare tab1[1]=P1;
#declare tab1[2]=P2;
#declare tab1[3]=P3;  
        
#declare c=0;   
#declare n=50;    
#declare tabPt=array[n+1];     
     
#declare p=0;  
#declare monEtage=0;  
#declare rayonGuirlande = 0.1;              
               
                        
#declare monSapin=object
{
    union{ 
        /////////////////////////////TRONC
                                      
        cylinder{ 
            <0,0,0>
            <0,0,hauteurTronc>
            rTronc 
             pigment {    
               color Brown
            }               
        }
           
         
       
       #while(i<nbEtageBranches) 
                            
            union
            {
                 difference
                 {   
                    ///////////////////////////////////Branches
                    cone
                    { 
                         <0,0,hauteurTronc+(i*3)> (rayonCone*(1-i/nbEtageBranches))
                         <0,0,hauteurTronc+(i+1)*3> ((1-(i+1)/nbEtageBranches))
                    } 
                    
                    //STRIES DES BRANCHES
                    #declare j=0;
                    #while(j<nbCylindreSapin) 
                          
                        #declare rayonC=rayonCone*(1-i/nbEtageBranches);  
                        #declare rayonC2=(1-(1+i)/nbEtageBranches);                                  
                        #declare theta=2*Pi*j/nbCylindreSapin;                                
                        #declare monZ=hauteurTronc+i*rayonTronc;
                        #declare monZ2=hauteurTronc+(i+1)*rayonTronc; 
                          
                        cylinder  //pour faire les stries des branches
                        {    
                            <rayonC*cos (theta),rayonC*sin(theta),monZ>
                            <rayonC2*cos (theta),rayonC2*sin(theta),monZ2>                                 
                            ((1-(i)/nbEtageBranches))/6
                        }  
                        
                         
                        #declare j=j+1;
                    #end                          
                 
                    pigment
                    { 
                        //rgbt <0,0,0,1>
                        color MediumForestGreen
                    }
                 }
                 //Boules sur le sapin avec leur ficelles 
                 #declare k=0;                 
                                                            
                 #while(k<nbBoulesSapin)   
                 
                    #declare rayon=rayonCone*(1-i/nbEtageBranches); 
                    #declare monZ=i*nbEtageBranches;
                    #declare theta2=k*2*Pi/nbBoulesSapin + rotation;
                    
                    union{ 
                        sphere
                        {                           
                            <rayon*cos(theta2),rayon*sin(theta2),hauteurTronc+(monZ/2)>
                            rayonBoulesSapin/(i+1)
                                
                     
                        }   
                        cylinder
                        {                                                              
                            <rayon*cos(theta2),rayon*sin(theta2),hauteurTronc+(monZ/2)-0.45-(nbEtageBranches-i)/20>
                            <rayon*cos(theta2),rayon*sin(theta2),hauteurTronc+(monZ/2)>
                             rayonBoulesSapin/(i+1)/4
                             
                        } 
                         
                        lathe
                        {
                          linear_spline 
                          4 //nbr_Pt
                          <0.3/(i+1),0>, <0.3/(i+1),0.4/(i+1)>, <0,0.3/(i+1)>, <0,0.1/(i+1)>  
                          rotate<0,0,12*k>     
                          translate<rayon*cos(theta2)+0.09,rayon*sin(theta2)+0.5,hauteurTronc+(monZ/2)-0.45-(nbEtageBranches-i)/20> 
                          pigment {White transmit .5} 
                        }      
                         
                        pigment
                        {
                            rgb <255,0,0> 
                        }
                        finish
                        { phong 0.8 ambient 1 diffuse 0.5 reflection 0.5}   
                        
                                        
                    }
                       
                    
                    
                    #declare k=k+1;
                 #end //FIN WHILE BOULES SAPIN
            } 
           
            
            #declare i=i+1;
         #end
          }
}                        

     

                        
object{         
    monSapin
}  
        

//mesGuirlandes  ////////////////////////////////////////
/////////////////GUIRLANDE
                       
  
 #declare monEtage =0;
 
 #while (monEtage<nbEtageBranches)
      
    #declare rayon=rayonCone*(1-monEtage/nbEtageBranches) ;
    #declare monZ=hauteurTronc+monEtage*rayonTronc;
    #declare theta=monEtage*2*Pi/nbBoulesSapin + rotation;
            
    
 /*  #declare theta=p*2*Pi/nbEtageBranches;
    #declare P0=<1+monEtage,hauteurTronc+monEtage>;
    #declare P1=<8+monEtage, 8+monEtage>;
    #declare P2=<8+monEtage, -10+monEtage>;
    #declare P3=<0, 3+monEtage>;           */
    
    #declare P0=<rayon*(monEtage+3) * cos(theta), rayon*(monEtage+1) * sin(theta)>;
    #declare P1=<rayon*(monEtage+3) * cos(theta+Pi/2), rayon*(monEtage+1) * sin(theta+Pi/2)-5>;
    #declare P2=<rayon*(monEtage+3) * cos(theta+3*Pi/2), rayon*(monEtage+1) * sin(theta+3*Pi/2)-5>;
    #declare P3=<rayon*(monEtage+3) * cos(theta+4*Pi/2), rayon*(monEtage+1) * sin(theta+4*Pi/2)+monEtage>;
      
   
    
    #declare tab1[0]=P0;
    #declare tab1[1]=P1;
    #declare tab1[2]=P2;
    #declare tab1[3]=P3;
     
     /*lathe
     {
          bezier_spline 
          4 //nbr_Pt
          tab1[0],tab1[1],
          tab1[2],tab1[3]   
          translate < 1,3,hauteurTronc+monEtage>
          pigment {Green transmit .5} 
     } */
       
        
     #while (c<n+1)         
             
        #declare t0 = c/n;
                       
        #declare tabPt[c]=pow(1-t0,3)*tab1[0]+3*pow(1-t0,2)*t0*tab1[1]+3*(1-t0)*pow(t0,2)*tab1[2]+pow(t0,3)*tab1[3];
        #declare c=c+1;
     #end
     #while(p<n)            
           
            cylinder{
                tabPt[p] 
                tabPt[p+1] 
                rayonGuirlande   
                translate<0,0,hauteurTronc+(monZ/2)+p*0.05> //+p presque tourbillon x)
                pigment {color Blue}  
                }             
            #declare p=p+1;   
     
     #end  
     
     #declare monEtage=monEtage+1; 
 #end
  
                                