
//~100 - 300 micron precision
// Mother board: 102.1 x 33.8 mm
// with the scintillator + mezzanine board stacked, total height ~ 1.6 inches ~ 40.6 mm
// Mother board + mezzanine ~ 0.6 inches in height ~ 15.3 mm

// USE VARIABLES FOR DIMENSIONS 


// 24 mm vs 18.5 mm = diff is 6.5 mm
$fn=100;

box_length = 105;
box_width = 37;
box_height = 15.3;
pi_zero_width=30;
pi_zero_length=65;
wall_width=2.8; //resulting thickness is half of this value
floor_thickness=wall_width/2; // should be half of the wall_width
part = "piZero"; 

// Show Header
header = true; // true:Show Header;false:Don't show Header

// Header Up/Down for Pi Zero
headerDown = false; //true: Header down (Only Zero): false Header up

ic_width=pi_zero_width+2.5; // inner case width
ic_length=pi_zero_length+8; // inner case length

bottom_ic_height=10; // height of bottom inner case 
top_ic_height=8; // height of top inner case 

ridge_width=1.2; // resulting width is half of this value
ridge_height=1.5;

use <library.scad/raspberrypi.scad>;
use <raspberrypi_library/papirus_hat_pizero.scad>;

module mother(){
   color("darkgrey")
   translate([0,-6.5,0])
   cube([box_length, box_width, box_height], center = true);  
    }

length = 103;
width = 35;
height = 15.3;

module top_off(){       //Cuts out the top cube to fit the motherboard + mezzanine card
    difference(){       // Dimensions of cut out: 103 mm x 35 mm x 15.3 mm 
      mother();
      translate([0,-6.5,1]){  // makes the bottom layer 1mm in thickness, incease to 2 mm: [0,0,2]
      cube([length, width-2, height], center = true);     
      }
    }
    }

module out_let(){       // Cuts out holes for outputs around the box
    difference(){
      top_off();    
      translate([40,3.5,0])
      rotate([0, 90, 0])
      cylinder(h = 80, r = 5, center = true);  
        
      translate([-40,-16.5,-4.5])
      cube([60, 10, 5], center = true);  
      
      translate([-30, 3.5, -5])
      cube([20, 20, 2], center = true);
      }
    }
    

module puck_holder(){ //adds a small cube to hold the puck
    union(){        
        out_let();
        translate([13, 0, -16.3])
        cube([50,50,20], center = true);
    }
   }
   
   
module remodel(){ // adds a large bottom layer to the model
     color("darkgrey")
     union(){
       puck_holder();
       translate([0, -.1, -16.3]) //-16.3
       cube([105,49.6,20], center = true);
       
       
       
    }
    }

module puck_cut(){
   difference(){
       remodel();
       translate([13, 0, -15.3])
       cube([48,48,20], center = true);    
       
       }
       
    }

module refit(){    // push out the puck borders to fit along the wider borders
    color("darkgrey") 
    union(){
        puck_cut();
       
        
        translate([13,24.5,0])
        rotate([90, 180, 0])
        cube([50, box_height, 1], center = true);
        }
        
    
    
    }

module refit2(){
 difference(){
        refit();
        translate([13,11.5,1])
        rotate([90, 180, 0])
        cube([48, box_height, 2], center = true);

        }     
    }
    
module bridge_gap(){
    color("DarkKhaki")

    union(){
            refit2();
            translate([-11.5,18,0])
            rotate([0, 90, 0])
            cube([box_height, box_height-1, 2], center = true);
            
            translate([38,18,0])
            rotate([0, 90, 0])
            cube([box_height, box_height-1, 2], center = true);
        
        
        }
    
    }
    
module add_space(){
     difference(){
            bridge_gap();
            translate([13.5,10,0])
            rotate([90, 0, 0])
            cube([box_height+32, box_height+1, 4], center = true);
    
     } 
    
    
    }
    
