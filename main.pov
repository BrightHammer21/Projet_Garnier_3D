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
    //location <10,10,2>   
    //location <0,0,25>
    look_at <0,0,9>      //0,0,9
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
                   

#declare p=0;  
#declare monEtage=0; 
 
                        
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
                           
                        union  //LES 3 LATHES DIFFERENTES DECORANT LES FICELLES DU SAPIN
                        {    
                            
                             #if(mod(k,2)=0)                               
                                lathe
                                {
                                      linear_spline 
                                      4 //nbr_Pt   
                                      
                                      <0.3/(i+1),0>,
                                      <0.3/(i+1),0.4/(i+1)>, 
                                      <0,0.3/(i+1)>, 
                                      <0,0.1/(i+1)> 
                                   
                                      pigment {White transmit .5} 
                                }     
                                lathe
                                {
                                      linear_spline 
                                      4 //nbr_Pt 
                                      
                                      <0,0.1/(i+1)>,
                                      <0.5/(i+1),0.4/(i+1)>, 
                                      <0.4/(i+1),0.1/(i+1)>, 
                                      <0.2/(i+1),0.05/(i+1)>
                                   
                                 
                                      pigment {Black transmit .5} 
                                } 
                              
                            #elseif(mod(k,3)=0)
                                                 
                                 lathe
                                {
                                      linear_spline 
                                      4 //nbr_Pt   
                                      
                                      <0.3/(i+1),0>,
                                      <0.4/(i+1),0.2/(i+1)>, 
                                      <0.5/(i+1),0./(i+41)>, 
                                      <0,0.1/(i+1)> 
                                   
                                      pigment {Pink transmit .5} 
                                }     
                                lathe
                                {
                                      linear_spline 
                                      3 //nbr_Pt 
                                      
                                      <0,0.1/(i+1)>,
                                      <0.1/(i+1),0.2/(i+1)>, 
                                      <0.05/(i+1),0.6/(i+1)> 
                                     
                                   
                                 
                                      pigment {Yellow} 
                                }                  
                                                 
                                                 
                            #else  
                                   lathe
                                {
                                      linear_spline 
                                      3 //nbr_Pt   
                                      
                                      <0,0>,
                                      <0.26/(i+1),0.2/(i+1)>, 
                                      <0.3/(i+1),0.5/(i+1)>
                                   
                                      pigment {Blue transmit .5} 
                                }     
                                lathe
                                {
                                      linear_spline 
                                      3 //nbr_Pt 
                                      
                                       <0.3/(i+1),0.5/(i+1)>,
                                      <0,0.45/(i+1)>, 
                                      <0.15/(i+1),0.6/(i+1)>
                                   
                                 
                                      pigment {Green transmit .5} 
                                } 
                            #end 
                             
                          
                            rotate<-90,0,0>    
                            translate<rayon*cos(theta2),rayon*sin(theta2),hauteurTronc+(monZ/2)-0.45-(nbEtageBranches-i)/20> 
                                 
                        
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
            
            #if (i=nbEtageBranches)
               sphere 
               {
                                              
                    <0,0,nbEtageBranches*hauteurTronc+3>
                    0.2        
                    
                    pigment {
                        color Yellow
                    }
               }
                            
            #end 
           
            
         #end
          }
}                        

     

 
        

//mesGuirlandes  ////////////////////////////////////////
/////////////////GUIRLANDE   



