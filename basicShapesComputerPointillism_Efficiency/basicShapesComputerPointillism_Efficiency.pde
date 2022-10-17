/* 
 Emulate painting by covering with circles to make an output picture 
 given a base picture.
 
 Each layer of dots placed down takes up only a proportion of the
 entire screen.
 
 All dots of the same width are placed down at the same time.
 
 Adding a function that chooses shapes
 */

// -- Constants
color baseColor = color(255);//163, 189, 204);// 0 );                       // background color

float proportion = 0.0125;                              // decimal rep. of percentage of total area to be covered   

float scalar = 1;                                     // if the base picture is small, how much to enlarge it
int seed = 20221006;
String[] wordArray = {"JAMES", "BEAU", "TURNER"};
PFont myFont;

//headshots\KatarinaHoeger_Standard_ZoomedIn_PhotoArturoC.jpg
//String imageName = "headshots/KatarinaHoeger_Standard_ZoomedIn_PhotoArturoC";                    // base picture name
////String imageName = "umberto_boccioni-trivium-art-history";//"dynamism-of-a-soccer-player-digital-remastered-edition-umberto-boccioni";
//String imageType =".jpg";
String imageName = "businessCard/20_KatarinaHoeger_Opening4Alt";                    // base picture name
String imageType =".jpg";


String[] shapeOptions = { "circle", // 0
  //"ellipse", // 1  
  //"ellipseRotate", // 2 
  ////"imageIn", // 3
  ////"imageInRotate", // 4
  ////"imageInRotateFlip", // 5 BROKEN?
  //"line", // 6
  //"lineRotate", // 7
  //"lineWeight", // 8
  //"lineWeightRotate", // 9 
  //"rect", // 10 
  //"rectRotate", // 11
  //"triangle", // 12
  //"triangleRotate", // 13
  //"square", // 14 
  //"squareRotate", //15
  //"word"
};
String shapeType = shapeOptions[0];//15];
String imagePrefix ="../../../resources/";
//String imagePrefix = "../../../resources/";
//String imagePrefix = "../../../resources/2592x1728/";
String prefix = str(year())+str(month())+str(day())+str(hour())+str(minute())+"/";

int maxShapeWidth = 512;   // 10 + 2 * 256 = 10 + 502                             // maximum width of dot dimension
int maxShapeHeight = maxShapeWidth;// +int(random(10, 50));
int shapeWidthIncrement = 2;                            // width decreases by this
int shapeHeightIncrement = shapeWidthIncrement;         // height decreases by this


int borderSpace = 300;                                  // width of the border, should be > maxShapeWidth / 2

// -- Class instantiation
PImage img;    // base image will be accessed here  

//String component1 = imagePrefix + "/soccerSources/" + "soccerBallWhite.png";
//String component2 = imagePrefix + "/soccerSources/" + "playerWhite.png";
//PImage componentImg1, componentImg2;

PImage components[];

// -- Variables 
int x, y, loc;
float r, g, b, a;
int maxFrames;

// -- Initializations of variables
int alphaValue = 0;                                     // initial alpha value
int spotsDrawn = 0;                                     // initial number of dots placed   
int shapeWidth = maxShapeWidth;                         // initial shape width
int shapeHeight = maxShapeHeight;                           // initial shape height

