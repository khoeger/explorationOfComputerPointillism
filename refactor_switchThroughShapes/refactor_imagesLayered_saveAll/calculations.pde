void maxFramesNow() {      // calculate the number of frames to draw
  maxFrames = ceil(( width * height / (shapeWidth * shapeHeight))*proportion);
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
  //println("alpha:", alphaValue, "runtime:", str(millis()* 1/1000 * 1/60)+" minutes");
}

void terminationCheck() {
  // We've drawn all the dots - the paint can't get any more solid / less opaque
  if (alphaValue >= 255) {
    println("DONE!", proportion, str(millis()* 1/1000 * 1/60)+" minutes" );// millis * 1/1000 = seconds ; seconds * 1/60 = minutes
    // save to documentation
    //saveFrame("documentation/"+shapeType+"/"+imageName+"_"+shapeType+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");
    //println("Saved to");
    //println("documentation/"+shapeType+"/"+imageName+"_"+shapeType+"_"+str(proportion)+"_canvas"+str(width)+"x"+str(height)+"_"+hex(baseColor)+"_max"+str(maxShapeWidth)+"_min"+str(shapeWidth)+"x"+str(shapeHeight)+".jpg");

    //exit();
    
    long maxMemory = Runtime.getRuntime().maxMemory();
    long allocatedMemory = Runtime.getRuntime().totalMemory();
    long freeMemory = Runtime.getRuntime().freeMemory();
    
    println("max memory", "\t", "allocated memory", "\t", "free memory");
    println(maxMemory, "\t", allocatedMemory, "\t\t", freeMemory);
    
    println("# of Dots:", countDots);
    currentIndex = floor(random(imageStringArray.length));
    img = imageArray.get(currentIndex);
    currentHashName =  imageStringBase + imageStringArray[currentIndex];
    resetValues();
  } else {
    maxFramesNow();     // calculate number of shapes should draw next
  }
}
String resetValues() {
  alphaValue = 0;
  shapeWidth = maxShapeWidth;
  shapeHeight = maxShapeHeight;
  spotsDrawn = 0;
  countDots = 0;
  shapeType = shapeOptions[int(random(shapeOptions.length))];//15];
  setShapeModes();
  return("Values Reset");
}