#macro constructionGuirlande(rayonEtageCone, epaisseur, numEtage, coul, estElectrique) 
    #declare rayonEtageCone=rayonEtageCone+1;
    #declare c=0;   
    #declare n=5;    
    

    #declare tab12=array[5];
    #declare tab22=array[5];
    #declare tabPt1=array[n+1];
    #declare tabPt22=array[n+1];   
    
    #declare P0=<0                      ,-rayonEtageCone+1  ,hauteurTronc*numEtage+0.33+hauteurTronc>;
    #declare P1=<-rayonEtageCone+1.2    ,-rayonEtageCone+1  ,hauteurTronc*numEtage+0.66+hauteurTronc>;
    #declare P2=<-rayonEtageCone        ,0                  ,hauteurTronc*numEtage+1+hauteurTronc>;
    #declare P3=<-rayonEtageCone+1.2    ,rayonEtageCone-1   ,hauteurTronc*numEtage+1.33+hauteurTronc>;
    #declare P4=<0                      ,rayonEtageCone-1    ,hauteurTronc*numEtage+1.66+hauteurTronc>;
    
    #declare M0=P4;
    #declare M1=<rayonEtageCone-1.5     ,rayonEtageCone-1       ,hauteurTronc*numEtage+2+hauteurTronc>;
    #declare M2=<rayonEtageCone-1       ,rayonEtageCone-4       ,hauteurTronc*numEtage+2.33+hauteurTronc>;
    #declare M3=<rayonEtageCone-3       ,-rayonEtageCone+2.5    ,hauteurTronc*numEtage+2.66+hauteurTronc>;
    #declare M4=<0                      ,0                      ,hauteurTronc*numEtage+3+hauteurTronc>;
    
    
    #declare tab12[0]=P0;
    #declare tab12[1]=P1;
    #declare tab12[2]=P2;
    #declare tab12[3]=P3;
    #declare tab12[4]=P4; 
    
    #declare tab22[0]=M0;
    #declare tab22[1]=M1;
    #declare tab22[2]=M2;
    #declare tab22[3]=M3;
    #declare tab22[4]=M4;
   

                            
    #declare maCouleur1=Red;
    #declare maCouleur2=Green;
                   
        
     #while (c<n+1)         
             
        #declare t0 = c/n;                        
         
        #declare tabPt1[c]=pow(1-t0,4)*tab12[0]+4*pow(1-t0,3)*t0*tab12[1]+6*pow(1-t0,2)*pow(t0,2)*tab12[2]+4*pow(t0,3)*(1-t0)*tab12[3]+pow(t0,4)*tab12[4];
        #declare tabPt22[c]=pow(1-t0,4)*tab22[0]+4*pow(1-t0,3)*t0*tab22[1]+6*pow(1-t0,2)*pow(t0,2)*tab22[2]+4*pow(t0,3)*(1-t0)*tab22[3]+pow(t0,4)*tab22[4];
        
        #declare c=c+1;
     #end   
     
    
     #declare p=0;    
     #while(p<n)            
             #if(estElectrique)         
                 cylinder{
                    tabPt22[p] 
                    tabPt22[p+1] 
                    epaisseur  
                    pigment {color coul}                   
                    translate <0,0,0.5>
                    rotate<0,0,-115>    
                 }         
                   
                 #if(mod(10*clock,2)=0)   
                        sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                        rotate<0,0,-115>                                    
                        translate <0,0,0.5>      
                    } 
                 #else 
                     sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                        rotate<0,0,-115>                                
                        translate <0,0,0.5>    
                    }
              
                 #end
                    
             
             #else //////////////////////////Guirlande normale
                  cylinder{
                    tabPt22[p] 
                    tabPt22[p+1] 
                    epaisseur  
                    pigment {color coul}  
                      
                 }   
                   
             #end
                                                     
            #declare p=p+1; 
     
     #end   
     #declare j=0;
     #while(j<n)            
            #if(estElectrique) 
                cylinder{
                    tabPt1[j] 
                    tabPt1[j+1] 
                    epaisseur  
                    pigment {color coul}  
                    rotate<0,0,-115>               
                    translate <0,0,0.5>   
               }            
                     
             
                 #if(mod(10*clock,2)=0)   
                        sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                         rotate<0,0,-115>                                   
                        translate <0,0,0.5>     
                    } 
                 #else 
                     sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                        rotate<0,0,-115>                                    
                        translate <0,0,0.5>     
                    }
              
                 #end
              
             
             #else /////////////////////////////Guirlande normale
                  cylinder{
                    tabPt1[j] 
                    tabPt1[j+1] 
                    epaisseur  
                    pigment {color coul}  
                          
                   } 
                           
             #end
                       
                       
           #declare j=j+1;    
     
     #end 
     

 

#end      


