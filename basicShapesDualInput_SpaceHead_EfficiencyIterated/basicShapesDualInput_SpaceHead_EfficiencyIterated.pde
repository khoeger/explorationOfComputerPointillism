/* 
 Emulate painting by covering with circles to make an output picture 
 given a base picture.
 
 Each layer of dots placed down takes up only a proportion of the
 entire screen.
 
 All dots of the same width are placed down at the same time.
 
 Adding a function that chooses shapes
 */

// -- Constants
color baseColor = color(255);//63, 60, 82 );                       // background color

float proportion = 0.05;//float(8)/float(26);                              // decimal rep. of percentage of total area to be covered   

float scalar = 1;                                     // if the base picture is small, how much to enlarge it
int seed = 110608;//0;

String initialDateTime = str( year() )+ "_" +str( month() )+ "_" + str(day())+ "_" + str(hour() )+ "_" + str(minute());
String firstName = "katarina";
String lastName = "hoeger";
String[] wordArray = {"K","A","T","A","R","I","N","A"};
String altShape = "word";
String placeHolderShape;

PFont myFont;

// "headshots/KatarinaHoeger_Standard_ZoomedIn_PhotoArturoC";                    // base picture name
String personName = firstName + "_" + lastName;
String image1 = personName+"_space_whiteCircle.jpg";
String image2 = personName+"_circle.png";
//String shapeImg = "gusuLan.png"; // "yumengJiang.png";//
String imageName = personName+"_merged_"; //"artichokeBee";                    // base picture name
float imageLikelihood = 0.005;
PImage currentImage, shapeImage;
//String imageType =".JPG";
String[] shapeOptions = { "circle", // 0
  //"ellipse", // 1  
  //"ellipseRotate", // 2 
  //"imageIn", // 3
  //"imageInRotate", // 4
  //"imageInRotateFlip", // 5 BROKEN?
  //"line", // 6
  //"lineRotate", // 7
  //"lineWeight", // 8
  //"lineWeightRotate", // 9 
  //"rect", // 10 
  //"rectRotate", // 11
  //"triangle", // 12
  //"triangleRotate", // 13
  //"square", // 14 
  //"squareRotate" //15
  //, "word"
};
int shapeTypeIndex = 0;
String shapeType;// = shapeOptions[15];
//String imagePrefix ="../../resources/";
//String imagePrefix = "../../../resources/";

String imagePrefix = "../../resources/mergeSpacePerson/"+personName+"/";
String prefix = str(year())+str(month())+str(day())+str(hour())+str(minute())+"/";

int maxShapeWidth = 256;//76;                                // maximum width of dot dimension
int maxShapeHeight = maxShapeWidth +int(random(10, 50));
int shapeWidthIncrement = 1;                            // width decreases by this
int shapeHeightIncrement = shapeWidthIncrement;         // height decreases by this


int borderSpace = 150;                                  // width of the border, should be > maxShapeWidth / 2

// -- Class instantiation
PImage[] imgs = new PImage[2];    // base image will be accessed here  

//int numComponents = 4;
//String component1 = imagePrefix +  personName+"_item1.png";
//String component2 = imagePrefix +  personName+"_item2.png";
//String component3 = imagePrefix +  personName+"_item3.png";
//String component4 = imagePrefix +  personName+"_item4.png";

////String component2 = imagePrefix + "/soccerSources/" + "playerWhite.png";
//PImage componentImg1, componentImg2, componentImg3, componentImg4;

//PImage components[];

// -- Variables 
int x, y, loc;
float r, g, b, a;
int maxFrames;

// -- Initializations of variables
int alphaValue = 0;                                     // initial alpha value
int spotsDrawn = 0;                                     // initial number of dots placed   
int shapeWidth = maxShapeWidth;                         // initial shape width
int shapeHeight = maxShapeHeight;                           // initial shape height

String frameName;

