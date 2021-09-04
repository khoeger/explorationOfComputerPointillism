/* 
 Emulate painting by covering with circles to make a picture
 */

color baseColor = color( 255, 255, 255);

float proportion = 0.0075;

int maxShapeWidth = 255;

int borderSpace = 150;

int x, y, loc;
float r, g, b, a;

int shapeWidthIncrement = 1; 
int shapeHeightIncrement = shapeWidthIncrement;
int shapeWidth = maxShapeWidth;
int shapeHeight = shapeWidth;

float scalar = 1;
float framesScalar = 1;

String imageName = "publicDomainApple";
String imageType =".png";
String imagePrefix ="../../resources/";
String prefix = str(year())+str(month())+str(day())+str(hour())+str(minute())+"/";

PImage img;
PImage particle1;

int alphaValue = 0;

int maxFrames;
int spotsDrawn = 0;

void setup() {
  size(1830, 1907);   // Dimensions of input image + 2*borderSpace

  // load image
  img = loadImage(imagePrefix+imageName+imageType);

  // Calculate max frames
  maxFramesNow();
  // Administrivia
  background(baseColor);
  smooth();
  noStroke();
  //imageMode(CENTER);
}
void draw() {

  while ( spotsDrawn % maxFrames < maxFrames - 1) { // 

    push();                                        // shift for border 
    translate(borderSpace, borderSpace);

    pickASpotToDraw();                             // choose spot
    rgbaColorLookup();                             // get color data
    drawShape();                                   // draw shape at location
    spotsDrawn += 1;                               // increment number of spotsDrawn

    pop();                                         // end shift for border
  }
  // Have drawn as many shapes as fit our limit - 1 shape per frame!
  if (spotsDrawn % maxFrames == 1){
    // Record
    println(alphaValue, maxFrames);
    saveNamedFrame();
    incrementValues();
  }
  else if (spotsDrawn % maxFrames == maxFrames - 1 ) {
    // Record
    println(alphaValue, maxFrames);
    saveNamedFrame();
    incrementValues();
    
    // We've drawn all the dots - the paint can't get any more solid / less opaque
    if (alphaValue >= 255) {
      println("DONE!");
      // save to documentation
      saveFrame("documentation/"+imageName+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");

      exit();
    } else {
      maxFramesNow();     // calculate number of shapes should draw next
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

}

void mouseClicked() {       // so that we can see output, no matter where we are in loop
  println("Mouse Clicked!");
  saveNamedFrame();
}

void maxFramesNow() {      // calculate the number of frames to draw
  maxFrames = ceil(( width * height / (shapeWidth * shapeHeight))*proportion);
}

void saveNamedFrame() {    // save file
  saveFrame("outputs/"+imageName+"/"+str(proportion)+"_"+str(width)+"x"+str(height)+"/"+hex(baseColor)+"/"+str(maxShapeWidth)+"/"+prefix+imageName+"_"+"_"+str(alphaValue)+"_"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");
}
