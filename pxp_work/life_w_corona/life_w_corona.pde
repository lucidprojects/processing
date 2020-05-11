// Life w/ Corona by jake sherwood 20200408
// modified video_glitch, video_ghost, video_random_frames, and camera_artisti_edges by Daniel Rozin
//
// various scenes and effects comment on the current global crisis 
// ofter distored by media and most of us find ourselves unable to turn it off.
// the second half is meant to remind us that we will get through this and there is still goodnews out there
// with postive messages and footage from John Krazinsky's Some Good News
// ending with video Capture of us (the viewer) putting ourselves back together again
//
// various effects and images happen at certain times through
// from 30s to 2mins mouse clicks add virus bouncing ball objects
// mouse pos and click control other elements throughout  


import ddf.minim.*; // minim library
Minim minim; // initialize minim
AudioPlayer sgnSong; // setup up sgn
AudioPlayer lightSong; // setup up light

Capture ourVideo;                

Virus[] viruses = new Virus[100];

PImage virusImg, sun; 
int total = 0;
int virusAlpha;
boolean doSlowSpread = false;
boolean doFastSpread = false;
boolean doGhostScale = false;

import processing.video.*;
Movie ourMovie, ourJumpMovie, virusMovie, coronaTrim, sunriseMovie, iLeotMovie, sgnMovie, sgnTrim;  // variable(s) to hold the videos


void setup() {
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start(); 
  sun = loadImage("sun_90.png");

  size(720, 480);
  ourMovie = new Movie(this, "face_mask_corona_sml.mp4"); 
  ourJumpMovie = new Movie(this, "face_mask_corona_sml.mp4"); 
  virusMovie = new Movie(this, "virus_trim.mp4");
  sunriseMovie = new Movie(this, "sunrise.mp4");
  sgnMovie = new Movie(this, "sgn_edit.mp4");

  ourMovie.play();
  sgnMovie.play();
  sgnMovie.volume(0);

  virusAlpha = 186;

  //setup audio objects
  minim = new Minim(this);
  sgnSong =  minim.loadFile("sgn_trim1.mp3");
  lightSong =  minim.loadFile("itally_leot1.mp3");


  virusImg = loadImage("corona.png");

  for (int i = 0; i < viruses.length; i++) {
    //viruses[i] = new Virus(virusImg);
    viruses[i] = new Virus(virusImg, random(0.85, 1.15), floor(random(127, 255)));
  }
}

void draw() {

  if (millis() < 86000)    
    cursor(virusImg);
  else  
  cursor(MOVE);


  //change videos and effects based on time/millis()
  if (millis() < 5000)
    image(ourMovie, 0, 0);
  else if (millis() < 11000 && millis() >= 5000) {
    glitchSquare();
  } else if (millis() < 28000  && millis() >= 11000)  
    ghostVid();
  else if (millis() < 28000 && millis() >= 11000) 
    image(ourMovie, 0, 0);
  else if (millis() < 54000 && millis() >= 28000) { 
    image(ourMovie, 0, 0);
    push();
    tint(255, 130, 24, virusAlpha);
    virusMovie.volume(0);
    virusMovie.play();
    image(virusMovie, 0, 0);
    pop();
  } else if (millis() < 86000 && millis() >= 54000) {
    push();
    randomFrames();
    pop();
  } else // if ( millis() >= 87000)
  image(ourMovie, 0, 0);   


  // play sunrise
  if (millis() >86000) {
    //background(255);

    image(sunriseMovie, 0, 0);  
    image(sgnMovie, 0, 0);


    virusAlpha = 220;
    sunriseMovie.loop();
    sunriseMovie.speed(4.0);
    total = 0;
    doSlowSpread = false;
    sgnMovie.volume(1.0);
    tint(255, virusAlpha);  
    ourMovie.stop();

    if (doGhostScale == true) 
      ghostVid_scale();




    // randomly play Good News & Light at the End of the Tunnel samples based on framecount.  randomly rewind so they can be replayed
    if (frameCount % 210 == 0) {
      sgnSong.play();
      println("try to plan SGN");
    }
    if (frameCount % 820 == 5) {
      lightSong.play();
      println("try to play Light");
    }
    if (frameCount % 2050 == 0) {
      sgnSong.rewind();
      lightSong.rewind();
      println("rewind");
    }
  }

  if (millis() > 200000)
    findYourself();


  //end everything
  if (millis() >= 405050) {
    sgnMovie.stop();
    sunriseMovie.stop();
    minim.stop();
    println("ended");
  }


  //end change videos and effects based on time/millis()



  //draw viruses slow
  if (millis() > 28000)  
    slowSpread();

  if (doSlowSpread == true) {
    for (int i = 0; i < total; i++) {
      viruses[i].display();
      viruses[i].bounce();
      viruses[i].shake();
      viruses[i].reScale();
      viruses[i].reTint();
    }
  }

  //draw viruses fast
  if (millis() > 5000)  
    fastSpread();


  if (doFastSpread == true) {
    for (int i = 0; i < total; i++) {
      viruses[i].displayRandom();
    }
  }

  println(millis());
  //print("my total = ");
  //println(total);
}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}  