#macro constructionGuirlandeElectrique(rayonEtageCone, epaisseur, numEtage, coul) 
                                     
    #declare rot=110;
    #declare tZ=0.4;                                 
    #declare rayonEtageCone=rayonEtageCone+1;
    #declare c=0;   
    #declare n=5;    
    
    #declare tab12=array[3]; 
    #declare tab22=array[3];  
    #declare tab33=array[3];   
    
    #declare tabPt1=array[n+1];   
    #declare tabPt22=array[n+1];   
    #declare tabPt33=array[n+1]; 
       
         
    #declare P0=<0                   ,0                    ,hauteurTronc*numEtage+2.4+hauteurTronc>;
    #declare P1=<-rayonEtageCone+4.5   ,rayonEtageCone-4   ,hauteurTronc*numEtage+2+hauteurTronc>;
    #declare P2=<rayonEtageCone-4.2    ,rayonEtageCone-3   ,hauteurTronc*numEtage+1.6+hauteurTronc>; 
   
   
    #declare M0=P2;
    #declare M1= <rayonEtageCone-1  ,rayonEtageCone-2    ,hauteurTronc*numEtage+1.2+hauteurTronc>;   
    #declare M2= <rayonEtageCone-1  ,0                   ,hauteurTronc*numEtage+hauteurTronc+0.8>;  
        
    #declare N0=M2;
    #declare N1= <rayonEtageCone-1  ,-rayonEtageCone+1    ,hauteurTronc*numEtage+0.4+hauteurTronc>;   
    #declare N2= <0                 ,-rayonEtageCone+1   ,hauteurTronc*numEtage+hauteurTronc>;  
        
       
    
    #declare tab12[0]=P0;
    #declare tab12[1]=P1;
    #declare tab12[2]=P2;    
    
    #declare tab22[0]=M0;
    #declare tab22[1]=M1;
    #declare tab22[2]=M2; 
    
    
    #declare tab33[0]=N0;
    #declare tab33[1]=N1;
    #declare tab33[2]=N2;
                            
    #declare maCouleur1=White;
    #declare maCouleur2=Blue;
                   
        
     #while (c<n+1)         
             
        #declare t0 = c/n;
                       
        #declare tabPt1[c]=pow(1-t0,2)*tab12[0]+2*(1-t0)*t0*tab12[1]+pow(t0,2)*tab12[2];
        #declare tabPt22[c]=pow(1-t0,2)*tab22[0]+2*(1-t0)*t0*tab22[1]+pow(t0,2)*tab22[2];
        #declare tabPt33[c]=pow(1-t0,2)*tab33[0]+2*(1-t0)*t0*tab33[1]+pow(t0,2)*tab33[2];
  
        #declare c=c+1;
     #end 
     
     #declare o=0;
     #while(o<n)            
           
               cylinder{
                    tabPt33[o] 
                    tabPt33[o+1] 
                    epaisseur  
                    pigment {color coul}  
                    rotate<0,0,rot>
                    translate<0,0,tZ>               
                      
               }            
                     
             
                 #if((mod(10*clock,2)=0) & ((o=3))) 
                        sphere {
                      
                        < tabPt33[o].x, tabPt33[o].y ,tabPt33[o].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                        rotate<0,0,rot>
                        translate<0,0,tZ>                                    
                          
                    } 
                 #elseif((mod(10*clock,2)!=0) &(o=3) )
                     sphere {
                      
                        < tabPt33[o].x, tabPt33[o].y ,tabPt33[o].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                        rotate<0,0,rot> 
                        translate<0,0,tZ>                                    
                        
                    }
              
                 #end
              
                       
                       
           #declare o=o+1; 
     
     #declare p=0;    
     #while(p<n)            
                
                 cylinder{
                    tabPt22[p] 
                    tabPt22[p+1] 
                    epaisseur  
                    pigment {color coul} 
                    rotate<0,0,rot>
                    translate<0,0,tZ>     
                 }         
                   
                 #if((mod(10*clock,2)=0) & ((p=3)))  
                        sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                        rotate<0,0,rot>
                        translate<0,0,tZ>                                     
                        
                    } 
                 #elseif((mod(10*clock,2)!=0) & (p=3)) 
                     sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                        rotate<0,0,rot>
                        translate<0,0,tZ>                                 
                        
                    }
              
                 #end                      
                                         
            #declare p=p+1; 
     
     #end   
     #declare j=0;
     #while(j<n)            
           
               cylinder{
                    tabPt1[j] 
                    tabPt1[j+1] 
                    epaisseur  
                    pigment {color coul}  
                    rotate<0,0,rot>
                    translate<0,0,tZ>                
                   
               }            
                     
             
                 #if((mod(10*clock,2)=0) & ((j=3)))   
                        sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                        rotate<0,0,rot>
                        translate<0,0,tZ>                                    
                          
                    } 
                 #elseif((mod(10*clock,2)!=0) & (j=3)) 
                     sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                        rotate<0,0,rot>
                        translate<0,0,tZ>                                     
                         
                    }
              
                 #end
              
                       
                       
           #declare j=j+1;    
     
     #end    
     
     
       
     
     #end  
     
     