// -- Processing Main Functions
void setup() {
  //size(1830, 1907);   // Dimensions of input image + 2*borderSpace
  //size( displayHeight, displayHeight); // min Dimension of image, twice
  //size(4908, 3756); // LOTUS  
   //size(9816,7512); // Double Lotus
   //size(2503, 2503); //LOTUS CIRCLE
   //size(5006, 5006); // Double Lotus circle
  //size(2892, 2028);
  //size(1200, 1164); // boccioniSmaller
  //size(2162, 2101);
  size(  6144 , 4444 );   //5120 , 3420
  // load image
  img = loadImage( imagePrefix + imageName + imageType );
  //img.resize( 0 , height - 2 * borderSpace );
  //img.resize( width - 2* borderSpace, 0);
  img.resize( width - 2* borderSpace , height - 2 * borderSpace ); // both 

  //componentImg1 = loadImage(component1);
  ////componentImg1.resize(shapeWidth, 0);
  //componentImg1.resize(0, shapeWidth);
  //componentImg2 = loadImage(component2);
  ////componentImg1.resize(shapeWidth, 0);
  //componentImg2.resize(0, shapeWidth);


  //components = new PImage [2];
  //components[0] = componentImg1;
  //components[1] = componentImg2;

  // Calculate max frames
  maxFramesNow();

  // Administrivia
  background(baseColor);

  setShapeModes();
  //rectMode(CENTER);
  smooth();
  noStroke();
  randomSeed(seed);
  
  myFont = createFont("Twenty-Five Normal", floor( 0.45*min(width,height)));
  textFont(myFont);

  println("Start Time:", str(hour())+":"+ str(minute())+":"+str( second()));
}
void draw() {
  // -- Draw all sole spots of their size
  if ( maxFrames == 1) {


    pickASpotToDraw();                             // choose place
    rgbaColorLookup();                             // get color data
    drawShape();                                   // draw shape at location
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
      push();                                        // BEGIN for border -- WORDS
      //translate(borderSpace, borderSpace);           // shift for border -- WORDS

      pickASpotToDraw();                             // choose place
      rgbaColorLookup();                             // get color data
      drawShape();                                   // draw shape at location
      spotsDrawn += 1;                               // increment number of spotsDrawn

      pop();                                         // END shift for border -- WORDS
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

void setShapeModes() {
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
  } else if (shapeType == "word") {
    //textMode(CENTER);
    textAlign(CENTER, CENTER);
  }

  //  "triangle", // 12
  //  "triangleRotate", // 13
}

void drawShape() {
  // Draw an ellipse at that location with that color
  scale(scalar);
  if (a == 0) {                            // if over transparent background
  } else {
    //                      "lineWeight",
    //                      "lineWeightRotate",
    //                      "rect",
    //                      "rectRotate",
    //                      "triangle",
    //                      "triangleRotate",
    //                      "square"
    if (shapeType == "circle") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate(x, y );
      fill(r, g, b, alphaValue);
      ellipse(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
      pop();
    } else if (shapeType == "ellipse") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate(x, y );
      fill(r, g, b, alphaValue);
      ellipse(0, 0, shapeWidth, shapeHeight);
      pop();
      pop();
    } else if (shapeType == "ellipseRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate(x, y );      
      rotate(random(2*PI));
      fill(r, g, b, alphaValue);
      ellipse(0, 0, shapeWidth, shapeHeight);
      pop();
      pop();
    } /*else if (shapeType == "imageIn") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      tint(r, g, b, alphaValue);
      translate( x, y );      
      image(components[round(random(-0.49, 1.49))], 0, 0);
      pop();
      pop();
    } else if (shapeType == "imageInRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      tint(r, g, b, alphaValue);
      translate(x, y);
      rotate(random(2*PI));
      image(components[round(random(-0.49, 1.49))], 0, 0);
      pop();
      pop();
    } else if (shapeType == "imageInRotateFlip") {
      push();                                        // shift for border 
      int[] options = {-1, 1};
      translate(borderSpace, borderSpace);
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
      pop();
    } */else if (shapeType == "line") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      line(-shapeWidth/2, -shapeHeight/2, shapeWidth/2, shapeHeight/2);
      pop();
      pop();
    } else if (shapeType == "lineRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      rotate(random(2*PI));
      line(-shapeWidth/2, -shapeHeight/2, shapeWidth/2, shapeHeight/2);
      pop();
      pop();
    } else if (shapeType == "lineWeight") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      strokeWeight(alphaValue/100 + random(10));
      line(-shapeWidth/2, -shapeHeight/2, shapeWidth/2, shapeHeight/2);
      pop();
      pop();
    } else if (shapeType == "lineWeightRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      stroke(r, g, b, alphaValue);
      strokeWeight(alphaValue/100 + random(10));
      rotate(random(2*PI));
      line(-shapeWidth/2, -shapeHeight/2, shapeWidth/2, shapeHeight/2);
      pop();
      pop();
    } else if (shapeType == "rect") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rect(0, 0, shapeWidth, shapeHeight);
      pop();
      pop();
    } else if (shapeType == "rectRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rotate(random(2*PI));
      rect(0, 0, shapeWidth, shapeHeight);
      pop();
      pop();
    } else if (shapeType == "triangle") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      triangle(- shapeWidth/2, shapeHeight/2, 
        0, -shapeHeight/2, 
        shapeWidth/2, shapeHeight/2);
      pop();
      pop();
    } else if (shapeType == "triangleRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rotate(random(2*PI));
      triangle(- shapeWidth/2, shapeHeight/2, 
        0, -shapeHeight/2, 
        shapeWidth/2, shapeHeight/2);  
      pop();
      pop();
    } else if (shapeType == "square") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );      
      fill(r, g, b, alphaValue);
      rect(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
      pop();
    } else if (shapeType == "squareRotate") {
      push();                                        // shift for border 
      translate(borderSpace, borderSpace);
      push();
      translate( x, y );    
      rotate(random(2*PI));
      fill(r, g, b, alphaValue);
      rect(0, 0, min(shapeWidth, shapeHeight), min(shapeWidth, shapeHeight));
      pop();
      pop();
    }
    else if (shapeType == "word"){
      push();
      translate( x, y );    
      fill(r, g, b, alphaValue);
      text(wordArray[round(random(-0.49, wordArray.length -1 + 0.49))], 0, 0);
      pop();      
    }
  }
}

void incrementValues() {
  // increment / reset values
  alphaValue += 1;    // make paint more solid
  shapeWidth -= shapeWidthIncrement;     // decrease shape size
  shapeHeight -= shapeHeightIncrement;  
  spotsDrawn = 0;  // restart frame/shape counter - 1 shape per frame
  //components[0].resize(0, shapeWidth); // resize image
  //components[1].resize(0, shapeWidth); // resize image
  textSize( max(shapeWidth, shapeHeight) );
  println("alpha:", alphaValue, "runtime:", str(millis()* 1/1000 * 1/60)+" minutes");
}

void terminationCheck() {
  // We've drawn all the dots - the paint can't get any more solid / less opaque
  if (alphaValue >= 255) {
    println("DONE!", proportion, str(millis()* 1/1000 * 1/60)+" minutes" );// millis * 1/1000 = seconds ; seconds * 1/60 = minutes
    // save to documentation
    saveFrame("documentation/"+shapeType+"/"+imageName+"_"+shapeType+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");
    println("Saved to");
    println("documentation/"+shapeType+"/"+imageName+"_"+shapeType+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");

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