// -- Processing Main Functions
void setup() {
  //size(1830, 1907);   // Dimensions of input image + 2*borderSpace
  //size( displayHeight, displayHeight); // min Dimension of image, twice
  //size(4908, 3756);   
  //size(3192, 2328);
  //size(1200, 1164); // boccioniSmaller
  //size(2162, 2101);
  size(5778, 5778);//displayHeight, displayHeight);
  imageMode(CENTER);

  // load image

  String imgName1 = imagePrefix+image1;
  println(imgName1);
  imgs[0] = loadImage(imgName1);
  println("pass");
  //imgs[0].resize(0, height - 2* borderSpace);
  imgs[0].resize( height - 2* borderSpace, 0);

  String imgName2 = imagePrefix+image2;
  println(imgName2);
  imgs[1] = loadImage(imgName2);
  println("pass");
  //imgs[1].resize(0, height - 2* borderSpace);
  imgs[1].resize(height - 2* borderSpace, 0);
  shapeImage = imgs[1];

//  String shapeImagePath = imagePrefix + shapeImg;
//  shapeImage = loadImage(shapeImagePath);
//  //shapeImage.resize(0, height-2*borderSpace);
//    shapeImage.resize(height-2*borderSpace, 0);



  //img.resize( width - 2* borderSpace, 0);


  //componentImg1 = loadImage(component1);
  //componentImg1.resize(shapeWidth, 0);             // if narrower than tall
  ////componentImg1.resize(0, shapeHeight);          // if wider than tall


  //componentImg2 = loadImage(component2);
  //componentImg2.resize(shapeWidth, 0);             // if narrower than tall
  ////componentImg1.resize(0, shapeHeight);          // if wider than tall

  //componentImg3 = loadImage(component3);
  ////componentImg3.resize(shapeWidth, 0);             // if narrower than tall
  //componentImg3.resize(0, shapeHeight);          // if wider than tall
  
  //componentImg4 = loadImage(component4);
  ////componentImg4.resize(shapeWidth, 0);             // if narrower than tall
  //componentImg4.resize(0, shapeHeight);          // if wider than tall
  
  //components = new PImage [numComponents];
  //components[0] = componentImg1;
  //components[1] = componentImg2;//2;
  //components[2] = componentImg3;
  //components[3] = componentImg4;//2;

  myFont = createFont("Twenty-Five Normal", floor( 0.45*min(width,height)));
  textFont(myFont);
  
  resetShapeInputs();

  

  println("Start Time:", str(hour())+":"+ str(minute())+":"+str( second()));
}
void draw() {
  //// -- Draw all sole spots of their size
  if ( maxFrames == 1) {


    pickASpotToDraw();                             // choose place
    //imageToDraw();
    String inShape = imageToDraw3(x, y, shapeImage );
    rgbaColorLookup();                             // get color data
    drawShape( inShape );                                   // draw shape at location
    spotsDrawn += 1;                               // increment number of spotsDrawn

    // end shift for border

    //println(alphaValue, maxFrames);                // print statement
    //saveNamedFrame();                              // record
    incrementValues();                             // get values ready for next shape

    terminationCheck();                            // check - are we done?
  } else {
  // -- Draw multiple spots of same size

   // Draw all spots of size shapeWidth, shapeHeight
   while ( spotsDrawn % maxFrames < maxFrames -1) { 


      pickASpotToDraw();                             // choose place
      //imageToDraw();
      String inShape = imageToDraw3(x, y, shapeImage );
      rgbaColorLookup();                             // get color data
      drawShape( inShape );                                   // draw shape at location
      spotsDrawn += 1;                               // increment number of spotsDrawn

    }
    // After drawing all spots
    if (spotsDrawn % maxFrames == maxFrames - 1 ) {
      //println(alphaValue, maxFrames);                // print statement
      //saveNamedFrame(frameName);                              // record
      incrementValues();                             // get values ready for next shape

      terminationCheck();                            // check - are we done?
    }
    
    //saveFrameName();
  }
}

void imageToDraw() {
  if (random(0, 1) < imageLikelihood) {
    currentImage = imgs[0];
  } else {
    currentImage = imgs[1];
  }
}

void imageToDraw2( int x_, int y_, PImage img_) {
  // if outside the boundaries, do normal, 
  float centerX = imgs[0].width/2;
  float centerY = imgs[0].height/2;
  float templateL = centerX - img_.width/2;
  float templateR = centerX + img_.width/2;
  float templateT = centerY - img_.height/2;
  float templateB = centerY + img_.height/2;
  
  // is x to the left of left or right of right? make space
  if ( x_ < templateL | x_ > templateR ) {
    currentImage = imgs[0];

  } else if (  y_ < templateT | y_ > templateB ) {
    // if y is above top or below bottom, make space
    currentImage = imgs[0];

  } else { // it's in template land

    float x_prime = float(x_) -(imgs[1].width- img_.width)/2 ;
    float y_prime = float(y_) - (imgs[1].height - img_.height)/2;


    int tempLoc = floor(x_prime) + floor(y_prime)*img_.width;

    
    float tempA = alpha(img_.pixels[tempLoc]);
    
  // else -> inside the boundaries
  // if alpha = 0, use cloudMountain pic
  // if alpha = 1, use lotus
    if (tempA < 1 ) { // alpha 0
      currentImage = imgs[0];
    } else {
      currentImage = imgs[1];
    }
  }



  //if (random(0, 1) < imageLikelihood) {
  //  currentImage = imgs[0];
  //} else {
  //  currentImage = imgs[1];
  //}
}

