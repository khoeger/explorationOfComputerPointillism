/* 
 Emulate painting by covering with circles to make a picture
 */

color baseColor = color( 255, 255, 255);

float proportion = 0.005;

int maxShapeWidth = 255;

int borderSpace = 150;

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
int framesCounter = 0;

void setup() {
  size(1830, 1907);   // Dimensions of input image + *borderSpace

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
  push();
  translate(borderSpace, borderSpace);

  // Pick a random point
  int x = int(random(img.width));
  int y = int(random(img.height));
  int loc = x + y*img.width;

  // Look up the RGB color in the source image
  loadPixels();
  float r = red(img.pixels[loc]);
  float g = green(img.pixels[loc]);
  float b = blue(img.pixels[loc]);
  float a = alpha(img.pixels[loc]);

  // Draw an ellipse at that location with that color
  scale(scalar);
  if (a == 0) {
  } else {
    fill(r, g, b, alphaValue);
    ellipse(x, y, shapeWidth, shapeHeight);
  }
  

  // Have drawn as many shapes as fit our limit - 1 shape per frame!
  if (framesCounter % maxFrames == maxFrames - 1) {
    // Record
    println(alphaValue, maxFrames);
    saveNamedFrame();
    // increment values
    alphaValue += 1;    // make paint more solid
    shapeWidth -= shapeWidthIncrement;     // decrease shape size
    shapeHeight -= shapeHeightIncrement;  
    framesCounter = 0;  // restart frame/shape counter - 1 shape per frame

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

  // increment number of frames
  framesCounter += 1;
  pop();
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
