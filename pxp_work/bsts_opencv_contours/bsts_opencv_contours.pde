import gab.opencv.*;
import processing.video.*;

PImage ourImage; 

int time = 0;
Movie video;
OpenCV opencv;
OpenCV opencv2;

boolean doTripOut = false;

void setup() {
  size(1280, 720);
  //video = new Movie(this, "street.mov");
  video = new Movie(this, "bsts_masked2.mp4"); 
  //opencv = new OpenCV(this, 720, 480);

  opencv = new OpenCV(this, 1280, 720);


  opencv.startBackgroundSubtraction(5, 3, 0.5);


  opencv2 = new OpenCV(this, 1280, 720);


  opencv2.startBackgroundSubtraction(5, 3, 0.5);

  video.loop();
  video.play();
  video.speed(0.5);

  ourImage =  createImage(width, height, ARGB);       // create an empty image with Alpha
  ourImage.loadPixels();
  for (int x = 0; x < width; x++) {                     // we want to start out with all the pixels
    for (int y = 0; y < height; y++) {                // in our image having an alpha of 0
      PxPSetPixel(x, y, 0, 0, 0, 0, ourImage.pixels, width);
    }
  }
  ourImage.updatePixels();
}

void draw() {
  ourImage.loadPixels();
  image(video, 0, 0);  
  opencv.loadImage(video);

  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(0, sin(mouseX), mouseX);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }

  if (doTripOut == true){
  if (millis() - time >= 500)
  {
    drawAbove();
    time = millis();
  }}
  ourImage.updatePixels();
  image (ourImage, 0, 0);              // and the painted pixels above

  if (mousePressed) {
    for (int x = mouseX-100; x< mouseX+100; x++) {               // lets do the effect for 50 pixels around the mouse
      for (int y = mouseY-100; y< mouseY+100; y++) {
        //if (dist(x, y, mouseX, mouseY)<100) {       
        int useX=  constrain(x, 0, width-1);                                // make sure were not acceesing pixels out side of the pixels array
        int useY=  constrain(y, 0, height-1);
        PxPGetPixel(useX, useY, video.pixels, width);  
        PxPSetPixel(useX, useY, R, G, B, 255, ourImage.pixels, width);        // setting the colors from the video to our image
        //}
      }                                                                       // important to set alpha to 255
    }
  }

}

void movieEvent(Movie m) {
  m.read();
}

void drawAbove() {
  image(video, 0, 0);  
  opencv2.loadImage(video);

  opencv2.updateBackground(); 

  opencv2.dilate();
  opencv2.erode();

  //noFill();
  //stroke(random(255), random(255), random(255));
  //strokeWeight(random(255));
  for (Contour contour : opencv2.findContours()) {
    noFill();
    stroke(random(255), random(255), random(255), mouseX);
    //strokeWeight(random(255));

    strokeWeight(mouseY);
    contour.draw();
  }

}



void keyPressed() {
   if (key == CODED) {

    if (keyCode == UP) {

      ourImage =  createImage(width, height, ARGB); 

    } else if (keyCode == DOWN) {
      ourImage.loadPixels();
      tint(255,123);
      ourImage.updatePixels();
      

    } else if (keyCode == LEFT){
          doTripOut = false;  
    
    } else if (keyCode == RIGHT){
           doTripOut = true; 
     
     
    } 

  } 

}




// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
