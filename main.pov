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
            
                //brick color  GreenCopper,
                //color PaleGreen mortar 5 brick_size 50        
                color White             
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
                             
                            rotate<0,0,12*k>     
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
    
    #declare tab12=array[4]; 
    #declare tab22=array[4];   
    #declare tabPt1=array[n+1];   
    #declare tabPt22=array[n+1];   
        
    #declare P0=<0                  ,-rayonEtageCone+1.5    ,hauteurTronc*numEtage+hauteurTronc>;  
    #declare P1=<-rayonEtageCone+1.5,-rayonEtageCone  ,hauteurTronc*numEtage+0.5+hauteurTronc>;  
    #declare P2=<-rayonEtageCone    ,rayonEtageCone-1   ,hauteurTronc*numEtage+1+hauteurTronc>; 
    #declare P3=<0                  ,rayonEtageCone-1     ,hauteurTronc*numEtage+1.5+hauteurTronc>;  

   
    #declare M0=P3;
    #declare M1=<rayonEtageCone     ,rayonEtageCone-1   ,hauteurTronc*numEtage+2+hauteurTronc>;      
    #declare M2=<rayonEtageCone-1.5 ,-rayonEtageCone  ,hauteurTronc*numEtage+2.5+hauteurTronc>; 
    #declare M3=<0                  ,-rayonEtageCone+1.5    ,hauteurTronc*numEtage+3+hauteurTronc>;   
     
     /*
    #declare P0=<0,0,hauteurTronc*numEtage+hauteurTronc>;  
    #declare P1=<-rayonEtageCone,-rayonEtageCone+1,hauteurTronc*numEtage+0.5+hauteurTronc>;  
    #declare P2=<-5,rayonEtageCone+1,hauteurTronc*numEtage+1+hauteurTronc>; 
    #declare P3=<0,rayonEtageCone,hauteurTronc*numEtage+1.5+hauteurTronc>;  

   
    #declare M0=P3;
    #declare M1=<rayonEtageCone,3,hauteurTronc*numEtage+2+hauteurTronc>;      
    #declare M2=<rayonEtageCone,1,hauteurTronc*numEtage+2.5+hauteurTronc>; 
    #declare M3=<0,0,hauteurTronc*numEtage+3+hauteurTronc>;         
     */
    
    #declare tab12[0]=P0;
    #declare tab12[1]=P1;
    #declare tab12[2]=P2;
    #declare tab12[3]=P3;    
    
    #declare tab22[0]=M0;
    #declare tab22[1]=M1;
    #declare tab22[2]=M2;
    #declare tab22[3]=M3;
                            
    #declare maCouleur1=Red;
    #declare maCouleur2=Green;
                   
        
     #while (c<n+1)         
             
        #declare t0 = c/n;
                       
        #declare tabPt1[c]=pow(1-t0,3)*tab12[0]+3*pow(1-t0,2)*t0*tab12[1]+3*(1-t0)*pow(t0,2)*tab12[2]+pow(t0,3)*tab12[3];
        #declare tabPt22[c]=pow(1-t0,3)*tab22[0]+3*pow(1-t0,2)*t0*tab22[1]+3*(1-t0)*pow(t0,2)*tab22[2]+pow(t0,3)*tab22[3];
  
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
                    translate <0,0,1>   
                 }         
                   
                 #if(mod(10*clock,2)=0)   
                        sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                                                           
                       translate <0,0,1>      
                    } 
                 #else 
                     sphere {
                      
                        < tabPt22[p].x, tabPt22[p].y ,tabPt22[p].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                                                        
                       translate <0,0,1>    
                    }
              
                 #end
                    
              
            
             
             
             
             #else 
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
                    translate <0,0,1>   
               }            
                     
             
                   #if(mod(10*clock,2)=0)   
                        sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur1}    
                                                            
                       translate <0,0,1>     
                    } 
                 #else 
                     sphere {
                      
                        < tabPt1[j].x, tabPt1[j].y ,tabPt1[j].z>
                        0.2    
                        
                        pigment {color maCouleur2}    
                                                           
                       translate <0,0,1>     
                    }
              
                 #end
              
             
             #else 
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

   
   
   

       
////////////////////////////////////////////////////////CONSTRUCTION OBJET + guirlandes
/* */           
               
                     
object{         
    monSapin 
    rotate <0,0,-30>
}    

constructionGuirlande(4, 0.1 , 0, Green, false)    

constructionGuirlande(3.2, 0.1, 1, Red, false)   

constructionGuirlande(2.4, 0.1, 2, Yellow, false)  

constructionGuirlande(1.6, 0.1,3, Orange, false)    

constructionGuirlande(0.8, 0.1, 4, Pink, false)
                                                 
                                                                                                      
                                                    
                                                    
 /*                                                     
constructionGuirlande(4, 0.1, 0, Black, true) 
        
constructionGuirlande(3.2, 0.1, 1, Black, true)    
     
constructionGuirlande(2.4, 0.1, 2, Black, true) 
        
constructionGuirlande(1.6, 0.1, 3, Black, true)  */
                                                   

