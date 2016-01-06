// 3D printable screw down tray for holding an Arduino Uno and shield 
// (or same size microcrontroller)
// Nathan Vierling-Claassen
// 5/2015
// Revised 1/2016 
// --------------
// --Pilot holes in tray line up with pilot holes on arduino 
//   so assembly can be bolted together 
// --Ridge around edges is shorter than needed for an Arduino shield 
//   to overhang edges of tray
// --Fit of the arduino into the tray is quite tight, so resolution on the print needs to be
//   pretty good (I used 0.16mm layer height on a Lulzbot Taz4/5 with ABS)
// --Prints upwards in z direction without support material
// --Dimensions in mm
// --------------

//-------
// Measurement Parameters
//-------

// width of tray interior (x direction)
bx=54;
// length of tray interior (y direction)
by=69;
// interior height of tray edge (z direction)
bh=10;
// width of screw tabs that extend in y direction
wb=15;
// wall thickness throughout object
th=2;
// total length of bottom of the tray (includes tabs extending in y direction
tl=by+2*wb;
// distance between bolt/screw holes in tab (here set up for rack spacing)
hdist=44.5;
// width of usb opening
usb_w=12.5;
// distance of usb opening from edge of tray 
usb_d=10.2;
// width of power cord opening
pwr_w=10.5;
// distance of power cord opening from edge of tray
pwr_d=2.5;
// brace height for interior supports 
// (so that solder on base of Arduino does not impair fit)
br_d=2.5;
// diameter of bolt/screw holes
hdiam=6.5;
// width of lattice bracing on bottom of tray
br=7;

// calculate length of sides of cutouts in bottom of box 
// (here for 3 X 3 grid)
dsy=(by-4*br)/3;
dsx=(bx-4*br)/3;

// locations for arduino mounting holes
// ------------
// distance of hole center from corner in x and y direction
// starting at (0,0), then clockwise in the xy plane, 
// coordinate here is measurement on the Arduino in mm, 
// measurements from:
// https://blog.arduino.cc/2011/01/05/nice-drawings-of-the-arduino-uno-and-mega-2560/
hx1=2.54; //100
hy1=15.24; //600
hx2=17.78; // 700
hy2=66.04; //2600
hx3=45.72; //1800
hy3=66.04; //2600
hx4=50.8; //2000
hy4=13.97; //550

// diameter of arduino mounting holes
pdiam= 4;  

// ----------
// Tray build
// ----------
difference(){
	union(){	
        // main body of tray
		cube(size=[bx+2*th,by+2*th,bh],center=false);
		
        // tray base with extra length for screw tabs
		translate([0,(by+2*th-tl)/2,-th])cube(size=[bx+2*th,tl,th], center=false);
		
        // extra brace to strengthen front/back seams, 
        // 45 degree rotation reduces breakage along seam
		translate([bx/2+th,0,0])rotate(45,[1,0,0])cube(size=[bx+2*th,th,th],center=true);
		translate([bx/2+th,by+2*th,0])rotate(45,[1,0,0])cube(size=[bx+2*th,th,th],center=true);
	}
	union(){
		// remove inside of box
		translate([th,th,0])cube(size=[bx,by,2*bh],center=false);
		
		//remove screw/bolt holes in tabs
		translate([-(hdist/2-bx/2-th), -5-th, 0])cylinder(h=3*th,r=hdiam/2, center=true);
		translate([-(hdist/2-bx/2-th), by+3*th+5, 0])cylinder(h=3*th,r=hdiam/2, center=true);
		translate([bx+2*th+(hdist/2-bx/2-th), -5-th, 0])cylinder(h=3*th,r=hdiam/2, center=true);
		translate([bx+2*th+(hdist/2-bx/2-th), by+3*th+5, 0])cylinder(h=3*th,r=hdiam/2, center=true);

		// remove opening for usb & pwr cord on arduino
		translate([th+usb_d,-th/2,br_d+1])cube(size=[usb_w,2*th,bh+th],center=false);
		translate([bx+th-pwr_w-pwr_d,-th/2,br_d+1.5])cube(size=[pwr_w,2*th,bh+th],center=false);

		// remove pilot holes for arduino 
        // (thickness added to coordinate locations to account for wall of tray)
		translate([hx1+th,hy1+th],0)cylinder(h=3*th,r=pdiam/2, center=true);
		translate([hx2+th,hy2+th],0)cylinder(h=3*th,r=pdiam/2, center=true);
		translate([hx3+th,hy3+th],0)cylinder(h=3*th,r=pdiam/2, center=true);
		translate([hx4+th,hy4+th],0)cylinder(h=3*th,r=pdiam/2, center=true);

		// remove grid from bottom to improve print speed and heat reduction
		for (i=[0:2]){
			for (j=[0:2]){
				translate([th+br+i*(br+dsx),th+br+j*(br+dsy),-th-2])cube(size=[dsx,dsy,th+4]);
			}
		}
	}
}

//------------
// Add interror braces to the corners to hold arduino level and improve fit
//------------
// support at USB corner
cube(size=[10,2*th,br_d]);
cube(size=[2*th,10,br_d]);

// support at power cord corner
translate([bx+2*th-10, 0, 0])cube(size=[10,2*th,br_d]);
translate([bx+2*th-2*th, 0, 0])cube(size=[2*th,10,br_d]);

// support between USB and power openings
translate([usb_d+usb_w+6+th, 0, 0])cube(size=[10,2*th,br_d]);

// supports at side opposite power/USB openings
translate([hx3-12-pdiam/2, by, 0])cube(size=[12,2*th,br_d]);
translate([th+6, by-2.5, 0])cube(size=[8,2.5+2*th,br_d]);		