#end

   
////////////////////////////////////////////////////////////COULEURS
#macro choixCouleur(k, col)
#switch (k)
#case (00) #declare col= Black;
#break
#case (01) #declare col= White;
#break
#case (02) #declare col= Red;
#break
#case (03) #declare col= Green;
#break
#case (04) #declare col= Blue;
#break
#case (05) #declare col= Yellow;
#break
#case (06) #declare col= Cyan;
#break
#case (07) #declare col= Magenta;
#break
#case (08) #declare col= Black;
#break
#case (09) #declare col= Aquamarine;
#break
#case (10) #declare col= BlueViolet;
#break
#case (11) #declare col= Brown;
#break
#case (12) #declare col= CadetBlue;
#break
#case (13) #declare col= Coral;
#break
#case (14) #declare col= CornflowerBlue;
#break
#case (15) #declare col= DarkGreen;
#break
#case (16) #declare col= DarkOliveGreen;
#break
#case (17) #declare col= DarkOrchid;
#break
#case (18) #declare col= DarkSlateBlue;
#break
#case (19) #declare col= DarkSlateGray;
#break
#case (20) #declare col= DarkTurquoise;
#break
#case (21) #declare col= Firebrick;
#break
#case (22) #declare col= ForestGreen;
#break
#case (23) #declare col= Gold;
#break
#case (24) #declare col= Goldenrod;
#break
#case (25) #declare col= GreenYellow;
#break
#case (26) #declare col= IndianRed;
#break
#case (27) #declare col= Khaki;
#break
#case (28) #declare col= LightBlue;
#break
#case (29) #declare col= LightSteelBlue;
#break
#case (30) #declare col= LimeGreen;
#break
#case (31) #declare col= Maroon;
#break
#case (32) #declare col= MediumAquamarine;
#break
#case (33) #declare col= MediumBlue;
#break
#case (34) #declare col= MediumForestGreen;
#break
#case (35) #declare col= MediumGoldenrod;
#break
#case (36) #declare col= MediumOrchid;
#break
#case (37) #declare col= MediumSeaGreen;
#break
#case (38) #declare col= MediumSlateBlue;
#break
#case (39) #declare col= MediumSpringGreen;
#break
#case (40) #declare col= MediumTurquoise;
#break
#case (41) #declare col= MediumVioletRed;
#break
#case (42) #declare col= MidnightBlue;
#break
#case (43) #declare col= Navy;
#break
#case (44) #declare col= NavyBlue;
#break
#case (45) #declare col= Orange;
#break
#case (46) #declare col= OrangeRed;
#break
#case (47) #declare col= Orchid;
#break
#case (48) #declare col= PaleGreen;
#break
#case (49) #declare col= Pink;
#break
#case (50) #declare col= Plum;
#break
#case (51) #declare col= Salmon;
#break
#case (52) #declare col= SeaGreen;
#break
#case (53) #declare col= Sienna;
#break
#case (54) #declare col= SkyBlue;
#break
#case (55) #declare col= SlateBlue;
#break
#case (56) #declare col= SpringGreen;
#break
#case (57) #declare col= SteelBlue;
#break
#case (58) #declare col= Tan;
#break
#case (59) #declare col= Thistle;
#break
#case (60) #declare col= Turquoise;
#break
#case (61) #declare col= Violet;
#break
#case (62) #declare col= VioletRed;
#break
#case (63) #declare col= Wheat;
#break
#case (64) #declare col= YellowGreen;
#break
#case (65) #declare col= SummerSky;
#break
#case (66) #declare col= RichBlue;
#break
#case (67) #declare col= Brass;
#break
#case (68) #declare col= Copper;
#break
#case (69) #declare col= Bronze;
#break
#case (70) #declare col= Bronze2;
#break
#case (71) #declare col= Silver;
#break
#case (72) #declare col= BrightGold;
#break
#case (73) #declare col= OldGold;
#break
#case (74) #declare col= Feldspar;
#break
#case (75) #declare col= Quartz;
#break
#case (76) #declare col= NeonPink;
#break
#case (77) #declare col= DarkPurple;
#break
#case (78) #declare col= NeonBlue;
#break
#case (79) #declare col= CoolCopper;
#break
#case (80) #declare col= MandarinOrange;
#break
#case (81) #declare col= LightWood;
#break
#case (82) #declare col= MediumWood;
#break
#case (83) #declare col= DarkWood;
#break
#case (84) #declare col= SpicyPink;
#break
#case (85) #declare col= SemiSweetChoc;
#break
#case (86) #declare col= BakersChoc;
#break
#case (87) #declare col= Flesh;
#break
#case (88) #declare col= NewTan;
#break
#case (89) #declare col= NewMidnightBlue;
#break
#case (90) #declare col= MandarinOrange;
#break
#case (91) #declare col= VeryDarkBrown;
#break
#case (92) #declare col= DarkBrown;
#break
#case (93) #declare col= GreenCopper;
#break
#case (94) #declare col= DkGreenCopper;
#break
#case (95) #declare col= DustyRose;
#break
#case (96) #declare col= HuntersGreen;
#break
#case (97) #declare col= Scarlet;
#break
#case (98) #declare col= DarkTan;
#break
#case (99) #declare col= White;
#break
#end // fin switch

#end


 
   

       
////////////////////////////////////////////////////////CONSTRUCTION OBJET + guirlandes
/*           */
                     
object{         
    monSapin 
    rotate <0,0,-30>
}              
            
        
        
#declare i = 0 ;
#declare col=Red;
#declare Random_1 = seed (999);      
#for (i, 0, nbEtageBranches-2)
     
    choixCouleur(int(99*rand( Random_1)), col)
    constructionGuirlande(4-i*0.8, 0.1 , i, col, false)


#end      
     
#for (i, 0, (nbEtageBranches-1)/(nbEtageBranches/2))
 
    constructionGuirlandeElectrique(4-i*0.8, 0.1 , i, Orange) 
    

#end                                             

                                                   