String imageToDraw3( int x_, int y_, PImage img_) {
  // if outside the boundaries, do normal, 
  float centerX = imgs[0].width/2;
  float centerY = imgs[0].height/2;
  float templateL = centerX - img_.width/2;
  float templateR = centerX + img_.width/2;
  float templateT = centerY - img_.height/2;
  float templateB = centerY + img_.height/2;
  String out;
  
  // is x to the left of left or right of right? make space
  if ( x_ < templateL | x_ > templateR ) {
    currentImage = imgs[0];
    out = shapeType;
  } else if (  y_ < templateT | y_ > templateB ) {
    // if y is above top or below bottom, make space
    currentImage = imgs[0];
    out = shapeType;

  } else { // it's in template land

    float x_prime = float(x_) -(imgs[1].width- img_.width)/2 ;
    float y_prime = float(y_) - (imgs[1].height - img_.height)/2;


    int tempLoc = floor(x_prime) + floor(y_prime)*img_.width;

    
    float tempA = alpha(img_.pixels[tempLoc]);
    
  // else -> inside the boundaries
  // if alpha = 0, use cloudMountain pic
  // if alpha = 1, use lotus
    if (tempA < 1 ) { // alpha 0
      currentImage = imgs[0];
      out = shapeType;
    } else {
      currentImage = imgs[1];
      out = altShape;
    }
  }
  return out;
}

void pickASpotToDraw() {
  // Pick a random point
  x = int(random(imgs[0].width));
  y = int(random(imgs[0].height));
  loc = x + y*imgs[0].width;
}

void rgbaColorLookup() {
  // Look up the RGB color in the source image
  loadPixels();
  r = red(currentImage.pixels[loc]);
  g = green(currentImage.pixels[loc]);
  b = blue(currentImage.pixels[loc]);
  a = alpha(currentImage.pixels[loc]);
}

void setShapeModes( String shapeType ) {
  if ( (( shapeType == "circle" ) || 
    ( shapeType == "ellipse" )) || 
    (  shapeType == "ellipseRotate" )
    ) {
    ellipseMode(CENTER);
  } else if ( (( shapeType == "imageIn" ) || 
    ( shapeType == "imageInRotate" )) || 
    (  shapeType == "imageInRotateFlip" )
    ) {
    imageMode(CENTER);
  } else if ( ((( shapeType == "rect" ) || 
    ( shapeType == "rectRotate" )) || 
    ( shapeType == "square" )) ||
    ( shapeType == "squareRotate")
    ) {
    rectMode(CENTER);
  }
  else if (shapeType == "word") {
    //textMode(CENTER);
    textAlign(CENTER, CENTER);
  }

  //  "triangle", // 12
  //  "triangleRotate", // 13
}

