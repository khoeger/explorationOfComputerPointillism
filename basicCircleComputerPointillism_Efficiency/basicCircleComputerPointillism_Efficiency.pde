/* 
 Emulate painting by covering with circles to make an output picture 
 given a base picture.
 
 Each layer of dots placed down takes up only a proportion of the
 entire screen.
 
 All dots of the same width are placed down at the same time.
 */

//import processing.svg.*;


// -- Constants
color baseColor = color( 255 );                       // background color

float proportion = 0.0175;                              // decimal rep. of percentage of total area to be covered   

float scalar = 1;                                     // if the base picture is small, how much to enlarge it

String imageName = "DSCF1111";                    // base picture name
String imageType =".JPG";
String imagePrefix ="../../resources/";
String prefix = str(year())+str(month())+str(day())+str(hour())+str(minute())+"/";

int maxShapeWidth = 255;                                // maximum width of dot dimension
int shapeWidthIncrement = 1;                            // width decreases by this
int shapeHeightIncrement = shapeWidthIncrement;         // height decreases by this


int borderSpace = 150;                                  // width of the border, should be > maxShapeWidth / 2

// -- Class instantiation
PImage img;                                             // base image will be accessed here                                  

// -- Variables 
int x, y, loc;
float r, g, b, a;
int maxFrames;

// -- Initializations of variables
int alphaValue = 0;                                     // initial alpha value
int spotsDrawn = 0;                                     // initial number of dots placed   
int shapeWidth = maxShapeWidth;                         // initial shape width
int shapeHeight = shapeWidth;                           // initial shape height

// -- Processing Main Functions
void setup() {
  //size(1830, 1907);   // Dimensions of input image + 2*borderSpace
  //size( displayHeight, displayHeight); // min Dimension of image, twice
  //size( 2892, 2028);  // carp
  //size(2644, 2644, SVG, "documentation/mileyBlackBackground.svg"); 
  size(3756, 4908); 

 
  // load image
  img = loadImage(imagePrefix+imageName+imageType);
  img.resize(0, height - 2* borderSpace);
  //img.resize( width - 2* borderSpace, 0);

  // Calculate max frames
  maxFramesNow();
  
  // Administrivia
  background(baseColor);
  smooth();
  noStroke();
  
  println("Start Time:", str(hour())+":"+ str(minute())+":"+str( second()));

}
void draw() {
  // -- Draw all sole spots of their size
  if ( maxFrames == 1) {
    push();                                        // shift for border 
    translate(borderSpace, borderSpace);

    pickASpotToDraw();                             // choose place
    rgbaColorLookup();                             // get color data
    drawShape();                                   // draw shape at location
    spotsDrawn += 1;                               // increment number of spotsDrawn

    pop();                                         // end shift for border

    //println(alphaValue, maxFrames);                // print statement
    //saveNamedFrame();                              // record
    incrementValues();                             // get values ready for next shape

    terminationCheck();                            // check - are we done?
  } else {
    // -- Draw multiple spots of same size
    
    // Draw all spots of size shapeWidth, shapeHeight
    while ( spotsDrawn % maxFrames < maxFrames -1) { 
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);

      pickASpotToDraw();                             // choose place
      rgbaColorLookup();                             // get color data
      drawShape();                                   // draw shape at location
      spotsDrawn += 1;                               // increment number of spotsDrawn

      pop();                                         // end shift for border
    }
    
    // After drawing all spots
    if (spotsDrawn % maxFrames == maxFrames - 1 ) {
      //println(alphaValue, maxFrames);                // print statement
      //saveNamedFrame();                              // record
      incrementValues();                             // get values ready for next shape

      terminationCheck();                            // check - are we done?
    }
  }
}

void pickASpotToDraw() {
  // Pick a random point
  x = int(random(img.width));
  y = int(random(img.height));
  loc = x + y*img.width;
}

void rgbaColorLookup() {
  // Look up the RGB color in the source image
  loadPixels();
  r = red(img.pixels[loc]);
  g = green(img.pixels[loc]);
  b = blue(img.pixels[loc]);
  a = alpha(img.pixels[loc]);
}

void drawShape() {
  // Draw an ellipse at that location with that color
  scale(scalar);
  if (a == 0) {                            // if over transparent background
  } else {
    fill(r, g, b, alphaValue);
    ellipse(x, y, shapeWidth, shapeHeight);
  }
}

void incrementValues() {
  // increment / reset values
  alphaValue += 1;    // make paint more solid
  shapeWidth -= shapeWidthIncrement;     // decrease shape size
  shapeHeight -= shapeHeightIncrement;  
  spotsDrawn = 0;  // restart frame/shape counter - 1 shape per frame
  println("alpha:",alphaValue, "runtime:", str(millis()* 1/1000 * 1/60)+" minutes");
}

void terminationCheck() {
  // We've drawn all the dots - the paint can't get any more solid / less opaque
  if (alphaValue >= 255) {
    println("DONE!", proportion, str(millis()* 1/1000 * 1/60)+" minutes" );// millis * 1/1000 = seconds ; seconds * 1/60 = minutes
    // save to documentation
    saveFrame("documentation/"+imageName+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");
   
    exit();
  } else {
    maxFramesNow();     // calculate number of shapes should draw next
  }
}

void mouseClicked() {       // so that we can see output, no matter where we are in loop
  println("Mouse Clicked!");
  saveNamedFrame();
}

void maxFramesNow() {      // calculate the number of frames to draw
  maxFrames = ceil(( width * height / (shapeWidth * shapeHeight))*proportion);
}

void saveNamedFrame() {    // save file
  saveFrame("outputs/"+imageName+"/"+str(proportion)+"_"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_"+str(maxShapeWidth)+"/"+prefix+imageName+"_"+"_"+str(alphaValue)+"_"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");
}
