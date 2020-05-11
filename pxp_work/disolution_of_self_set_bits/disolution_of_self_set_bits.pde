// disolution of self
// Jake Sherwood

// Adapted code by Daniel Rozin and Aiden Fowler
// Manipulation of live video
// Posterizing, Invertions, Saturations, & SmokeyBits based on keyPress and mouse positions

import processing.video.*;

int boxWidth = 200;
int boxHeight = 155;
float size;

int posterizePointX;

int R, G, B, A;          // you must have these global variables to use the PxPGetPixel()
int origR, origB, origG, origA; //original values to use again
int tempR, tempG, tempB;
int pixel;
int s = 0;

int randomXThresh;

int goSmokey,goInverse, setSmokeyBits;




Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();                               // start the video
   noCursor();
 
  
}

void draw() {
    
  
  if (setSmokeyBits == 1){
  randomXThresh = mouseY;
  }
  
  size = random(20, 255);
  if (ourVideo.available())  ourVideo.read();      // get a fresh frame as often as we can
  ourVideo.loadPixels();                     // load the pixels array of the video 
  loadPixels();                              // load the pixels array of the window  
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourVideo.pixels, width);     // get the RGB of our pixel and place in RGB globals
      
      
      if(goSmokey == 1){
      smokeyBits(x,y);
      }
      
      if(goInverse == 1){
       inverseMe();
      }

      if (mouseX < width /2) {
        posterizeMe();
        //PxPSetPixel(x, y, R, G, B, 255, pixels, width);    // sets the R,G,B values to the window
      } else {
        saturateMe();
       //PxPSetPixel(x, y, tempR, tempG, tempB, 255, pixels, width);
       //inverseMe();
          //PxPSetPixel(x, y, R, G, B, 255, pixels, width);  
      }
      
       PxPSetPixel(x, y, R, G, B, 255, pixels, width);  
    }
  }
  updatePixels();        //  must call updatePixels oce were done messing with pixels[]
  // println (frameRate);
  //println(tempR, tempG, tempB);

  println(origR, origG, origB);
  
  println(randomXThresh);
  
}

void posterizeMe() {
  
  // if (mouseX < width /2) {
  
  float average=(R+G+B / 3);
  if (average > posterizePointX) {
    R = 255;
    G = 255;
    B = 255;
  } else {
    R = 0;
    G = 0;
    B = 0;
  }

}

void inverseMe(){
      R=255-R;                                          // inverse the colors by subtracting from 255
      G=255-G;
      B=255-B;
 
}


void saturateMe() {
   
  
  if ( s < 255){
  s+=220;
   int saturation= s;
  R = R + saturation;
  G = G + saturation;
  B = B + saturation;
  }else {
   s = 0; 
  }
 
}

// Aiden's smokeyBits code from last weeks really made this sketch mesmerizing  

void smokeyBits(int x, int y) {
  
   //Aiden's code
      int pixel = x + y * width;
      if (pixels[pixel] != color(255, 255, 255)) {
        float randomX = random(1);
        if (randomX >= .22) {
          randomX = -randomXThresh;
        } else {
          randomX = randomXThresh;
        }
        float randomY = random(1);
        if (randomY >= .55) {
          randomY = -2;
        } else {
          randomY = 2;
        }
        int newX = x+int(randomX);
        int newY = y+int(randomY);
        if (newX < boxWidth && newY < boxHeight) {
        } else if (newX > 0 && newX < width && newY > 0 && newY < height) {
          if (random(101)>10) {
            pixels[newX+(newY)*width] = pixels[x+y*width];
          } else {
            pixels[x+(y)*width] = color(255, 255, 255);
          }
        }
      }
      //end Aiden's code
  
}




void mousePressed(MouseEvent evt) {
  if (evt.getCount() == 2)doubleClicked();
 
  
}


void doubleClicked() {
  posterizePointX = mouseX;
}


void mouseDragged() {  
  if (!(mouseX < boxWidth && mouseY <boxHeight)) {
    circle(mouseX, mouseY, size);
  }
}

void mouseReleased() {
  color c = get(mouseX, mouseY);
  if (c == color(2, 2, 2)) {
    size = size -20;
  } else if (c == color(1, 1, 1)) {
    size = size+20;
  } else if (c != color(0, 0, 0)) {
    fill(c);
    stroke(c);
  }
}


void keyPressed() {
   if (key == CODED) {

    if (keyCode == UP) {

      goSmokey = 0;

    } else if (keyCode == DOWN) {
       goSmokey = 1;
      print("down key");

    } else if (keyCode == LEFT){
      
     goInverse = 1;
    } else if (keyCode == RIGHT){
      
     goInverse = 0;
    } 

  } else {

    print("no key");

  }
  
  
  if (keyPressed) {
    if (key == 's' || key == 'S') {
     
      println("set smokey bits");
     setSmokeyBits = 1;
    
    
  } else if (key == 'd' || key == 'D') {
    setSmokeyBits = 0;
  }
  
  }

}



// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
//int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;


  origR = A;
  origG = G;
  origB = B;  
  origA = A;
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