void drawShape(String inShape ) {
  // Draw an ellipse at that location with that color
  scale(scalar);
  if (a == 0) {                            // if over transparent background
  } else {
    push();                                        // shift for border 
    float centerScreenX = width / 2;
    float centerScreenY = height / 2;
    float imgLeftX = centerScreenX - currentImage.width /2 ;
    float imgTopY = centerScreenY - currentImage.height /2 ;
    translate(imgLeftX, imgTopY);
    if (inShape == "circle") { 
      push();
      translate(x, y );
      fill(r, g, b, alphaValue);
      ellipse(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
    } else if (inShape == "ellipse") {
      push();
      translate(x, y );
      fill(r, g, b, alphaValue);
      ellipse(0, 0, shapeWidth, shapeHeight);
      pop();
    } else if (inShape == "ellipseRotate") {
      push();
      translate(x, y );      
      rotate(random(2*PI));
      fill(r, g, b, alphaValue);
      ellipse(0, 0, shapeWidth, shapeHeight);
      pop();
    } 
    /*else if (inShape == "imageIn") {
     push();
     tint(r, g, b, alphaValue);
     translate( x, y );      
     image(components[round(random(-0.49, 1.49))], 0, 0);
     pop();
     } else if (inShape == "imageInRotate") {
     push();
     tint(r, g, b, alphaValue);
     translate(x, y);
     rotate(random(2*PI));
     image(components[round(random(-0.49, 1.49))], 0, 0);
     pop();
     } else if (inShape == "imageInRotateFlip") {
     int[] options = {-1, 1};
     push();
     translate(x, y);      
     rotate(random(2*PI));
     push();
     if (random(1) < 0.5) {
     scale( options[int(random(options.length))], 1);
     } else {
     scale( 1, options[int(random(options.length))]);
     }
     tint(r, g, b, alphaValue); 
     image(components[round(random(-0.49, 1.49))], 0, 0);
     pop();
     pop();
     }*/
    else if (inShape == "line") {
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      line(-min(shapeWidth, shapeHeight)/2, -min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2);
      pop();
    } else if (inShape == "lineRotate") {
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      rotate(random(2*PI));
      line(-min(shapeWidth, shapeHeight)/2, -min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2);
      pop();
    } else if (inShape == "lineWeight") {
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      strokeWeight((255 - alphaValue)/10);
      line(-min(shapeWidth, shapeHeight)/2, -min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2);
      pop();
    } else if (inShape == "lineWeightRotate") {
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      strokeWeight((255 - alphaValue)/10);
      rotate(random(2*PI));
      line(-min(shapeWidth, shapeHeight)/2, -min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2, min(shapeWidth, shapeHeight)/2);
      pop();
    } else if (inShape == "rect") {
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rect(0, 0, shapeWidth, shapeHeight);
      pop();
    } else if (inShape == "rectRotate") {
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rotate(random(2*PI));
      rect(0, 0, shapeWidth, shapeHeight);
      pop();
    } else if (inShape == "triangle") {
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      triangle(- shapeWidth/2, shapeHeight/2, 
        0, -shapeHeight/2, 
        shapeWidth/2, shapeHeight/2);
      pop();
    } else if (inShape == "triangleRotate") {
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rotate(random(2*PI));
      triangle(- shapeWidth/2, shapeHeight/2, 
        0, -shapeHeight/2, 
        shapeWidth/2, shapeHeight/2);  
      pop();
    } else if (inShape == "square") {
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rect(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
    } else if (inShape == "squareRotate") {
      push();
      translate( x, y );    
      rotate(random(2*PI));
      fill(r, g, b, alphaValue);
      rect(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
    }
    else if (inShape == "word"){
      push();
      translate( x, y );    
      fill(r, g, b, alphaValue);
      text(wordArray[round(random(-0.49, wordArray.length -1 + 0.49))], 0, 0);
      pop();      
    }
    pop();
  }
}

void incrementValues() {
  // increment / reset values
  alphaValue += 1;    // make paint more solid
  shapeWidth -= shapeWidthIncrement;     // decrease shape size
  shapeHeight -= shapeHeightIncrement;  
  textSize( max(shapeWidth, shapeHeight) );
  spotsDrawn = 0;  // restart frame/shape counter - 1 shape per frame
  //////-- for wide images
  //components[2].resize(0, shapeHeight); // resize image
  //components[3].resize(0, shapeHeight); // resize image
  //////--  for narrow images
  //components[0].resize(shapeWidth, 0);
  //components[1].resize(shapeWidth, 0);
  ////components[2].resize(shapeWidth, 0);
  ////components[3].resize(shapeWidth, 0);
  println("alpha:", alphaValue, "runtime:", str(millis()* 1/1000 * 1/60)+" minutes");
}

void terminationCheck() {
  // We've drawn all the dots - the paint can't get any more solid / less opaque
  if (alphaValue >= 255) {
    println("DONE!", proportion, str(millis()* 1/1000 * 1/60)+" minutes" );// millis * 1/1000 = seconds ; seconds * 1/60 = minutes
    // save to documentation
    frameName = "documentation/"+imageName+"/"+initialDateTime+"/"+imageName+"_"+initialDateTime+"_"+shapeType+"_"+str(proportion)+".jpg";
    saveNamedFrame( frameName );
    shapeTypeIndex ++;
    resetShapeInputs();
  } else {
    maxFramesNow();     // calculate number of shapes should draw next
  }
}

//void saveFrameName(){
//  frameName = "animation/"+imageName+"/"+shapeType+"/"+initialDateTime+"/"+imageName+"_"+initialDateTime+"_"+shapeType+"_"+str(proportion)+"_"+str(frameCount)+".jpg";
//  saveNamedFrame(frameName);
//}
void mouseClicked() {       // so that we can see output, no matter where we are in loop
  println("Mouse Clicked!");
  frameName = "documentation/"+imageName+"/"+initialDateTime+"/"+imageName+"_"+initialDateTime+"_"+shapeType+"_"+str(proportion)+".jpg";
  saveNamedFrame(frameName);
}

void maxFramesNow() {      // calculate the number of frames to draw
  maxFrames = ceil(( width * height / (shapeWidth * shapeHeight))*proportion);
}

void saveNamedFrame( String frameName ) {    // save file
  saveFrame(frameName);
  //println("saved to: ", frameName);
}


void resetShapeInputs() {
  alphaValue = 0;                                     // initial alpha value
  spotsDrawn = 0;                                     // initial number of dots placed   
  shapeWidth = maxShapeWidth;                         // initial shape width
  shapeHeight = maxShapeHeight;  
  currentImage = imgs[0];

  if ( shapeTypeIndex < shapeOptions.length ) {
    shapeType = shapeOptions[shapeTypeIndex];
  } else {
    exit();
  }

  background(baseColor);
  maxFramesNow();
  setShapeModes( shapeType );
  setShapeModes( altShape );
  smooth();
  noStroke();

  randomSeed(seed);
  
  textSize( shapeWidth );
}
