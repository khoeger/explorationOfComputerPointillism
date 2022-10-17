
void pickASpotToDraw() {
  // Pick a random point in current image
  x = int(random(img.width));
  y = int(random(img.height));
  loc = x + y*img.width;
  countDots +=1;
}

void rgbaColorLookup() {
  // Look up the RGB color in the source image
  HashMap<Integer, Integer> currentHash = hashMapArray.get(currentIndex);  // return hash map for index
  color currentPixelColor =  currentHash.get(loc);
  r = red(currentPixelColor);
  g = green(currentPixelColor);
  b = blue(currentPixelColor);
  a = alpha(currentPixelColor);
}
