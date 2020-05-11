//They're watching Us or are WE watching Us - self surveillance  
//by Jake Sherwood
//modified random displacement by Danny Rozin
//using opencv to trigger displacement based on registered face dist to ellipse.
//displaced pixels are are recolored based on mouseX & mouseY
//redrawing random sections of video with random colors, alphas, & positions




import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
float angle;

int fX;
int fY;


int time;
int timeDelay;

void setup() {
  size(1080, 720);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();

  time = millis();
  timeDelay = 0000;
}

void draw() {
  //scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(random(0, 255), random(0, 255), random(0, 255));
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);




  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    fX = faces[i].x;
    fY = faces[i].y;
  }


  int elX = width -100;
  int elY = height -100;

  noStroke();
  fill(0, 0, 255); 
  ellipse(elX, elY, 50, 50);

  float d = dist(elX, elY, fX, fY);

  print("distance to ellipse = ");
  println(d);



  int fromX = (int) random(width);
  int fromY = (int) random(height);  


  int toX = fromX + (int) random(mouseX);
  int toY = fromY + (int) random(mouseY);  

  if (d < 675) {
    disolvePix();
    //background(255,0,0);

    updatePixels();
  } else {

    if (millis() > time + timeDelay) {
      video.loadPixels();
      time = millis();
    }
  }

  tint(random(0, 255), random(0, 255), random(0, 255), random(255));
  //copy(video, fromX,fromY,200,200,toX,toY,200,200);   

  // get
  PImage segment = video.get(fromX, fromY, toX, toY);
  // resize
  segment.resize(toX, toY);
  // display (tint does work)
  image(segment, toX, toY);
  copy(video, fromX, fromY, 200, 200, toX, toY, 200, 200);
}

void captureEvent(Capture c) {
  c.read();
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



void disolvePix() {

  if (video.available())  video.read();           // get a fresh frame as often as we can
  video.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 
  //randomSeed(0);          // add this to get the random not flicker
  for (int x =  0; x< width; x++) {                   // visit all pixels
    for (int y = 0; y< height; y++) {    
      float distToMouse= dist(mouseX, mouseY, x, y)/50;       // get the distance from the mouse to this pixel
      float sourceX= x+ random(-distToMouse, distToMouse);     // calculate a displacement porportional to the distance to mouse
      float sourceY= y+ random(-distToMouse, distToMouse);
      sourceX= constrain(sourceX, 0, width-1);               // make sure we are still in the image
      sourceY= constrain(sourceY, 0, height-1);
      PxPGetPixel(int(sourceX), int(sourceY), video.pixels, width);      // get the R,G,B of the pixel
      //PxPSetPixel(x, y, R, G, B, 255, pixels, width);                        // set the RGB of our to screen
      PxPSetPixel(x, y,  R+mouseX, G+mouseY, B, 255, pixels, width);                        // set the RGB of our to screen
     
  
}
  }
}