void mousePressed() {
  total = total + 1;

  if ( millis() > 86000)
    doGhostScale = true;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      total = total - 1;
    }  
    if (keyCode == DOWN) {
      doGhostScale = false;
    }
  }
}



void glitchSquare() {
  int x = (int) random ( 0, width);  // randomizing 4 numbers for the rects
  int y = (int)random ( 0, width);
  int w =(int)random ( 50, 200);
  int h =(int)random ( 50, 200);
  blend(ourMovie, x, y, w, h, x, y, w, h, LIGHTEST);
}



void randomFrames() {
  float positon = random ( 0, ourJumpMovie.duration());
  image(ourJumpMovie, 0, 0);   
  ourJumpMovie.play();
  ourJumpMovie.volume(0);
  ourJumpMovie.jump(positon);
  ourJumpMovie.pause();
}


void ghostVid() {
  float transparency = map (mouseX, 0, width, 0, 10);
  tint (255, transparency);
  image(ourMovie, 0, 0);
}


void ghostVid_scale() {
  float transparency = map (mouseX, 0, width, 0, 10);
  tint (255, transparency);

  float ranScale = map (mouseY, 0, width, 0, 2);
  scale(ranScale);
  image(sgnMovie, 0, 0);
  //print("ghostvid scale");
}


//we'll figure out how to put ourselves back together after all of this
void findYourself() {
  if (ourVideo.available())  ourVideo.read();           // get a fresh frame as often as we can
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  int edgeAmount = 2;                                   // this will do a neighborhood of 9 pixels, 3x3
  for (int x =  edgeAmount; x< width-edgeAmount; x+=3) {     // lets skip every 3 pixels to make it fast 
    for (int y = edgeAmount; y< height-edgeAmount; y+=3) {    
      PxPGetPixel(x, y, ourVideo.pixels, width);          // get the R,G,B of the "our pixel" , the central pixel
      int thisR= R;                                         // place the RGB of our pixel in variables
      int thisG=G;
      int thisB=B;
      float colorDifference=0;
      for (int blurX=x- edgeAmount; blurX<=x+ edgeAmount; blurX++) {     // visit every pixel in the neighborhood
        for (int blurY=y- edgeAmount; blurY<=y+ edgeAmount; blurY++) {
          PxPGetPixel(blurX, blurY, ourVideo.pixels, width);     // get the RGB of our pixel and place in RGB globals
          colorDifference+=dist(R, G, B, thisR, thisG, thisB);         // dist calclates the distance in 3D colorspace beween the center pixel
        }                                                          // and the neighboring pixels and adds to "colorDifference"
      }
      int threshold = mouseX;                 
      if (colorDifference> threshold) {                           // if our pixel is an edge then draw a rect

        fill(thisR, thisG, thisB);
        noStroke();
        rect(x, y, 10, 10);
      }
    }
  }
  fill(255, 255, 255, 5);                              // fade to white by drawing trancelusent white rect above
  rect(0, 0, width, height);
}





void slowSpread() {
  if (millis() < 28000)
    doSlowSpread = false;
  else
    doSlowSpread = true;
}

void fastSpread() {
  if (millis() > 11000) {
    doFastSpread = false;
    //total = 0;
  } else
    doFastSpread = true;
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

//void mousePressed() {
//  background(255);
//}
//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