module zero( header= 0)
{
  // PCB
  color("limegreen") difference()
  {
    hull()
    {
      translate([-(65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([-(65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2,-(30-6)/2,0]) cylinder(r=3, h=1.4 );
      translate([ (65-6)/2, (30-6)/2,0]) cylinder(r=3, h=1.4 );
    }
    
    translate([-65/2+3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([-65/2+3.5, 23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5,-23/2,-1]) cylinder(d=2.75, h=3);
    translate([65/2-3.5, 23/2,-1]) cylinder(d=2.75, h=3);
  }

  // Header
  if( header == 1)
    translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,1.4])
      header(20,2);
  if( header == -1)
    translate([3.5-65/2+29-10*2.54,30/2-3.5-2.54,0])
      mirror([0,0,1]) header(20,2);
    
  translate([-65/2,-30/2,1.4])
  {
    // Micro SD Card
    color("silver") translate([1.5,16.9-5,0]) cube([12,10,1.4]);    
    color("darkgrey") translate([-2.5,16.9-5,0.25]) cube([4,10,1]);
    
    // micro USB
    color("silver") translate([41.4-8/2,-1.5,0]) cube([8,6,2.6]);
    color("silver") translate([54-8/2,-1.5,0]) cube([8,6,2.6]);

    // HDMI
    color("silver")  translate([12.4-11.4/2,-.5,0]) cube([11.3,7.5,3.1]);
    
    // Camera
    color("darkgrey") translate([65-3,(30-17)/2,0]) cube([4,17,1.3]);  
  }
}

module header(pins, rows)
{
  color("darkgrey") cube([2.54*pins,2.54*rows,1.27]);
  
  for(x=[0:pins-1],y=[0:rows-1])
    translate([x*2.54+(1.27+.6)/2,y*2.54+(1.27+.6)/2,-8]) cube([0.6,0.6,11.5]);
}

 

trans = -30;
module lid(){
    color("ForestGreen")
    union(){
     translate([0,-6.5,trans])
     cube([box_length, box_width, 3], center = true);  
     translate([-13,18.5,trans])     // smaller piece
     cube([50, box_height-2, 3], center = true);
     
     translate([0,-6.5,trans+2])
     cube([box_length-6, box_width-6, 2], center = true);  
     translate([-13,16.5,trans+2])     // smaller piece
     cube([46, box_height-3, 2], center = true);
    }
    
} 

module grooves(){
    rotate([0,180,0])
    difference(){
        lid();
        translate([0,-6.5,translate+2])
        cube([box_length-8, box_width-8, 2.5], center = true);  
        translate([-13,16,translate+2])     // smaller piece
        cube([42, box_height-8, 2.5], center = true);
        
        translate([-13,12,translate+2])     // smaller piece
        cube([42, 10, 2.1], center = true);  
        
        }   
    }
    // Dimensions of cut out: 103 mm x 35 mm x 15.3 mm 
    // Actual dimension: 105 mm x 37 mm 
    

module set_picase_on_grooves(){     // use union to identiy where to build a snug perimeter
                                                        // around the pi (a case)
                                    // use difference to make the pegs taller 
    difference(){
       grooves();
       translate([0,-6.5, -(trans-1)])
       zero(header ? (
        Down ? -1 : 1) : 0);
        
        }
    }

module extend_pegs(){
    union(){
        set_picase_on_grooves();
        translate([-65/2+3.5,-23/2-(6.5),.5-trans]) cylinder(d=2.75, h=3);
        translate([-65/2+3.5, 23/2-(6.5),.5-trans]) cylinder(d=2.75, h=3);
        translate([65/2-3.5,-23/2-(6.5), .5-trans]) cylinder(d=2.75, h=3);
        translate([65/2-3.5, 23/2-(6.5), .5-trans]) cylinder(d=2.75, h=3);
        }
    
 
    }

    
add_space();
extend_pegs();
   

   


